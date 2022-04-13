FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "git://gerrit.mediatek.inc/gateway/rdk-b/rdkb_hal;protocol=https;destsuffix=git/source/platform/rdkb_hal"

SRC_URI_append += " \
   file://001-rdkb-utopia-build-issue.patch;apply=no \
   "
SRCREV = "${AUTOREV}"

DEPENDS += "utopia-headers"
CFLAGS_append = " \
    -I=${includedir}/utctx \
"

do_configure_prepend(){
    rm ${S}/platform_hal.c
    ln -sf ${S}/rdkb_hal/src/platform/platform_hal.c ${S}/platform_hal.c
}

do_mtk_patches() {
    cd ${S}/rdkb_hal
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/001-rdkb-utopia-build-issue.patch
        touch patch_applied
    fi
}

addtask mtk_patches after do_configure before do_compile