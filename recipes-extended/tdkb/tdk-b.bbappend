EXTRA_OECONF_append = " --enable-ert --enable-platform"

SRC_URI += "${CMF_GIT_ROOT}/rdkb/devices/turris/tdkb;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/platform/turris;name=tdkbturris"

SRCREV_tdkturris = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_tdkbturris"
SRCREV_FORMAT = "tdk_tdkbturris"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-Fix-GetApAssociatedDeviceRxStatsResult-and-GetApAsso.patch;apply=no \
    file://0002-Add-tdk-utility-functions.patch;apply=no \
    file://0003-Add-Set-property-script.patch;apply=no \
    file://0004-Add-start-sequence-after-uci.patch;apply=no \
    file://0005-Fix-wifi_getApAssociatedDeviceTidStatsResult-print-a.patch;apply=no \
    file://Set_properties.sh;subdir=git \
	file://Set_properties_logan.sh;subdir=git \
"

do_mtk_patches() {
    cd ${S}
    if [ ! -e mtk_wifi_patch_applied ]; then
		patch -p1 < ${WORKDIR}/0001-Fix-GetApAssociatedDeviceRxStatsResult-and-GetApAsso.patch
		patch -p1 < ${WORKDIR}/0002-Add-tdk-utility-functions.patch
		patch -p1 < ${WORKDIR}/0003-Add-Set-property-script.patch
		if ${@bb.utils.contains( 'DISTRO_FEATURES', 'logan', 'false', 'true', d)}; then
			patch -p1 < ${WORKDIR}/0004-Add-start-sequence-after-uci.patch
		fi
		patch -p1 < ${WORKDIR}/0005-Fix-wifi_getApAssociatedDeviceTidStatsResult-print-a.patch
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
    install -p -m 755 ${S}/Set_properties_logan.sh ${D}${tdkdir}
}

FILES_${PN} += "${prefix}/ccsp/"
FILES_${PN} += "/etc/*"
FILES_${PN} += "${tdkdir}/*"

CXXFLAGS_append = " -DWIFI_HAL_VERSION_3 "

