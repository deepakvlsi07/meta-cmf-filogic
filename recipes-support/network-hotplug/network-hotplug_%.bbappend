FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://filogic-network-hotplug.patch;patchdir=${WORKDIR}/ \
           "
