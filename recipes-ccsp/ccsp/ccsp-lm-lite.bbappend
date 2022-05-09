require ccsp_common_filogic.inc

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

LDFLAGS_append = " -Wl,--no-as-needed"

