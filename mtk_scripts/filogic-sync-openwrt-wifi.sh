#!/bin/sh
echo "clone.........."
git clone --branch master https://gerrit.mediatek.inc/openwrt/lede mac80211_package
git clone --branch openwrt-21.02 https://gerrit.mediatek.inc/openwrt/lede openwrt
git clone --branch master https://gerrit.mediatek.inc/openwrt/feeds/mtk_openwrt_feeds
git clone https://gerrit.mediatek.inc/gateway/rdk-b/meta-filogic

echo "copy.........."
mkdir -p mac80211_package/package/kernel/mt76/patches 
cp openwrt/package/kernel/mt76/patches/100-Revert-of-net-pass-the-dst-buffer-to-of_get_mac_addr.patch mac80211_package/package/kernel/mt76/patches 
cp -rfa mtk_openwrt_feeds/autobuild_mac80211_release/package/ mac80211_package/

echo "gen mt76 patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/kernel/mt76
cd mac80211_package/package/kernel/mt76
./rdkb_inc_helper patches
mv patches.inc patches
cd -
rm -rf meta-filogic/recipes-kernel/linux-mt76/files/patches
cp -rf mac80211_package/package/kernel/mt76/patches meta-filogic/recipes-kernel/linux-mt76/files/

echo "gen mac80211 patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/kernel/mac80211/patches
cd mac80211_package/package/kernel/mac80211/patches
./rdkb_inc_helper subsys/
./rdkb_inc_helper build/
mv subsys.inc subsys
mv build.inc build
mkdir patches
cp -r subsys patches
cp -r build patches
cd -
rm -rf meta-filogic/recipes-kernel/linux-mac80211/files/patches
cp -rf mac80211_package/package/kernel/mac80211/patches/patches meta-filogic/recipes-kernel/linux-mac80211/files

echo "copy mt76 firmware.........."
rm -rf meta-filogic/recipes-kernel/linux-mt76/files/src
cp -rf mac80211_package/package/kernel/mt76/src meta-filogic/recipes-kernel/linux-mt76/files/

echo "Update bb file version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/kernel/mt76/Makefile | cut -c 21-`
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-kernel/linux-mt76/linux-mt76.bb
ver2=`grep "PKG_VERSION:=" mac80211_package/package/kernel/mac80211/Makefile | cut -c 14-`
sed -i 's/PV =.*/PV = "'${ver2%-*}'"/g' meta-filogic/recipes-kernel/linux-mac80211/linux-mac80211.bb
ver3=`grep "PKG_HASH" mac80211_package/package/kernel/mac80211/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${ver3}'"/g' meta-filogic/recipes-kernel/linux-mac80211/linux-mac80211.bb

echo "gen hostapd patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/network/services/hostapd
cd mac80211_package/package/network/services/hostapd
./rdkb_inc_helper patches
mv patches.inc patches
echo "some patch do not apply to RDKB"
sed -i 's/450-scan_wait.patch/&;apply=no/' patches/patches.inc

cd -
rm -rf meta-filogic/recipes-connectivity/hostapd/files/patches
rm -rf meta-filogic/recipes-connectivity/wpa-supplicant/files/patches
cp -rf mac80211_package/package/network/services/hostapd/patches meta-filogic/recipes-connectivity/hostapd/files/
cp -rf mac80211_package/package/network/services/hostapd/patches meta-filogic/recipes-connectivity/wpa-supplicant/files/
rm -rf meta-filogic/recipes-connectivity/hostapd/files/src
rm -rf meta-filogic/recipes-connectivity/wpa-supplicant/files/src
cp -rf mac80211_package/package/network/services/hostapd/src meta-filogic/recipes-connectivity/hostapd/files/
cp -rf mac80211_package/package/network/services/hostapd/src meta-filogic/recipes-connectivity/wpa-supplicant/files/
echo "cp defconfig and remove ubus"
cp mac80211_package/package/network/services/hostapd/files/hostapd-full.config meta-filogic/recipes-connectivity/hostapd/files/
cp mac80211_package/package/network/services/hostapd/files/wpa_supplicant-full.config meta-filogic/recipes-connectivity/wpa-supplicant/files/
sed -i 's/CONFIG_UBUS=y.*//g' meta-filogic/recipes-connectivity/hostapd/files/hostapd-full.config
sed -i 's/CONFIG_UBUS=y.*//g' meta-filogic/recipes-connectivity/wpa-supplicant/files/wpa_supplicant-full.config

echo "Update hostapd bb file version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/network/services/hostapd/Makefile | cut -c 21-`
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-connectivity/hostapd/hostapd_2.10.bb
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.10.bb

echo "GEN iw patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/network/utils/iw
cd mac80211_package/package/network/utils/iw
./rdkb_inc_helper patches
mv patches.inc patches

cd -
rm -rf meta-filogic/recipes-connectivity/iw/patches
cp -rf mac80211_package/package/network/utils/iw/patches meta-filogic/recipes-connectivity/iw
ver=`grep "PKG_VERSION:=" mac80211_package/package/network/utils/iw/Makefile | cut -c 14-`
newbb=iw_${ver}.bb
cd meta-filogic/recipes-connectivity/iw/
oldbb=`ls *.bb`
echo "Update iw bb file name.........."
mv ${oldbb} ${newbb}
cd -

echo "Update iw bb hash .........."
hash1=`grep "PKG_HASH" mac80211_package/package/network/utils/iw/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${hash1}'"/g' meta-filogic/recipes-connectivity/iw/${newbb}

echo "Gen wireless-regdb patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/firmware/wireless-regdb/
cd mac80211_package/package/firmware/wireless-regdb/
./rdkb_inc_helper patches
mv patches.inc patches

cd -
rm -rf meta-filogic/recipes-kernel/wireless-regdb/files/patches
cp -rf mac80211_package/package/firmware/wireless-regdb/patches meta-filogic/recipes-kernel/wireless-regdb/files/
ver=`grep "PKG_VERSION:=" mac80211_package/package/firmware/wireless-regdb/Makefile | cut -c 14-`
newbb=wireless-regdb_${ver}.bb
cd meta-filogic/recipes-kernel/wireless-regdb/
oldbb=`ls *.bb`
echo "Update wireless-regdb bb file name.........."
mv ${oldbb} ${newbb}
cd -

echo "Update wireless-regdb bb hash.........."
hash1=`grep "PKG_HASH" mac80211_package/package/firmware/wireless-regdb/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${hash1}'"/g' meta-filogic/recipes-kernel/wireless-regdb/${newbb}

echo "Sync from OpenWRT done , ready to commit meta-filogic!!!"
