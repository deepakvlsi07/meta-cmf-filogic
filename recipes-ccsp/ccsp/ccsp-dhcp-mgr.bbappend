require ccsp_common_filogic.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://fix-build-fail-issue.patch;apply=no \
"

do_filogic_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch  -p1 < ${WORKDIR}/fix-build-fail-issue.patch
        touch patch_applied
    fi
}
addtask filogic_patches after do_unpack before do_configure

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"