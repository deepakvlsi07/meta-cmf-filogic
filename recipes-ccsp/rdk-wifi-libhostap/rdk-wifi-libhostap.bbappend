FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
    file://Rpi_rdkwifilibhostap_changes.patch \
    file://fixed_6G_wrong_freq.patch \
"

CFLAGS_append = " \
    -DCONFIG_IEEE80211AX \
    -DCONFIG_OWE \
    -DCONFIG_ACS \
    -DCONFIG_AP \
    -DCONFIG_SAE \
"
