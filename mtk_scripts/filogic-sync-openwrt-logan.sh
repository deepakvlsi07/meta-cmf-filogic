#!/bin/sh
echo "clone.........."
git clone --branch master https://gerrit.mediatek.inc/openwrt/lede mac80211_package
git clone --branch master https://gerrit.mediatek.inc/openwrt/feeds/mtk_openwrt_feeds
git clone --branch master https://gerrit.mediatek.inc/gateway/autobuild_v5
git clone https://gerrit.mediatek.inc/gateway/rdk-b/meta-filogic-logan
git clone https://gerrit.mediatek.inc/gateway/rdk-b/meta-filogic


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
