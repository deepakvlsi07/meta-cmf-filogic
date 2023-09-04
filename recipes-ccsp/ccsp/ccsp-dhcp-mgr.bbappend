require ccsp_common_filogic.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

SRC_URI_append = " \
	file://*.patch;apply=no \
"

do_fixcompile_patches() {
	cd ${S}
	if [ ! -e patch_applied ]; then
		patch  -p1 < ${WORKDIR}/0001-fix-64bit-compile-error.patch
	fi
}
addtask fixcompile_patches after do_unpack before do_configure
