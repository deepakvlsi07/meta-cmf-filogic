require ccsp_common_filogic.inc
FILESEXTRAPATHS_append := "${THISDIR}/files:"

DEPENDS_append_dunfell = " safec"
LDFLAGS_append_dunfell = " -lsafec-3.5.1"

EXTRA_OECONF_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '--enable-wanmgr', '', d)}"

SRC_URI_append += " \
    file://Fix-ccsp-cm-agent-build-error.patch;apply=no \
"

do_filogic_patches() {
    cd ${S}

    if ${@bb.utils.contains( 'DISTRO_FEATURES', '2022q3_support', 'true', 'false', d)}; then
        patch -p1 < ${WORKDIR}/Fix-ccsp-cm-agent-build-error.patch
        touch filogic_patch_applied
    fi
}
addtask filogic_patches after do_unpack before do_configure

do_install_append() {
    # Config files and scripts
    install -m 644 ${S}/config-arm/CcspCMDM.cfg ${D}${prefix}/ccsp/cm/CcspCMDM.cfg
    install -m 644 ${S}/config-arm/CcspCM.cfg ${D}${prefix}/ccsp/cm/CcspCM.cfg
    install -m 644 ${S}/config-arm/TR181-CM.XML ${D}${prefix}/ccsp/cm/TR181-CM.XML

    # delete files that are installed by some other package
    rm -f ${D}/usr/include/ccsp/cosa_apis.h
    rm -f ${D}/usr/include/ccsp/cosa_apis_busutil.h
    rm -f ${D}/usr/include/ccsp/cosa_dml_api_common.h
}
