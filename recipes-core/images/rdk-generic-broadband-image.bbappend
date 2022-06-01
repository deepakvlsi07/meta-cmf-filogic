inherit rdk-image

IMAGE_FEATURES_remove = "read-only-rootfs"

SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS_remove_libc-musl = "systemd-bootchart"

IMAGE_INSTALL += " packagegroup-filogic-core \
    ${SYSTEMD_TOOLS} \
    network-hotplug \
    libmcrypt \
    coreutils \
    util-linux-readprofile \    
    iputils \ 
    bc \ 
    python-core \
    dosfstools \
    pptp-linux \
    rp-pppoe  \  
    "

BB_HASH_IGNORE_MISMATCH = "1"
IMAGE_NAME[vardepsexclude] = "DATETIME"

#ESDK-CHANGES
do_populate_sdk_ext_prepend() {
    builddir = d.getVar('TOPDIR')
    if os.path.exists(builddir + '/conf/templateconf.cfg'):
        with open(builddir + '/conf/templateconf.cfg', 'w') as f:
            f.write('meta/conf\n')
}

sdk_ext_postinst_append() {
   echo "ln -s $target_sdk_dir/layers/openembedded-core/meta-rdk $target_sdk_dir/layers/openembedded-core/../meta-rdk \n" >> $env_setup_script
}

PRSERV_HOST = "localhost:0"
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"



require image-exclude-files.inc

remove_unused_file() {
   for i in ${REMOVED_FILE_LIST} ; do rm -rf ${IMAGE_ROOTFS}/$i ; done
}

ROOTFS_POSTPROCESS_COMMAND_append = "remove_unused_file; "

do_filogic_gen_image(){
	if ${@bb.utils.contains('DISTRO_FEATURES','kernel_in_ubi','true','false',d)}; then
        # create factory image align to openwrt (kernel in ubi)   

            echo \[kernel\] > ubinize.cfg
            echo mode=ubi >> ubinize.cfg
            echo image=${DEPLOY_DIR_IMAGE}/fitImage >> ubinize.cfg
            echo vol_id=0 >> ubinize.cfg
            echo vol_type=dynamic >> ubinize.cfg
            echo vol_name=kernel >> ubinize.cfg
            echo \[rootfs\] >> ubinize.cfg
            echo mode=ubi >> ubinize.cfg
            echo image=${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz >> ubinize.cfg
            echo vol_id=1 >> ubinize.cfg
            echo vol_type=dynamic >> ubinize.cfg
            echo vol_name=rootfs >> ubinize.cfg
            echo \[rootfs_data\] >> ubinize.cfg
            echo mode=ubi >> ubinize.cfg
            echo vol_id=2 >> ubinize.cfg
            echo vol_type=dynamic >> ubinize.cfg
            echo vol_name=rootfs_data >> ubinize.cfg
            echo vol_size=1MiB >> ubinize.cfg
            echo vol_flags=autoresize >> ubinize.cfg
            ubinize -o ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}-factory.bin ${UBINIZE_ARGS} ubinize.cfg
            mv ubinize.cfg ${DEPLOY_DIR_IMAGE}/

        # create sysupgrade image align to openwrt

            rm -rf ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}
            rm -rf ${IMGDEPLOYDIR}/${PN}-${MACHINE}-sysupgrade.bin

            mkdir ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}

            cp ${DEPLOY_DIR_IMAGE}/fitImage ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/kernel
            cp ${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/root

            cd ${IMGDEPLOYDIR}
            tar cvf ${PN}-${MACHINE}-sysupgrade.bin sysupgrade-${PN}-${MACHINE}
            mv ${PN}-${MACHINE}-sysupgrade.bin ${DEPLOY_DIR_IMAGE}/
    else
            rm -f ${NAND_FILE}

            # 1. dump fitImage into firmware
            dd if=${DEPLOY_DIR_IMAGE}/fitImage >> ${NAND_FILE}

            # 2. pad to 256K
            dd if=${NAND_FILE} of=${NAND_FILE}.new bs=256k conv=sync
            mv -f ${NAND_FILE}.new ${NAND_FILE}

            # 3. pad to kernel size = 0x800000 = 8388608
            dd if=${NAND_FILE} of=${NAND_FILE}.new bs=8388608 conv=sync
            mv -f ${NAND_FILE}.new ${NAND_FILE}

            # 4. dump filesystem into firmware
            dd if=${IMGDEPLOYDIR}/${PN}-${MACHINE}.${NAND_ROOTFS_TYPE} >> ${NAND_FILE}
            mv ${NAND_FILE} ${DEPLOY_DIR_IMAGE}/         
    fi

}
addtask filogic_gen_image after do_image_complete before do_populate_lic_deploy
