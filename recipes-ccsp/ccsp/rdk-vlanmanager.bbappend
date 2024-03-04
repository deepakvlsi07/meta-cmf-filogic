LDFLAGS_aarch64 += " -lutctx -lprivilege "
EXTRA_OECONF_remove_kirkstone  = " --with-ccsp-platform=bcm --with-ccsp-arch=arm "

DEPENDS_append += " libsyswrapper breakpad-wrapper"
LDFLAGS_append += " -lsecure_wrapper -lbreakpadwrapper"