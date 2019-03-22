#!/bin/sh
# SIMET2 Measurement Agent self-healing for register and schedule
# Copyright (c) 2019 NIC.br
# Distributed under the GPLv3+

set +e

simet_register_ma.sh >/dev/null

[ -r /opt/simet/lib/simet/simet-ma.conf ] && . /opt/simet/lib/simet/simet-ma.conf
[ -r /opt/simet/etc/simet/simet-ma.conf ] && . /opt/simet/etc/simet/simet-ma.conf
LMAP_SCHEDULE_FILE="${LMAP_SCHEDULE_FILE:-/var/run/lmapd/lmap-schedule.json}"
test -n "$(find $LMAP_SCHEDULE_FILE -mtime +1)" && simetbox_lmap-fetch-schedule.sh

# self-heal permissions
. /etc/init.d/simet-lmapd && init_lmapd_fs

:
