require ccsp_common_filogic.inc

DEPENDS_append_dunfell = " ccsp-lm-lite"

LDFLAGS_append_dunfell = " -lsafec-3.5.1"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

CFLAGS += " -DDHCPV4_CLIENT_UDHCPC -DDHCPV6_CLIENT_DIBBLER "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://0001-Fix-printf-wrong-argument-cause-build-failed.patch;apply=no \
"

do_filogic_ccspmisc_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch  -p1 < ${WORKDIR}/0001-Fix-printf-wrong-argument-cause-build-failed.patch
        touch patch_applied
    fi
}
addtask filogic_ccspmisc_patches after do_unpack before do_configure

