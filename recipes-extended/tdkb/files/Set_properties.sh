devidx=0
phyidx=0

for _dev in /sys/class/ieee80211/*; do
        [ -e "$_dev" ] || continue
        if [ "$(uci get wireless.radio${phyidx}.disabled)" == "1" ]; then
                phyidx=$((phyidx + 1))
                continue
        fi

        echo "dev: $devidx"
        echo "phy: $phyidx"

        band="$(uci get wireless.radio${phyidx}.band)"

        if [ "$band" == "2g" ]; then
                echo "APINDEX_2G_PUBLIC_WIFI=$devidx" >> /etc/tdk_platform.properties
                sed -i "s/\(AP_IF_NAME_2G *= *\).*/\1wifi$devidx/" /etc/tdk_platform.properties
                sed -i "s/\(RADIO_IF_2G *= *\).*/\1wlan$devidx/" /etc/tdk_platform.properties
        elif [ "$band" == "5g" ]; then
                echo "APINDEX_5G_PUBLIC_WIFI=$devidx" >> /etc/tdk_platform.properties
                sed -i "s/\(AP_IF_NAME_5G *= *\).*/\1wifi$devidx/" /etc/tdk_platform.properties
                sed -i "s/\(RADIO_IF_5G *= *\).*/\1wlan$devidx/" /etc/tdk_platform.properties
        elif [ "$band" == "6g" ]; then
                echo "PRIVATE_6G_AP_INDEX=$devidx" >> /etc/tdk_platform.properties
                echo "AP_IF_NAME_6G=wifi$devidx" >> /etc/tdk_platform.properties
                echo "RADIO_IF_6G=wlan$devidx" >> /etc/tdk_platform.properties
        fi

        devidx=$(($devidx + 1))
        phyidx=$(($phyidx + 1))
done


echo "DEFAULT_CHANNEL_BANDWIDTH=20MHz,20MHz" >> /etc/tdk_platform.properties
echo "RADIO_MODES_2G=n:11NGHT40MINUS:4,n:11NGHT40MINUS:8,ax:11AXHE40MINUS:32,ax:11AXHE40MINUS:0" >> /etc/tdk_platform.properties
echo "RADIO_MODES_5G=ac:11ACVHT80:16,n:11NAHT40MINUS:8,ax:11AXHE80:32,ax:11AXHE80:0" >> /etc/tdk_platform.properties
echo "getAp0DTIMInterval=1" >> /etc/tdk_platform.properties
echo "getAp1DTIMInterval=1" >> /etc/tdk_platform.properties
