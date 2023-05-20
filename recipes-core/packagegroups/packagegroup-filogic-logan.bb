SUMMARY = "MediaTek Proprietary wifi driver logan package group for filogic boards"

LICENSE = "MIT"

inherit packagegroup

DEPENDS = "libnl"

PACKAGES = " \
	  packagegroup-filogic-logan \
	"

RDEPENDS_packagegroup-filogic-logan = " \
    packagegroup-core-boot \
    wireless-tools \
    linux-mac80211 \
    hostapd \
    wpa-supplicant \
    wireless-regdb-static \
    ubus  \
    ubusd \
    uci \
    lua \
    datconf \
    iwinfo \
    iw \
    warp \
    mt-wifi7 \
    mt-hwifi\
    mt-wifi-cmn \
    mtfwd \
    logan-insmod \
    mwctl \
    "
