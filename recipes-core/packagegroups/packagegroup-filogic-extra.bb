SUMMARY = "Custom extra package group for filogic boards"

LICENSE = "MIT"

inherit packagegroup

DEPENDS = "libnl"

PACKAGES = " \
	  packagegroup-filogic-extra \
	"

RDEPENDS_packagegroup-filogic-extra = " \
    bzip2 \
    nmap \
    devmem2 \
    cryptsetup \
    dosfstools \
    e2fsprogs \
    squashfs-tools \
    btrfs-tools \    
    fftw \
    nfs-utils \
    rpcbind \
    sg3-utils \
    libpcap \
    tcpdump \
    valgrind \
    testfloat \
    lttng-tools \
    mesh-agent \
    opensync \
    openvswitch \
    "
