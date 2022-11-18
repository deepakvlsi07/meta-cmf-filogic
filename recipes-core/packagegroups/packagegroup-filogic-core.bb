SUMMARY = "Custom core image package group for filogic boards"

LICENSE = "MIT"

inherit packagegroup

DEPENDS = "libnl"

PACKAGES = " \
	  packagegroup-filogic-core \
	"

RDEPENDS_packagegroup-filogic-core = " \
    packagegroup-core-boot \
    wireless-tools \
    hostapd \
    wpa-supplicant \
    wireless-regdb-static \
    linux-mac80211 \
    linux-mt76 \
    iw \
    ubus  \
    ubusd \
    usteer \
    uci \
    mt76-vendor \
    wifi-test-tool \
    atenl \
    mt76-test \
    iwinfo \
    "
