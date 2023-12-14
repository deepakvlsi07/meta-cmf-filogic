devidx=0

for _dev in /sys/class/ieee80211/*; do

	if [ "$_dev" == "/sys/class/ieee80211/phy0" ]; then
		main_inf=ra0
	elif [ "$_dev" == "/sys/class/ieee80211/phy1" ]; then
		main_inf=rai0
	elif [ "$_dev" == "/sys/class/ieee80211/phy2" ]; then
		main_inf=rax0	
	fi

	echo "dev: $devidx"
	echo "main_inf: $main_inf"

	if [ "$main_inf" == "ra0" ]; then
			echo "APINDEX_2G_PUBLIC_WIFI=0" >> /etc/tdk_platform.properties
			sed -i "s/\(AP_IF_NAME_2G *= *\).*/\1$main_inf/" /etc/tdk_platform.properties
			sed -i "s/\(RADIO_IF_2G *= *\).*/\1$main_inf/" /etc/tdk_platform.properties
	elif [ "$main_inf" == "rai0" ]; then
			echo "APINDEX_5G_PUBLIC_WIFI=1" >> /etc/tdk_platform.properties
			sed -i "s/\(AP_IF_NAME_5G *= *\).*/\1$main_inf/" /etc/tdk_platform.properties
			sed -i "s/\(RADIO_IF_5G *= *\).*/\1$main_inf/" /etc/tdk_platform.properties
	elif [ "$main_inf" == "rax0" ]; then
			echo "PRIVATE_6G_AP_INDEX=16" >> /etc/tdk_platform.properties
			echo "AP_IF_NAME_6G=$main_inf" >> /etc/tdk_platform.properties
			echo "RADIO_IF_6G=$main_inf" >> /etc/tdk_platform.properties
	fi

	devidx=$(($devidx + 1))
done


echo "DEFAULT_CHANNEL_BANDWIDTH=40MHz,160MHz" >> /etc/tdk_platform.properties
echo "RADIO_MODES_2G=n:11NGHT40MINUS:4,n:11NGHT40MINUS:8,ax:11AXHE40MINUS:32,ax:11AXHE40MINUS:0" >> /etc/tdk_platform.properties
echo "RADIO_MODES_5G=ac:11ACVHT80:16,n:11NAHT40MINUS:8,ax:11AXHE80:32,ax:11AXHE80:0" >> /etc/tdk_platform.properties
echo "getAp0DTIMInterval=1" >> /etc/tdk_platform.properties
echo "getAp1DTIMInterval=1" >> /etc/tdk_platform.properties
echo "DFS_SUPPORT=Enabled" >> /etc/tdk_platform.properties
echo "AP_AUTH_MODE_OPEN=1" >> /etc/tdk_platform.properties
echo "AP_AUTH_MODE_SHARED=2" >> /etc/tdk_platform.properties
echo "AP_AUTH_MODE_AUTO=4" >> /etc/tdk_platform.properties
sed -i "s/\(FRAGMENTATION_THRESHOLD_RANGE *= *\).*/\1256-2346/" /etc/tdk_platform.properties
echo "0" > /tmp/essid0.txt
echo "0" > /tmp/essid1.txt
echo "0" > /tmp/essid2.txt
