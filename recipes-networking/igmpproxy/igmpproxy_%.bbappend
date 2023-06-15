FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = "file://igmpproxy.conf \
				 "

do_install_append () {
    install -p ${S}/../igmpproxy.conf ${D}/etc/
}

FILES_${PN} += "/etc/*"
