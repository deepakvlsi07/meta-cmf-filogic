#!/bin/sh
echo "clone.........."
git clone --branch master https://gerrit.mediatek.inc/openwrt/lede mac80211_package
git clone --branch master https://gerrit.mediatek.inc/openwrt/feeds/mtk_openwrt_feeds
git clone --branch master https://gerrit.mediatek.inc/gateway/autobuild_v5
git clone --branch master https://gerrit.mediatek.inc/gateway/big_sw
git clone --branch master https://gerrit.mediatek.inc/gateway/rdk-b/meta-filogic-logan
git clone --branch master https://gerrit.mediatek.inc/gateway/rdk-b/meta-filogic

echo "sync hostapd patch from openWrt"
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd
cd autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd
./rdkb_inc_helper patches
mv patches.inc patches

cd -
rm -rf meta-filogic-logan/recipes-wifi/hostapd/files/patches
rm -rf meta-filogic-logan/recipes-wifi/wpa-supplicant/files/patches
cp -rf autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd/patches meta-filogic-logan/recipes-wifi/hostapd/files/
cp -rf autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd/patches meta-filogic-logan/recipes-wifi/wpa-supplicant/files/
rm -rf meta-filogic-logan/recipes-wifi/hostapd/files/src
rm -rf meta-filogic-logan/recipes-wifi/wpa-supplicant/files/src
cp -rf autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd/src meta-filogic-logan/recipes-wifi/hostapd/files/
cp -rf autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd/src meta-filogic-logan/recipes-wifi/wpa-supplicant/files/
echo "cp defconfig and remove ubus"
cp autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd/files/hostapd-full.config meta-filogic-logan/recipes-wifi/hostapd/files/
cp autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd/files/wpa_supplicant-full.config meta-filogic-logan/recipes-wifi/wpa-supplicant/files/

echo "Update hostapd bb file version.........."
ver=`grep "PKG_SOURCE_VERSION" autobuild_v5/mt7988-mt7990-BE19000/package/network/services/hostapd/Makefile | cut -c 21-`
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic-logan/recipes-wifi/hostapd/hostapd_2.10.bb
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic-logan/recipes-wifi/wpa-supplicant/wpa-supplicant_2.10.bb

echo "sync wifi profile from openWrt"
#remove old profile
rm -rf meta-filogic-logan/recipes-wifi/mt-wifi7/files/wireless/mediatek

#copy new profile from openwrt
mkdir -p meta-filogic-logan/recipes-wifi/mt-wifi7/files/wireless/mediatek
cp -f big_sw/mtk/drivers/wifi-profile/files/mt7990/* meta-filogic-logan/recipes-wifi/mt-wifi7/files/wireless/mediatek


echo "sync wifi config from openWrt"
#remove old config
rm -rf meta-filogic-logan/recipes-wifi/mt-wifi7/files/config

#copy new config from openwrt
mkdir -p meta-filogic-logan/recipes-wifi/mt-wifi7/files/config
#copy origin openwrt config
cp -f autobuild_v5/mt7988-mt7990-BE19000/.config meta-filogic-logan/recipes-wifi/mt-wifi7/files/config/openwrt_mt7990-be19000_config
cp -f autobuild_v5/mt7988-mt7992-BE7200/.config meta-filogic-logan/recipes-wifi/mt-wifi7/files/config/openwrt_mt7992-be7200_config
cp meta-cmf-filogic/mtk_scripts/rdkb_logan_config_helper meta-filogic-logan/recipes-wifi/mt-wifi7/files/config
cp meta-filogic-logan/recipes-wifi/mt-wifi7/files/make-l1profile.py meta-filogic-logan/recipes-wifi/mt-wifi7/files/config
#gen wifi config and l1 profile by different openwrt config
cd meta-filogic-logan/recipes-wifi/mt-wifi7/files/config
./rdkb_logan_config_helper openwrt_mt7990-be19000_config mt7990-be19000
./rdkb_logan_config_helper openwrt_mt7992-be7200_config mt7992-be7200
python make-l1profile.py openwrt_mt7990-be19000_config mt7990-be19000.dat
python make-l1profile.py openwrt_mt7992-be7200_config mt7992-be7200.dat
#remove script
rm -f rdkb_logan_config_helper
rm -f make-l1profile.py

cd -

echo "GEN iw patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/network/utils/iw
cd mac80211_package/package/network/utils/iw
#remove patches not work for wifi hal 
rm -rf patches/200-reduce_size.patch

./rdkb_inc_helper patches
mv patches.inc patches

cd -
rm -rf meta-filogic-logan/recipes-wifi/iw/patches
cp -rf mac80211_package/package/network/utils/iw/patches meta-filogic-logan/recipes-wifi/iw
ver=`grep "PKG_VERSION:=" mac80211_package/package/network/utils/iw/Makefile | cut -c 14-`
newbb=iw_${ver}.bb
cd meta-filogic-logan/recipes-wifi/iw/
oldbb=`ls *.bb`
echo "Update iw bb file name.........."
mv ${oldbb} ${newbb}
cd -

echo "Update iw bb hash .........."
hash1=`grep "PKG_HASH" mac80211_package/package/network/utils/iw/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${hash1}'"/g' meta-filogic-logan/recipes-wifi/iw/${newbb}



echo "Update libubox version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/libs/libubox/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic-logan/recipes-wifi/libubox/libubox_git.bbappend

echo "Update ubus version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/system/ubus/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic-logan/recipes-wifi/ubus/ubus_git.bb

echo "Update libnl-tiny version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/libs/libnl-tiny/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic-logan/recipes-wifi/libnl-tiny/libnl-tiny_git.bb

echo "Update iwinfo version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/network/utils/iwinfo/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic-logan/recipes-wifi/iwinfo/iwinfo_git.bb

echo "sync ccsp hal wifi-test-tool from meta-filogic"
rm -rf meta-filogic-logan/recipes-wifi/ccsp
cp -rf meta-filogic/recipes-wifi/ccsp meta-filogic-logan/recipes-wifi/ccsp
rm -rf meta-filogic-logan/recipes-wifi/hal/files meta-filogic-logan/recipes-wifi/hal/halinterface.bbappend
cp -rf meta-filogic/recipes-wifi/hal/files meta-filogic-logan/recipes-wifi/hal/files
cp -f  meta-filogic/recipes-wifi/hal/halinterface.bbappend meta-filogic-logan/recipes-wifi/hal/halinterface.bbappend
rm -rf meta-filogic-logan/recipes-wifi/wifi-test-tool
cp -rf meta-filogic/recipes-wifi/wifi-test-tool meta-filogic-logan/recipes-wifi/wifi-test-tool
echo "Sync from OpenWRT done , ready to commit meta-filogic-logan!!!"
