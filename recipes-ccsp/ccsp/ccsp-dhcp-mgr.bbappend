require ccsp_common_filogic.inc

EXTRA_OECONF_append_dunfell  = " --with-ccsp-arch=arm"
CFLAGS_append_kirkstone = " -fcommon "
LDFLAGS_append = " -lnanomsg "

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'dhcp_manager', 'false', 'true', d)}; then
        rm -rf ${D}${systemd_unitdir}/
    fi
}
