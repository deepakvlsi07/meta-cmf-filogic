LICENSE="CLOSED"

DEPENDS += " rdk-wifi-hal hal-wifi-generic"
SRC_URI = " \
           ${CMF_GITHUB_ROOT}/rdkb-wifi-hal;protocol=https;branch=feature/TDK-6732;name=wifihal \
           ${CMF_GITHUB_ROOT}/rdkb-wifi-haltest;protocol=https;branch=feature/TDK-7346;name=ut;destsuffix=git/ut \
           ${CMF_GITHUB_ROOT}/ut-core;protocol=https;branch=develop;name=ut-core;destsuffix=git/ut/ut-core \
           https://sourceforge.net/projects/cunit/files/CUnit/2.1-3/CUnit-2.1-3.tar.bz2;name=cunit;destsuffix=git/ut/ut-core/framework \
           git://github.com/jwerle/asprintf.c;branch=master;protocol=https;name=asprintf;destsuffix=git/ut/ut-core/framework/asprintf/asprintf.c-master \
           git://github.com/pantoniou/libfyaml;branch=master;protocol=https;name=libfyaml;destsuffix=git/ut/ut-core/framework/libfyaml-master \
           file://fix_build_and_startup_issue.patch;apply=no \
           file://radio_config \
           file://vap_config \
          "
SRCREV_wifihal = "${AUTOREV}"
SRCREV_ut = "${AUTOREV}"
SRCREV_ut-core = "${AUTOREV}"
SRCREV_asprintf = "${AUTOREV}"
SRCREV_libfyaml = "${AUTOREV}"
SRC_URI[cunit.sha256sum] = "f5b29137f845bb08b77ec60584fdb728b4e58f1023e6f249a464efa49a40f214"

SRCREV_FORMAT = "wifihal_ut_ut-core"

S = "${WORKDIR}/git/ut"

do_configure(){
     cp ${WORKDIR}/CUnit-2.1-3/CUnit/Headers/CUnit.h.in ${WORKDIR}/CUnit-2.1-3/CUnit/Headers/CUnit.h   
     cp -rf ${WORKDIR}/CUnit-2.1-3 ${S}/ut-core/framework
     rm ${S}/ut-core/framework/asprintf/asprintf.c-master/test.c
     cp -f ${S}/ut-core/src/libyaml/patches/CorrectWarningsAndBuildIssuesInLibYaml.patch ${S}/ut-core/framework/
     cp -f ${S}/ut-core/src/cunit/cunit_lgpl/patches/CorrectBuildWarningsInCunit.patch ${S}/ut-core/framework/
     cd ${S}/ut-core/framework/
     patch -p0 < CorrectWarningsAndBuildIssuesInLibYaml.patch
     patch -u CUnit-2.1-3/CUnit/Sources/Framework/TestRun.c -i CorrectBuildWarningsInCunit.patch
}

do_filogic_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/fix_build_and_startup_issue.patch
        touch patch_applied
    fi
}
addtask filogic_patches after do_patch before do_compile

do_compile (){
        cd ${S} 
        oe_runmake TARGET=arm
}

do_install(){
    install -d ${D}/usr/sbin ${D}${sysconfdir}
    install -m 0755 ${S}/bin/hal_test ${D}/usr/sbin 
    install -m 0644 ${WORKDIR}/radio_config ${D}${sysconfdir}/
    install -m 0644 ${WORKDIR}/vap_config ${D}${sysconfdir}/
}