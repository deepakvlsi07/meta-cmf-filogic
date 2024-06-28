SUMMARY = "common inc for filogic"

CFLAGS_append += " -U_COSA_SIM_ -fno-exceptions -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-strict-aliasing \
           -D_ANSC_LINUX -D_ANSC_USER -D_ANSC_LITTLE_ENDIAN_ -D_CCSP_CWMP_TCP_CONNREQ_HANDLER \
           -D_DSLH_STUN_ -D_NO_PKI_KB5_SUPPORT -D_BBHM_SSE_FILE_IO -D_ANSC_USE_OPENSSL_ -DENABLE_SA_KEY \
           -D_ANSC_AES_USED_ -D_NO_EXECINFO_H_ -DFEATURE_SUPPORT_SYSLOG \
           -DBUILD_WEB -D_NO_ANSC_ZLIB_ -D_DEBUG -U_ANSC_IPV6_COMPATIBLE_ -DUSE_NOTIFY_COMPONENT \
           -D_PLATFORM_TURRIS_ -DENABLE_SD_NOTIFY -DCOSA_DML_WIFI_FEATURE_LoadPsmDefaults -UPARODUS_ENABLE -D_WIFI_AX_SUPPORT_ -D_2_5G_ETHERNET_SUPPORT_ -DETH_6_PORTS"
CFLAGS_append += "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DFEATURE_RDKB_WAN_MANAGER ', '', d)}"
CFLAGS_append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'WanManagerUnificationEnable', '-DWAN_MANAGER_UNIFICATION_ENABLED', '', d)}"

CFLAGS_append_aarch64 = " -D_64BIT_ARCH_SUPPORT_ "

LDFLAGS_append = " -lpthread -lcrypto"

DEPENDS += "breakpad-wrapper"
LDFLAGS += "-lbreakpadwrapper"
