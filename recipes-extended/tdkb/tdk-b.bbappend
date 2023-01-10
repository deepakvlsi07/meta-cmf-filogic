EXTRA_OECONF_append = " --enable-ert --enable-platform"

SRC_URI += "${CMF_GIT_ROOT}/rdkb/devices/turris/tdkb;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/platform/turris;name=tdkbturris"

SRCREV_tdkturris = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_tdkbturris"
SRCREV_FORMAT = "tdk_tdkbturris"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://*.patch;apply=no \
    file://Set_properties.sh;subdir=git \
"

do_mtk_patches() {
    cd ${S}
    if [ ! -e mtk_wifi_patch_applied ]; then
        for i in ${WORKDIR}/*.patch; do patch -p1 < $i; done
    fi
    touch mtk_wifi_patch_applied
}
addtask mtk_patches after do_unpack before do_compile

do_install_append () {
    install -d ${D}${tdkdir}
    install -d ${D}/etc
    install -p -m 755 ${S}/platform/turris/agent/scripts/*.sh ${D}${tdkdir}
    install -p -m 755 ${S}/platform/turris/agent/scripts/tdk_platform.properties ${D}/etc/
    install -p -m 755 ${S}/Set_properties.sh ${D}${tdkdir}
}

FILES_${PN} += "${prefix}/ccsp/"
FILES_${PN} += "/etc/*"
FILES_${PN} += "${tdkdir}/*"

CXXFLAGS_append = " -DWIFI_HAL_VERSION_3 "

