FILESEXTRAPATHS_append := "${THISDIR}/files:"

SRC_URI_append += "file://miniupnpd-filogic.conf \
        "

do_install_append() {
    sed -i "s/After=network.target/After=network.target init-Lanbridge.service/g" ${D}${systemd_unitdir}/system/miniupnpd.service
    install -m 0644 ${WORKDIR}/miniupnpd-filogic.conf ${D}/${sysconfdir}/${BPN}/miniupnpd.conf
}

