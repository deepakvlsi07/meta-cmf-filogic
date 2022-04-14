SRC_URI += "git://gerrit.mediatek.inc/gateway/rdk-b/rdkb_hal;protocol=https;destsuffix=git/source/ethsw/rdkb_hal"

SRCREV = "${AUTOREV}"

CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DFEATURE_RDKB_WAN_MANAGER ', '', d)}"

do_configure_prepend(){
   ln -sf ${S}/rdkb_hal/src/ethsw/ccsp_hal_ethsw.c ${S}/ccsp_hal_ethsw.c
}
