SRC_URI_remove = "git://github.com/xelerance/xl2tpd.git"
SRC_URI += "git://github.com/xelerance/xl2tpd.git;branch=master;protocol=https"
SRCREV = "1ef2a025981223c1e16fc833bef226c86ff8c295"
UPSTREAM_CHECK_URI = "https://github.com/xelerance/xl2tpd/releases"


CFLAGS_append += " -DUSE_KERNEL -DDEBUG_PPPD -DTRUST_PPPD_TO_DIE -DIP_ALLOCATION -DSANITY"
RDEPENDS_${PN} += "ppp"
RRECOMMENDS_${PN} += " ppp-l2tp"