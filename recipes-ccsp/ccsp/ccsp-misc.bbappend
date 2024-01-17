require ccsp_common_filogic.inc

DEPENDS_append_dunfell = " ccsp-lm-lite"

LDFLAGS_append_dunfell = " -lsafec-3.5.1"

EXTRA_OECONF_append_dunfell  = " --with-ccsp-arch=arm"

CFLAGS += " -DDHCPV4_CLIENT_UDHCPC -DDHCPV6_CLIENT_DIBBLER "
