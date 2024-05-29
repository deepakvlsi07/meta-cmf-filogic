require ccsp_common_filogic.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/ccsp-wifi-agent:${THISDIR}/files:"

DEPENDS_remove = " opensync-2.4.1"
DEPENDS_append = " opensync mesh-agent"

CFLAGS_append = " -DWIFI_HAL_VERSION_3 -Wno-unused-function -DCONFIG_MBO"
LDFLAGS_append = " -ldl "
CFLAGS_remove = " -Wno-mismatched-dealloc -Wno-enum-conversion "
CFLAGS_append_aarch64 = " -Wno-error "

SRC_URI += " \
    file://checkonewifi.sh \
    file://bridge_mode.sh \
    file://onewifi_pre_start.sh \
    file://mac80211.sh \
    file://init-uci-config.service \
"
#SYSTEMD_AUTO_ENABLE_${PN} = "enable"
SYSTEMD_SERVICE_${PN} += " init-uci-config.service"

do_install_append(){
    install -m 777 ${WORKDIR}/checkonewifi.sh ${D}/usr/ccsp/wifi/checkwifi.sh
    install -m 777 ${WORKDIR}/bridge_mode.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/onewifi_pre_start.sh ${D}/usr/ccsp/wifi/
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/init-uci-config.service ${D}${systemd_unitdir}/system
    install -m 777 ${WORKDIR}/mac80211.sh ${D}/usr/ccsp/wifi/
}

FILES_${PN} += " \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/bridge_mode.sh \
    ${prefix}/ccsp/wifi/onewifi_pre_start.sh \
    ${prefix}/ccsp/wifi/mac80211.sh \
    ${systemd_unitdir}/system/init-uci-config.service \
    /usr/bin/wifi_events_consumer \
"

