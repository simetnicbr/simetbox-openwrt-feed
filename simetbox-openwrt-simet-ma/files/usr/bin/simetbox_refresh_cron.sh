#!/bin/sh
# SIMET2 Measurement Agent self-healing for register and schedule
# Copyright (c) 2019 NIC.br
# Distributed under the GPLv3+

set +e

# self-heal permissions
( . /etc/init.d/simet-ma && init_simetma_fs )
( . /etc/init.d/simet-lmapd && init_lmapd_fs )

# force-renew registration
start-stop-daemon -S -c nicbr-simet:nicbr-simet -n simet_reg_ma \
                  -x /usr/bin/simet_register_ma.sh >/dev/null

(
  . /usr/lib/simet/simet_lib_config.sh && \
  . /usr/lib/simet/simet_lib_lmapd.sh && \
  LMAP_SCHEDULE_FILE=$(lmapd_get_sched_filename main) && \
  [ -n "$LMAP_SCHEDULE_FILE" ] && {
    # force-reload schedule if it is unreadable for whatever reason
    # as this might preclude the activation of the emergency schedule
    # also force-reload schedule when too old (lmapd might have crashed)
    DOIT=
    [ -s "$LMAP_SCHEDULE_FILE" ] || DOIT=1
    [ -z "$DOIT" ] && test -n "$(find "$LMAP_SCHEDULE_FILE" -type f -mtime +1)" && DOIT=1
    [ -n "$DOIT" ] && {
      start-stop-daemon -S -c nicbr-simet:nicbr-simet -n simet_fetch_sched \
                        -x simetbox_lmap-fetch-schedule.sh
    }
  }
)

# start simet-ma and lmapd if they were stopped.  Does the right things under procd
# FIXME: don't do this if the measurement engine is disabled
/etc/init.d/simet-ma start || true
/etc/init.d/simet-lmapd start || true
:
