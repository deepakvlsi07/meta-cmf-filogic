DEPENDS_remove = "virtual/kernel bridge-utils"
DEPENDS_append_class-target = " virtual/kernel kernel-devsrc"
DEPENDS_append_class-target = " bridge-utils"
EXTRA_OECONF += "--enable-ssl"

EXTRA_OECONF_class-target_dunfell += "--with-linux=${STAGING_KERNEL_BUILDDIR} --with-linux-source=${STAGING_KERNEL_DIR} KARCH=${UBOOT_ARCH} PYTHON=python3 PYTHON3=python3 PERL=${bindir}/perl "

#disable openvswitch autostart
SYSTEMD_SERVICE_${PN}-switch = ""
do_compile_prepend() {
        export CROSS_COMPILE=`echo '${TARGET_PREFIX}'`
}

PACKAGECONFIG[ssl] = " "
