SUMMARY = "Custom wifi driver mt76 image package group for filogic boards"

LICENSE = "MIT"

inherit packagegroup


PACKAGES = " \
	  packagegroup-filogic-mt76 \
	"

RDEPENDS_packagegroup-filogic-mt76 = " \
    packagegroup-core-boot \
    wireless-tools \
    ${@bb.utils.contains('DISTRO_FEATURES','OneWifi','','hostapd',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','OneWifi','','wpa-supplicant',d)} \
    wireless-regdb-static \
    linux-mac80211 \
    linux-mt76 \
    iw \
    ubus  \
    ubusd \
    ${@bb.utils.contains('DISTRO_FEATURES','OneWifi','','usteer',d)} \
    uci \
    mt76-vendor \
    ${@bb.utils.contains('DISTRO_FEATURES','OneWifi','vts','wifi-test-tool',d)} \
    atenl \
    mt76-test \
    iwinfo \
    "
