#!/bin/sh
. /etc/config/simet.conf
family=$1

ping $family -qc3 nic.br > /dev/null 2> /dev/null
if [ $? -eq 0 ]; then
	while IFS= read -r line; do
		interface="`echo $line | /usr/bin/awk -F, {'print $1'}`"
		status="`echo $line | /usr/bin/awk -F, {'print $2'}`"
		data="`echo $line | /usr/bin/awk -F, {'print $3'}`"
		mac_address=`get_mac_address.sh`;
		uptime="`echo $line | /usr/bin/awk -F, {'print $4'}`"
		insert_uptime=`cat /proc/uptime | awk -F. {'print $1'}`;
		# echo "$interface -> $status -> $data"
		envia_results=`simet_ws $family "http://$cf_host/$cf_simet_web_services_optional/InterfaceStatus?interfaceStatusType=$status&hashDevice=$mac_address&uptime=$uptime&interfaceName=$interface&timestampEvent=$data&insertUptime=$insert_uptime"`;
		# echo "$envia_results"
	done < /etc/config/ifupdown.data
	rm /etc/config/ifupdown.data
	touch /etc/config/ifupdown.data
fi
