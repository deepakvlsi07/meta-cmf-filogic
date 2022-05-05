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
