EXTRA_OECONF_append = " --enable-ert --enable-platform"

SRC_URI += "${CMF_GIT_ROOT}/rdkb/devices/turris/tdkb;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/platform/turris;name=tdkbturris"

SRCREV_tdkturris = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_tdkbturris"
SRCREV_FORMAT = "tdk_tdkbturris"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI += "file://*.patch;apply=no"

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

    sed -i "s/\(AP_IF_NAME_2G *= *\).*/\1wifi0/" ${D}/etc/tdk_platform.properties
    sed -i "s/\(AP_IF_NAME_5G *= *\).*/\1wifi1/" ${D}/etc/tdk_platform.properties
    sed -i "s/\(RADIO_IF_2G *= *\).*/\1wlan0/" ${D}/etc/tdk_platform.properties
    sed -i "s/\(RADIO_IF_5G *= *\).*/\1wlan1/" ${D}/etc/tdk_platform.properties
    echo "DEFAULT_CHANNEL_BANDWIDTH=20MHz,20MHz" >> ${D}/etc/tdk_platform.properties
    echo "APINDEX_2G_PUBLIC_WIFI=0" >> ${D}/etc/tdk_platform.properties
    echo "APINDEX_5G_PUBLIC_WIFI=1" >> ${D}/etc/tdk_platform.properties
    echo "RADIO_MODES_2G=n:11NGHT40MINUS:4,n:11NGHT40MINUS:8,ax:11AXHE40MINUS:32,ax:11AXHE40MINUS:0" >> ${D}/etc/tdk_platform.properties
    echo "RADIO_MODES_5G=ac:11ACVHT80:16,n:11NAHT40MINUS:8,ax:11AXHE80:32,ax:11AXHE80:0" >> ${D}/etc/tdk_platform.properties
    echo "getAp0DTIMInterval=1" >> ${D}/etc/tdk_platform.properties
    echo "getAp1DTIMInterval=1" >> ${D}/etc/tdk_platform.properties

}

FILES_${PN} += "${prefix}/ccsp/"
FILES_${PN} += "/etc/*"
FILES_${PN} += "${tdkdir}/*"

