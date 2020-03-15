#!/bin/sh
# SIMET2 Measurement Agent self-healing for register and schedule
# Copyright (c) 2019 NIC.br
# Distributed under the GPLv3+

set +e

# force-renew registration
simet_register_ma.sh >/dev/null

# force-reload schedule when too old (lmapd might have crashed)
. /usr/lib/simet/simet_lib_config.sh \
	&& test -n "$(find $LMAP_SCHEDULE_FILE -mtime +1)" \
	&& simetbox_lmap-fetch-schedule.sh || true

# self-heal permissions
. /etc/init.d/simet-lmapd && init_lmapd_fs
:
