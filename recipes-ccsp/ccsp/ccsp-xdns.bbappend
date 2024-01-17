require ccsp_common_filogic.inc

EXTRA_OECONF_append_dunfell  = " --with-ccsp-arch=arm"

LDFLAGS_append_dunfell = " -lsafec-3.5.1"
