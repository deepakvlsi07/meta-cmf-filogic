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
    kernel-module-compat \
    kernel-module-cfg80211 \
    kernel-module-mac80211 \
    linux-mt76 \
    kernel-module-mt76 \
    kernel-module-mt7915e \
    iw \
    ethtool \
    ebtables \
    regs \
    mii-mgr \
    mtd \
    smp \
    mtk-factory-rw \
    "
