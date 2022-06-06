FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_filogic = " file://999-mtk-add-vendor.patch;apply=no"
SRC_URI_append_filogic = " file://999-mtk-fix-64bit-build.patch;apply=no"

do_filogic_patches() {
    cd ${S}/../
        if [ ! -e patch_applied ]; then
            patch -p1 < ${WORKDIR}/999-mtk-add-vendor.patch
            patch -p1 < ${WORKDIR}/999-mtk-fix-64bit-build.patch
            touch patch_applied
        fi
}

addtask filogic_patches after do_patch before do_compile
