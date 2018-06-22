#
# NIC.br - lowram sysupgrade extensions
# Copyright (c) 2018 NIC.br
# distributed under the same license as OpenWRT sysupgrade
#

# Detect low ram situation and do not do anything if it would cause us to
# misflash, due to partial tarballs, or getting killed by the kernel OOMK.
# Also detect corrupt config tarballs (using gzip -dc >/dev/null), since
# sysupgrade could generate one of those during OOM.


nicbr_update_oomkscore() {
if [ -r /proc/$$/oom_score_adj ] && [ "$(cat /proc/$$/oom_score_adj)" -gt "$1" ] ; then
	printf "%d" "$1" > /proc/$$/oom_score_adj
fi
:
}

## HIGH PRIORITY ADJUSTMENTS
##   By default, make it hard but not impossible for the kernel OOMK
##   to select sysupgrade and its children
nicbr_update_oomkscore -500

nicbr_no_new_processes() {
	if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 20000 ] ; then
		rm -fr /tmp/opkg-lists
		for i in cron atd xinetd ; do
			[ -x "/etc/init.d/$i" ] && "/etc/init.d/$i" stop && \
				echo "$0: service $i stopped" >&2
		done

		# nicbr SIMET-specific:
		SIMET_KILL="run_simet.sh simet_dns_ping_traceroute.sh simet_ping.sh simet_traceroute.sh simetbox_register.sh simet_send_if_traffic.sh simet_client simet_alexa simet_bcp38 simet_dns simet_ntpq simet_porta25 simet_tools simet_ws"
		for i in 1 2 ; do
			killall -q -TERM $SIMET_KILL
			sleep 1
		done
		for i in 1 2 ; do
			killall -q -KILL $SIMET_KILL
			sleep 1
		done
		rm -fr /tmp/simet*

		#FIXME: we want a reboot even if we don't upgrade, because se stopped stuff.
	fi
	:
}

nicbr_reboot(){
	echo "Upgrade aborted, system firmware and configuration unmodified" >&2
	echo "Rebooting (system is possibly in a downgraded state)..." >&2
	unmount -a
	reboot -f
	sleep 5
	echo b 2>/dev/null >/proc/sysrq-trigger
	# Better to hang here if it refuses to reboot
	while sleep 1000 ; do : ; done
	exit 1
}

# Runs before attempting to create a config image, so early RAM freeing
# can be done here.  It is a hook abuse, but this way we only run when
# we are actually trying to update firmware.
nicbr_lowram_preconf() {
	if [ "$TEST" -ne 1 ]; then
		nicbr_no_new_processes
	fi
	:
}
append sysupgrade_image_check nicbr_lowram_preconf

# Runs before creating the conffile tarball
# Required because sysupgrade is foolhardy enough to NOT check
# whether tar actually managed to write the damn tarball or not
nicbr_lowram_conffile() {
	if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 1000 ] ; then
		sync && echo 3 > /proc/sys/vm/drop_caches
		if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 1000 ] ; then
			echo "$0: FATAL: MemFree is too low to ensure configuration will be preserved" >&2
			# because we likely killed stuff, otherwise we could just abort
			nicbr_reboot
		fi
	fi
	:
}
append sysupgrade_init_conffiles nicbr_lowram_conffile

# Cannot run too late  because we need rmmod.  Besides, if we crash the
# kernel here, we won't misflash.
#
# Very annoyingly, most damage is done when you run out of RAM *before*
# this, while sysupgade is trying to preserve config in a tarball.
nicbr_lowram_preupgrade() {
	# ensure conf tarball is sane, if any.  We *really* want to move
	# this to openwrt itself.
	if [ "$SAVE_CONFIG" -ne 0 ] ; then
		if ! gzip -dc "$CONF_TAR" >/dev/null 2>&1 ; then
			echo "$0: FATAL: $CONF_TAR missing, or has a corrupt gzip container" >&2
			nicbr_reboot
			exit 1
		fi
	fi

	# free up more memory
	if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 10000 ] ; then
		# stop other "safe" services that are likely to be found on a SIMETBOX
		echo "$0: MemFree is low, trying to stop services... " >&2
		for i in uhttpd lighttpd httpd apache \
			 sysntpd ntpd chronyd \
			 pptpd unbound dnsmasq named xupnpd \
			 zabbix_agentd easycwmpd ddns p910nd \
			 minidlna gpsd collectd ugps \
			 samba netserver adblock privoxy vsftpd ; do
			[ -x "/etc/init.d/$i" ] && \
				( "/etc/init.d/$i" stop ; echo "$0: service: $i stopped" >&2 )
		done

		sync && echo 3 > /proc/sys/vm/drop_caches

		# Don't do dangerous things unless we are _still_ low on free RAM...
		if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 8000 ] ; then
			echo "$0: MemFree is still low: attempting to remove wireless module stack..." >&2
			# remove IEEE802.11 module stack, frees >1MiB
			# ar71xx specific, because the generic solution is rather dangerous:
			# you can't expect every module to safely rmmod (and yes, that's a bug)
			# this will force-down any involved interfaces
			for i in ath10k_pci ath10k_core ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 ; do
				rmmod $i >/dev/null 2>&1 && echo "$0: module $i removed" >&2
			done
		fi

		#FIXME? if still low, remove USB stack, saves ~0.5MiB
	fi
	:
}
append sysupgrade_pre_upgrade nicbr_lowram_preupgrade

# Runs after most processes have been killed, but we don't have rmmod here
nicbr_lowram() {
	# the last stage needs far less RAM to sucessfully complete [on ar71xx]...
	if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 4000 ] ; then
		rm -fr /tmp/luci* /tmp/simet* /tmp/opkg*
		rm -fr /tmp/log/* /tmp/p910*

		sync && echo 3 > /proc/sys/vm/drop_caches

		if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 4000 ] ; then
			# Assume we do not have enough free RAM to safely sysupgrade
			echo "$0: FATAL: MemFree is still too low, refusing to attempt a firmware write" >&2
			nicbr_reboot
			exit 1
		fi
	fi
	:
}

# Detect when we are at stage2 (after kill_remaining has run)
# because there isn't a proper hook for this. Argh.
#
# LEDE-17.01:      /tmp/sysupgrade (file) exists
# openwrt-18.06:   we have been sourced by stage2
if [ -f /tmp/sysupgrade ] || [ "${0##*/}" = "stage2" ] ; then
	nicbr_lowram
	# disable kernel OOMK for sysupgrade late stage and its children
	nicbr_update_oomkscore -1000
fi
:
