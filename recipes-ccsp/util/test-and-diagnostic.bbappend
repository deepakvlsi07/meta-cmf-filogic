require recipes-ccsp/ccsp/ccsp_common_filogic.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://fix_64bit_build_error.patch;apply=no \
"

do_filogic_patches() {
    cd ${S}
    if [ ! -e patch_applied ] && [ -e ${S}/source/dmltad/cosa_wanconnectivity_operations.c ]; then
        patch  -p1 < ${WORKDIR}/fix_64bit_build_error.patch ${S}/source/dmltad/cosa_wanconnectivity_operations.c
        touch patch_applied
    fi
}
addtask filogic_patches after do_unpack before do_configure

do_install_append () {
    # Test and Diagonastics XML 
       install -m 644 ${S}/config/TestAndDiagnostic_arm.XML ${D}/usr/ccsp/tad/TestAndDiagnostic.XML
}

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"
