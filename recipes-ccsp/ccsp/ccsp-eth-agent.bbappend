require ccsp_common_filogic.inc

FILESEXTRAPATHS_append := "${THISDIR}/files:"

SRC_URI_append += " \
    file://Fix-ccsp-eth-agent-build-error.patch;apply=no \
"

do_filogic_patches() {
    cd ${S}

    if [ ! -e filogic_patch_applied ] && [[ "${PROJECT_BRANCH}" == "rdkb-2024q1-dunfell" || "${PROJECT_BRANCH}" == "rdkb-2024q1-kirkstone" ]]; then
        patch -p1 < ${WORKDIR}/Fix-ccsp-eth-agent-build-error.patch
        touch filogic_patch_applied
    fi
}
addtask filogic_patches after do_unpack before do_configure

CFLAGS_aarch64_append = " -Werror=format-truncation=1 "

EXTRA_OECONF_append_dunfell  = " --with-ccsp-arch=arm"

LDFLAGS_append =" \
    -lsyscfg \
    -lbreakpadwrapper \
"
LDFLAGS_append_dunfell = " -lpthread -lsafec-3.5.1"