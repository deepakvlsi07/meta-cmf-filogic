SUMMARY = "MediaTek Proprietary easymesh image package group for filogic boards"

LICENSE = "MIT"

inherit packagegroup

DEPENDS = "libnl"

PACKAGES = " \
	  packagegroup-filogic-mtk-easymesh \
	"

RDEPENDS_packagegroup-filogic-mtk-easymesh = " \
    1905daemon \
    datconf \
    libmapd \
    mapd \
    mapfilter \
    wappd \
    libwpactrl \
    "
