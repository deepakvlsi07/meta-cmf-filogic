require ccsp_common_filogic.inc

EXTRA_OECONF_append_dunfell  = " --with-ccsp-arch=arm"

LDFLAGS_append = " -Wl,--no-as-needed"

