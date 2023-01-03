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
    hostapd \
    wpa-supplicant \
    wireless-regdb-static \
    "
