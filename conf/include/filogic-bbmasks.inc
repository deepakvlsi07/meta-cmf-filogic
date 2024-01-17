BBMASK .= "|meta-rdk/recipes-common/rdkversion/"
BBMASK .= "|meta-cmf/recipes-common/rdkversion/"
BBMASK .= "|meta-cmf/recipes-support/libdacjwt/"
BBMASK .= "|meta-cmf/recipes-support/libkwk-rdk/"
BBMASK .= "|meta-cmf/recipes-support/libmntfsimg/"
BBMASK .= "|meta-rdk/recipes-core/packagegroups/packagegroup-rdk-media-common.bb"
BBMASK .= "|meta-rdk/recipes-support/base64/base64_git.bb"

BBMASK .= "|meta-rdk-ext/recipes-common/rtmessage"
BBMASK .= "|meta-rdk-ext/recipes-kernel/linux/linux-libc-headers_%.bbappend"
BBMASK .= "|meta-rdk-ext/recipes-kernel/linux/linux-libc-headers_3.14.bb"

BBMASK .= "|meta-rdk-ext/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappend"

BBMASK .= "|meta-browser/*"
BBMASK .= "|openembedded-core/meta/recipes-bsp/u-boot/libubootenv_0.2.bb"

BBMASK .= "|meta-virtualization/recipes-devtools/protobuf"

BBMASK .= "${@'' if os.path.isdir('|meta-openembedded/meta-oe/recipes-devtools/breakpad/breakpad_git.bb') else '|meta-cmf/recipes-devtools/breakpad/breakpad_git.bb'}"

#To avoid build warning
BBMASK .= "|meta-rdk-ext/recipes-support/iksemel/iksemel_1.5.bb"
BBMASK .= "|meta-cmf-broadband/recipes-core/util-linux/"
BBMASK_append .= "|meta-cmf/recipes-extended/smartmon/"
BBMASK_append .= "|meta-rdk/recipes-common/rtremote/"
BBMASK_append_dunfell .= "|meta-filogic/recipes-kernel/linux-libc-headers/"
BBMASK_append_dunfell .= "|meta-filogic/recipes-wifi/lua/"