#!/bin/sh
# SIMET2 Measurement Agent self-healing for register and schedule
# Copyright (c) 2019 NIC.br
# Distributed under the GPLv3+

set +e

# force-renew registration
simet_register_ma.sh >/dev/null

(
  . /usr/lib/simet/simet_lib_config.sh && {
    # force-reload schedule if it is unreadable for whatever reason
    # as this might preclude the activation of the emergency schedule
    test -s "$LMAP_SCHEDULE_FILE" || simetbox_lmap-fetch-schedule.sh

    # force-reload schedule when too old (lmapd might have crashed)
    test -n "$(find "$LMAP_SCHEDULE_FILE" -mtime +1)" \
      && simetbox_lmap-fetch-schedule.sh
  }
)

# self-heal permissions
( . /etc/init.d/simet-lmapd && init_lmapd_fs )

# start lmapd if it was stopped.  Does the right things under procd
# FIXME: don't do this if the measurement engine is disabled
/etc/init.d/simet-lmapd start
:
