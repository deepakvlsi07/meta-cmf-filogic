#!/bin/sh

create_hostapdConf() {
	devidx=0
	phyidx=0
	old_path=""
	pcie7915count=0
    vap_per_radio=8
    radio_num="$(iw list | grep Wiphy | wc -l)"

    for _dev in /sys/class/ieee80211/*; do
		[ -e "$_dev" ] || continue

		dev="${_dev##*/}"

        band="$(uci get wireless.radio${phyidx}.band)"
        channel="$(uci get wireless.radio${phyidx}.channel)"
        # Use random MAC to prevent use the same MAC address
        rand="$(hexdump -C /dev/urandom | head -n 1 | awk '{printf ""$3":"$4""}' &)"
        killall hexdump
        MAC="00:0${devidx}:12:34:${rand}"
        chip="$(cat /sys/class/ieee80211/"$dev"/device/device)"

        if [ $chip == "0x7915" ]; then
            path="$(realpath /sys/class/ieee80211/"$dev"/device | cut -d/ -f4-)"
            if [ -n "$path" ]; then
                if [ "$path" == "$old_path" ] || [ "$old_path" == "" ]; then
                    pcie7915count="1"
                else
                    pcie7915count="2"    
                fi
            fi
            old_path=$path
        fi

        if [ -e /sys/class/net/wlan$phyidx ]; then
            iw wlan$phyidx del > /dev/null
        fi

        if [ "$(uci get wireless.radio${phyidx}.disabled)" == "1" ]; then
            phyidx=$(($phyidx + 1))
			continue
        fi
        if [ "$band" == "2g" ]; then
            iw phy phy$phyidx interface add wifi0 type __ap > /dev/null
        fi
        if [ "$band" == "5g" ]; then
            iw phy phy$phyidx interface add wifi1 type __ap > /dev/null
        fi
        if [ "$band" == "6g" ]; then
            iw phy phy$phyidx interface add wifi2 type __ap > /dev/null
        fi
        #iw phy phy$phyidx interface add wifi$devidx type __ap > /dev/null
        #touch /tmp/$dev-wifi$devidx
        devidx=$(($devidx + 1))
        phyidx=$(($phyidx + 1))
		
	done
}
#Creating files for tracking AssociatedDevices
touch /tmp/AllAssociated_Devices_2G.txt
touch /tmp/AllAssociated_Devices_5G.txt

#Create wps pin request log file
touch /var/run/hostapd_wps_pin_requests.log


create_hostapdConf

exit 0
