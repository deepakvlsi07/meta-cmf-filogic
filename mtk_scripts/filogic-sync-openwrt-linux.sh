#!/bin/sh
echo "clone repos"
git clone --branch openwrt-21.02 https://gerrit.mediatek.inc/openwrt/lede openwrt
git clone --branch master https://gerrit.mediatek.inc/openwrt/feeds/mtk_openwrt_feeds
git clone https://gerrit.mediatek.inc/gateway/rdk-b/meta-filogic
echo "sync openwrt kernel..........."
remove_patches(){
	echo "remove conflict patches"
	for aa in `cat remove.patch.list`
	do
		echo "rm $aa"
		rm -rf ./$aa
	done
	#remove old legacy mt7622 patch
	rm -rf ./target/linux/mediatek/patches-5.4/0303-mtd-spinand-disable-on-die-ECC.patch
}
cp -fpR mtk_openwrt_feeds/target ./openwrt
cp mtk_openwrt_feeds/remove.patch.list openwrt/
cd openwrt/
remove_patches
cd -

#flowblock
#remove openwrt netfiler patch for new flowblock offload
rm -rf openwrt/target/linux/generic/pending-5.4/64*.patch
rm -rf openwrt/target/linux/generic/hack-5.4/647-netfilter-flow-acct.patch
rm -rf openwrt/target/linux/generic/hack-5.4/650-netfilter-add-xt_OFFLOAD-target.patch
rm -rf openwrt/target/linux/mediatek/patches-5.4/1002-mtkhnat-add-support-for-virtual-interface-acceleration.patch
#cp flowblock patch
cp -rfa mtk_openwrt_feeds/autobuild_mac80211_release/target/ ./openwrt
#find flow patch to create ext patch for rdkb kernel build
cd openwrt/target/linux/mediatek/patches-5.4/
mkdir ../flow_patch
mv 1004-mtketh-*.patch ../flow_patch
mv 1007-mtketh-*.patch ../flow_patch
mv 99*.patch ../flow_patch
cd -
#end flowblock

echo "sync generic kernel..........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper openwrt/target/linux/generic/
cd openwrt/target/linux/generic/
./rdkb_inc_helper backport-5.4
mv backport-5.4.inc backport-5.4
./rdkb_inc_helper pending-5.4
mv pending-5.4.inc pending-5.4
./rdkb_inc_helper hack-5.4
mv hack-5.4.inc hack-5.4
cd -
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic/backport-5.4
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic/pending-5.4
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic/hack-5.4
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic/files
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic/files-5.4
cp -rf openwrt/target/linux/generic/backport-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic
cp -rf openwrt/target/linux/generic/pending-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic
cp -rf openwrt/target/linux/generic/hack-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic
cp -rf openwrt/target/linux/generic/files meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic
cp -rf openwrt/target/linux/generic/files-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic/
cp openwrt/target/linux/generic/config-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/generic/defconfig
echo "sync medaitek kernel..........."
cp meta-cmf-filogic/mtk_scripts/rdkb_inc_helper openwrt/target/linux/mediatek
cd openwrt/target/linux/mediatek
./rdkb_inc_helper patches-5.4/
mv patches-5.4.inc patches-5.4
sed -i 's/0600-net-phylink-propagate-resolved-link-config-via-mac_l.patch/&;apply=no/' patches-5.4/patches-5.4.inc
sed -i 's/9010-iwconfig-wireless-rate-fix.patch/&;apply=no/' patches-5.4/patches-5.4.inc
echo "do rework medaitek kernel patch done..........."
#cp 32bit dts
mkdir -p files-5.4/arch/arm/boot/dts/
cp -rf files-5.4/arch/arm64/boot/dts/mediatek/mt7986* files-5.4/arch/arm/boot/dts/
cd -
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek/patches-5.4
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek/files-5.4
cp -rf openwrt/target/linux/mediatek/patches-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek
cp -rf openwrt/target/linux/mediatek/files-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek
#cp platform kernel config
cp openwrt/target/linux/mediatek/mt7986/config-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek/mt7986.cfg
cp openwrt/target/linux/mediatek/mt7988/config-5.4 meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek/mt7988.cfg
#flowblock patch
rm -rf meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek/flow_patch
cp -rf openwrt/target/linux/mediatek/flow_patch meta-filogic/recipes-kernel/linux/linux-mediatek-5.4/mediatek
#end

echo "Update switch tool ...... "
cp -rf mtk_openwrt_feeds/feed/switch/src meta-filogic/recipes-devtools/switch/files/

echo "sync done..........."
