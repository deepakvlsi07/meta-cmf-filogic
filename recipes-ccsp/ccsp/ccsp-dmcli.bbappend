require ccsp_common_filogic.inc

LDFLAGS_append_dunfell = " -lsafec-3.5.1"

do_install_append () {
    ln -sf ${bindir}/dmcli ${D}${bindir}/ccsp_bus_client_tool
}
