DEPENDS_remove = "cryptodev-linux"
DEPENDS_remove = "cryptodev-linux-native"
DEPENDS_append = " ocf-linux ocf-linux-native"

CFLAG_remove = "-DUSE_CRYPTODEV_DIGESTS"
CFLAG_append = " -fPIC"
CFLAGS_class-native += " -fPIC -I${STAGING_DIR_NATIVE}/usr/include"
