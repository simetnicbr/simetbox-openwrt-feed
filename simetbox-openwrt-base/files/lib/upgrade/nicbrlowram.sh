#
# NIC.br - lowram sysupgrade extensions
# Try to keep this under 4KiB, remove comments on install if required.
#

# detect low ram situation and do not do anything when we already have at least
# 10000 kiB free RAM (i.e. twice the largest NOR flash we care about on 32MiB
# boxes, since nothing sane has 16MiB NOR FLASH + 32MiB RAM).  Note that most
# of the cached memory is likely to be tmpfs.

# Must be a sysupgrade_pre_upgrade hook, because we need rmmod.
# besides, if we crash the kernel here, we won't misflash.
nicbr_lowram_preupgrade() {
	# do some fast cleanup unless we *really* have lots of RAM
	if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 40000 ] ; then
		rm -fr /tmp/opkg-lists
		for i in cron atd xinetd ; do
			[ -x "/etc/init.d/$i" ] && "/etc/init.d/$i" stop && echo "$0: $i stopped"
		done
		rm -fr /tmp/simet*
	fi

	# Don't slow things down unless low on free RAM...
	if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 10000 ] ; then
		# stop other "safe" services that are likely to be found on a SIMETBOX
		echo -n "$0: MemFree is low, trying to stop services: "
		for i in uhttpd lighttpd httpd apache \
			 sysntpd ntpd chronyd \
			 pptpd unbound dnsmasq named xupnpd \
			 zabbix_agentd easycwmpd ddns p910nd \
			 minidlna gpsd collectd ugps \
			 samba netserver adblock privoxy vsftpd ; do
			[ -x "/etc/init.d/$i" ] && ( "/etc/init.d/$i" stop ; echo -n "$i " )
		done
		echo
		sync && echo 3 > /proc/sys/vm/drop_caches

		# Don't do dangerous things unless we are _still_ low on free RAM...
		if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 10000 ] ; then
			echo "$0: MemFree is still low: attempting to remove wireless module stack..."
			# remove IEEE802.11 module stack, frees >1MiB
			# ar71xx specific, because the generic solution is rather dangerous:
			# you can't expect every module to safely rmmod (and yes, that's a bug)
			# this will force-down any involved interfaces
			for i in ath10k_pci ath10k_core ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 ; do
				rmmod $i >/dev/null 2>&1 || :
			done
		fi

		#FIXME: if still low, remove USB stack, saves ~0.5MiB
	fi
	:
}
append sysupgrade_pre_upgrade nicbr_lowram_preupgrade

nicbr_lowram() {
	# Free as much as possible in /tmp
	rm -fr /tmp/luci* /tmp/simet* /tmp/opkg*
	rm -fr /tmp/log/*

	sync && echo 3 > /proc/sys/vm/drop_caches

	# If we are still low on ram here, abort.  This is better
	# than the kernel OOM-killing something during mtd write.
	if [ "$( awk '/MemFree:/ { print $2 }' < /proc/meminfo )" -lt 10000 ] ; then
		# Assume we do not have enough free RAM to safely sysupgrade
		echo "FATAL: MemFree is less than 10000 kB, refusing to attempt a firmware write" >&2
		echo "Rebooting (system unmodified, upgrade aborted)..."
		unmount -a
		reboot -f
		sleep 5
		echo b 2>/dev/null >/proc/sysrq-trigger
		# Better to hang here if it refuses to reboot
		while sleep 10 ; do : ; done
		exit 1
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
fi
:
