#!/bin/sh
echo "clone.........."
git clone --branch master https://gerrit.mediatek.inc/openwrt/lede mac80211_package
git clone --branch master https://gerrit.mediatek.inc/openwrt/feeds/mtk_openwrt_feeds
git clone --branch master https://gerrit.mediatek.inc/gateway/autobuild_v5
git clone https://gerrit.mediatek.inc/gateway/rdk-b/meta-filogic

echo "copy.........."
mkdir -p mac80211_package/package/kernel/mt76/patches 
rm -rf mac80211_package/package/kernel/mac80211
cp -rfa mtk_openwrt_feeds/autobuild_mac80211_release/package/ mac80211_package/

echo "gen wifi mt76 patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/kernel/mt76
cd mac80211_package/package/kernel/mt76
./rdkb_inc_helper patches
mv patches.inc patches
cd -
rm -rf meta-filogic/recipes-wifi/linux-mt76/files/patches
cp -rf mac80211_package/package/kernel/mt76/patches meta-filogic/recipes-wifi/linux-mt76/files/

echo "gen wifi6 mac80211 patches.........."
tar xvf mtk_openwrt_feeds/autobuild_mac80211_release/package/kernel/mac80211/mac80211_v5.15.81_077622a1.tar.gz -C mac80211_package/package/kernel/
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
rm -rf meta-filogic/recipes-wifi/linux-mac80211/files/patches
cp -rf mac80211_package/package/kernel/mac80211/patches/patches meta-filogic/recipes-wifi/linux-mac80211/files

echo "copy mt76 firmware.........."
rm -rf meta-filogic/recipes-wifi/linux-mt76/files/src
cp -rf mac80211_package/package/kernel/mt76/src meta-filogic/recipes-wifi/linux-mt76/files/
cp -rf mtk_openwrt_feeds/target/linux/mediatek/mt7988/base-files/lib/firmware/mediatek/* meta-filogic/recipes-wifi/linux-mt76/files/src/firmware

echo "Update bb file version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/kernel/mt76/Makefile | cut -c 21-`
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-wifi/linux-mt76/mt76.inc
ver2=`grep "PKG_VERSION:=" mac80211_package/package/kernel/mac80211/Makefile | cut -c 14-`
sed -i 's/PV =.*/PV = "'${ver2%-*}'"/g' meta-filogic/recipes-wifi/linux-mac80211/linux-mac80211_5.15.%.bb
ver3=`grep "PKG_HASH" mac80211_package/package/kernel/mac80211/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${ver3}'"/g' meta-filogic/recipes-wifi/linux-mac80211/linux-mac80211_5.15.%.bb

echo "gen hostapd patches.........."
rm -rf mac80211_package/package/network/services/hostapd
tar xvf mtk_openwrt_feeds/autobuild_mac80211_release/package/network/services/hostapd/hostapd_v2.10_07730ff3.tar.gz -C mac80211_package/package/network/services/
cp -rf  mtk_openwrt_feeds/autobuild_mac80211_release/package/network/services/hostapd/patches/* mac80211_package/package/network/services/hostapd/patches
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/network/services/hostapd
cd mac80211_package/package/network/services/hostapd
./rdkb_inc_helper patches
mv patches.inc patches
echo "some patch do not apply to RDKB"
sed -i 's/450-scan_wait.patch/&;apply=no/' patches/patches.inc

cd -
rm -rf meta-filogic/recipes-wifi/hostapd/files/patches
rm -rf meta-filogic/recipes-wifi/wpa-supplicant/files/patches
cp -rf mac80211_package/package/network/services/hostapd/patches meta-filogic/recipes-wifi/hostapd/files/
cp -rf mac80211_package/package/network/services/hostapd/patches meta-filogic/recipes-wifi/wpa-supplicant/files/
rm -rf meta-filogic/recipes-wifi/hostapd/files/src
rm -rf meta-filogic/recipes-wifi/wpa-supplicant/files/src
cp -rf mac80211_package/package/network/services/hostapd/src meta-filogic/recipes-wifi/hostapd/files/
cp -rf mac80211_package/package/network/services/hostapd/src meta-filogic/recipes-wifi/wpa-supplicant/files/
echo "cp defconfig and remove ubus"
cp mac80211_package/package/network/services/hostapd/files/hostapd-full.config meta-filogic/recipes-wifi/hostapd/files/
cp mac80211_package/package/network/services/hostapd/files/wpa_supplicant-full.config meta-filogic/recipes-wifi/wpa-supplicant/files/
#sed -i 's/CONFIG_UBUS=y.*//g' meta-filogic/recipes-wifi/hostapd/files/hostapd-full.config
#sed -i 's/CONFIG_UBUS=y.*//g' meta-filogic/recipes-wifi/wpa-supplicant/files/wpa_supplicant-full.config

echo "Update hostapd bb file version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/network/services/hostapd/Makefile | cut -c 21-`
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-wifi/hostapd/hostapd_2.10.bb
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-wifi/wpa-supplicant/wpa-supplicant_2.10.bb
#cp openwrt hostapd script
cp -rf mac80211_package/package/network/services/hostapd/files/hostapd.sh meta-filogic/recipes-wifi/hostapd/files/openwrt_script/
cp -rf mac80211_package/package/kernel/mac80211/files/lib/netifd/wireless/mac80211.sh meta-filogic/recipes-wifi/hostapd/files/openwrt_script/
echo "GEN iw patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/network/utils/iw
cd mac80211_package/package/network/utils/iw
#remove patches not work for wifi hal 
rm -rf patches/200-reduce_size.patch

./rdkb_inc_helper patches
mv patches.inc patches

cd -
rm -rf meta-filogic/recipes-wifi/iw/patches
cp -rf mac80211_package/package/network/utils/iw/patches meta-filogic/recipes-wifi/iw
ver=`grep "PKG_VERSION:=" mac80211_package/package/network/utils/iw/Makefile | cut -c 14-`
newbb=iw_${ver}.bb
cd meta-filogic/recipes-wifi/iw/
oldbb=`ls *.bb`
echo "Update iw bb file name.........."
mv ${oldbb} ${newbb}
cd -

echo "Update iw bb hash .........."
hash1=`grep "PKG_HASH" mac80211_package/package/network/utils/iw/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${hash1}'"/g' meta-filogic/recipes-wifi/iw/${newbb}

echo "Gen wireless-regdb patches.........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/firmware/wireless-regdb/
cd mac80211_package/package/firmware/wireless-regdb/
./rdkb_inc_helper patches
mv patches.inc patches

cd -
rm -rf meta-filogic/recipes-wifi/wireless-regdb/files/patches
cp -rf mac80211_package/package/firmware/wireless-regdb/patches meta-filogic/recipes-wifi/wireless-regdb/files/
ver=`grep "PKG_VERSION:=" mac80211_package/package/firmware/wireless-regdb/Makefile | cut -c 14-`
newbb=wireless-regdb_${ver}.bb
cd meta-filogic/recipes-wifi/wireless-regdb/
oldbb=`ls *.bb`
echo "Update wireless-regdb bb file name.........."
mv ${oldbb} ${newbb}
cd -

echo "Update wireless-regdb bb hash.........."
hash1=`grep "PKG_HASH" mac80211_package/package/firmware/wireless-regdb/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${hash1}'"/g' meta-filogic/recipes-wifi/wireless-regdb/${newbb}

echo "Update libubox version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/libs/libubox/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic/recipes-wifi/libubox/libubox_git.bbappend

echo "Update ubus version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/system/ubus/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic/recipes-wifi/ubus/ubus_git.bb

echo "Update libnl-tiny version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/libs/libnl-tiny/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic/recipes-wifi/libnl-tiny/libnl-tiny_git.bb

echo "Update iwinfo version.........."
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/network/utils/iwinfo/Makefile | cut -c 21-`
sed -i 's/SRCREV =.*/SRCREV = "'$ver'"/g' meta-filogic/recipes-wifi/iwinfo/iwinfo_git.bb

echo "Update atenl ...... "
cp -rf mtk_openwrt_feeds/feed/atenl/src meta-filogic/recipes-wifi/atenl/files/
cp -f mtk_openwrt_feeds/feed/atenl/files/ated.sh meta-filogic/recipes-wifi/atenl/files/
cp -f mtk_openwrt_feeds/feed/atenl/files/iwpriv.sh meta-filogic/recipes-wifi/atenl/files/

echo "Update mt76-verdor ...... "
cp -rf mtk_openwrt_feeds/feed/mt76-vendor/src meta-filogic/recipes-wifi/mt76-vendor/files/

echo "Update Wmm Script ......."
cp -rf  autobuild_v5/mt7986-mac80211/target/linux/mediatek/base-files/sbin/wmm-*.sh  meta-filogic/recipes-wifi/wifi-test-tool/files/wmm_script

echo "update wifi7 mac80211"
rm -rf mac80211_package
git clone --branch master https://gerrit.mediatek.inc/openwrt/lede mac80211_package

rm -rf mtk_openwrt_feeds/autobuild_mac80211_release/package/kernel/mac80211
rm -rf mtk_openwrt_feeds/autobuild_mac80211_release/package/network/services/hostapd
cd mtk_openwrt_feeds/autobuild_mac80211_release/package/kernel/
mv mac80211_dev mac80211
cd -

echo "copy.........."
cp -rfa mtk_openwrt_feeds/autobuild_mac80211_release/package/ mac80211_package/
cp -rfa mtk_openwrt_feeds/autobuild_mac80211_release/mt7988_mt7996_mac80211/package/kernel/mac80211 mac80211_package/package/kernel/

echo "gen wifi7 mac80211 patches.........."
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
rm -rf meta-filogic/recipes-wifi/linux-mac80211/files/patches-6.x
cp -rf mac80211_package/package/kernel/mac80211/patches/patches meta-filogic/recipes-wifi/linux-mac80211/files/patches-6.x

ver2=`grep "PKG_VERSION:=" mac80211_package/package/kernel/mac80211/Makefile | cut -c 14-`
sed -i 's/PV =.*/PV = "'${ver2}'"/g' meta-filogic/recipes-wifi/linux-mac80211/linux-mac80211_6.%.bb
ver3=`grep "PKG_HASH" mac80211_package/package/kernel/mac80211/Makefile | cut -c 11-`
sed -i 's/SRC_URI\[sha256sum\].*/SRC_URI[sha256sum] = "'${ver3}'"/g' meta-filogic/recipes-wifi/linux-mac80211/linux-mac80211_6.%.bb

echo "mt76_3.x patches for backport-6.x support "
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mtk_openwrt_feeds/autobuild_mac80211_release/mt7988_mt7996_mac80211/package/kernel/mt76
cd mtk_openwrt_feeds/autobuild_mac80211_release/mt7988_mt7996_mac80211/package/kernel/mt76
./rdkb_inc_helper patches
mv patches.inc patches
cd -
rm -rf meta-filogic/recipes-wifi/linux-mt76/files/patches-3.x
cp -rf mtk_openwrt_feeds/autobuild_mac80211_release/mt7988_mt7996_mac80211/package/kernel/mt76/patches meta-filogic/recipes-wifi/linux-mt76/files/patches-3.x
#cp -rf meta-filogic/recipes-wifi/linux-mt76/files/patches meta-filogic/recipes-wifi/linux-mt76/files/patches-3.x
#rm -rf meta-filogic/recipes-wifi/linux-mt76/files/patches-3.x/*revert-for-backports*.patch
#sed -i 's/4003-mt76-revert-for-backports-5.15-wireless-stack.patch/&;apply=no/' meta-filogic/recipes-wifi/linux-mt76/files/patches-3.x/patches.inc

echo "gen new hostapd patches for mt76_3.x"

cp -rf  mtk_openwrt_feeds/autobuild_mac80211_release/package/network/services/hostapd_new/patches/* mac80211_package/package/network/services/hostapd/patches
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper mac80211_package/package/network/services/hostapd
cp -rfa mtk_openwrt_feeds/autobuild_mac80211_release/mt7988_mt7996_mac80211/package/network/services/hostapd mac80211_package/package/network/services/
cd mac80211_package/package/network/services/hostapd

./rdkb_inc_helper patches
mv patches.inc patches
echo "some patch do not apply to RDKB"
sed -i 's/450-scan_wait.patch/&;apply=no/' patches/patches.inc

echo "Update hostapd bb file version.........."
#define new hostapd version
new_hostapd_ver=2.10.3

cd -
ver=`grep "PKG_SOURCE_VERSION" mac80211_package/package/network/services/hostapd/Makefile | cut -c 21-`
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-wifi/hostapd/hostapd_${new_hostapd_ver}.bb
sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' meta-filogic/recipes-wifi/wpa-supplicant/wpa-supplicant_${new_hostapd_ver}.bb

rm -rf meta-filogic/recipes-wifi/hostapd/files/patches-${new_hostapd_ver}
rm -rf meta-filogic/recipes-wifi/wpa-supplicant/files/patches-${new_hostapd_ver}
cp -rf mac80211_package/package/network/services/hostapd/patches meta-filogic/recipes-wifi/hostapd/files/patches-${new_hostapd_ver}
cp -rf mac80211_package/package/network/services/hostapd/patches meta-filogic/recipes-wifi/wpa-supplicant/files/patches-${new_hostapd_ver}

echo "Sync from OpenWRT done , ready to commit meta-filogic!!!"
