#!/bin/sh
# prepare hostapd patch
hostapd=0
wpa_supplicant=0

for arg in $*; do
	case "$arg" in
	"hostapd")
		hostapd=1
		;;
	"wpa_supplicant")
		wpa_supplicant=1
		;;
	*)
	esac
done

[ "$hostapd" = "1" ] && {
	SRC_DIR="../src/wifi/wlan_daemon/hostapd"
	MAKE_DIR="../meta-filogic-logan/recipes-wifi/hostapd/files"

	echo "prepare hostapd patch"
	mkdir ${MAKE_DIR}/patches
	cp -rf ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/patches/ ${MAKE_DIR}/
	cp -rf ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/src/ ${MAKE_DIR}/
	cp -rf ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/files/hostapd-full.config ${MAKE_DIR}/
	cp -rf ../meta-cmf-filogic/mtk_scripts/rdkb_inc_helper ${MAKE_DIR}/
	ver=`grep "PKG_SOURCE_VERSION" ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/Makefile | cut -c 21-`
	sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' ../meta-filogic-logan/recipes-wifi/hostapd/hostapd_2.10.bb
	cd ${MAKE_DIR}
	./rdkb_inc_helper patches
	mv patches.inc patches/
	rm rdkb_inc_helper
	sed -i 's/#include "wpa_supplicant_i.h"/#include "..\/..\/wpa_supplicant\/wpa_supplicant_i.h"/g' patches/mtk-hostapd-12map-000-mtk-map.patch
	cd -
}

[ "$wpa_supplicant" = "1" ] && {
	SRC_DIR="../src/wifi/wlan_daemon/hostapd"
	MAKE_DIR="../meta-filogic-logan/recipes-wifi/wpa-supplicant/files"

	echo "prepare wpa_supplicant patch"
	mkdir ${MAKE_DIR}/patches
	cp -rf ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/patches/ ${MAKE_DIR}/
	cp -rf ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/src/ ${MAKE_DIR}/
	cp -rf ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/files/wpa_supplicant-full.config ${MAKE_DIR}/
	cp -rf ../meta-cmf-filogic/mtk_scripts/rdkb_inc_helper ${MAKE_DIR}/
	ver=`grep "PKG_SOURCE_VERSION" ${SRC_DIR}/mt7988/mt7990/files/package/network/services/hostapd/Makefile | cut -c 21-`
	sed -i 's/SRCREV ?=.*/SRCREV ?= "'$ver'"/g' ../meta-filogic-logan/recipes-wifi/wpa-supplicant/wpa-supplicant_2.10.bb
	cd ${MAKE_DIR}
	./rdkb_inc_helper patches
	mv patches.inc patches/
	rm rdkb_inc_helper
	sed -i '/+OBJS += ..\/src\/ml\/ml_supplicant.o/ a +CFLAGS += -DHOSTAPD_PMKID_IN_DRIVER_SUPPORT\n+CFLAGS += -DCONFIG_MTK_PASSPOINT' patches/mtk-hostapd-0311be-000-mtk-mlo.patch
	sed -i 's/@@ -377,6 +377,14 @@ NEED_MD5=y/@@ -377,6 +377,16 @@ NEED_MD5=y/' patches/mtk-hostapd-0311be-000-mtk-mlo.patch
	cd -
}
