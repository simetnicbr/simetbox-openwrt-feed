#!/bin/sh

. /lib/functions.sh

# internal openwrt API, but works from 12.09 to 18.06+
[ -e /tmp/sysinfo/model ] && {
	sed -e 's/[ ,;#$%&\!/]/_/g' -e 's/_\+/_/g' < /tmp/sysinfo/model
	exit 0
}

# do it the hard (and expensive) way
. /usr/share/libubox/jshn.sh
json_init
json_load "$(ubus call system board)" || {
	echo "unknown"
	exit 0
}
json_get_var boardname board_name
json_get_var model model
json_select release
json_get_var target target

if [ -n "$model" ] ; then
	machine="$model"
elif [ -n "$boardname" ] ; then
	[ -n "$target" ] && target="${target}_"
	machine="${target}${boardname}"
elif [ -n "$target" ] ; then
	machine="$target"
else
	# catch-all, because things just don't work well when it is empty
	machine="unknown"
fi

echo "$machine" | sed -e 's/[ ,;#$%&\!/]/_/g' -e 's/_\+/_/g'
