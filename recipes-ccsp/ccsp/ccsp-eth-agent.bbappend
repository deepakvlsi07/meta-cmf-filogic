require ccsp_common_filogic.inc

CFLAGS_aarch64_append = " -Werror=format-truncation=1 "

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

LDFLAGS_append =" \
    -lsyscfg \
    -lbreakpadwrapper \
"
LDFLAGS_append_dunfell = " -lpthread -lsafec-3.5.1"
