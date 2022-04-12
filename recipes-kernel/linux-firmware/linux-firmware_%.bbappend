FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://mt76 \
    "

do_install_append () {
    install -d ${D}/${base_libdir}/firmware/mediatek/

    install -m 644 ${WORKDIR}/mt76/firmware/mt7915_rom_patch.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7915_wa.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7915_wm.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7915_eeprom.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7915_eeprom_dbdc.bin ${D}${base_libdir}/firmware/mediatek/

    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_rom_patch.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_rom_patch_mt7975.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_wa.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_wm.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_wm_mt7975.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_eeprom_mt7975_dual.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_eeprom_mt7976_dbdc.bin ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_eeprom_mt7976.bin  ${D}${base_libdir}/firmware/mediatek/
    install -m 644 ${WORKDIR}/mt76/firmware/mt7986_eeprom_mt7976_dual.bin ${D}${base_libdir}/firmware/mediatek/

}

PACKAGES =+ "${PN}-mt76"

FILES_${PN}-mt76 += " \
    ${base_libdir}/firmware/mediatek/mt7915_rom_patch.bin \
    ${base_libdir}/firmware/mediatek/mt7915_wa.bin \
    ${base_libdir}/firmware/mediatek/mt7915_wm.bin \
    ${base_libdir}/firmware/mediatek/mt7915_eeprom.bin \
    ${base_libdir}/firmware/mediatek/mt7915_eeprom_dbdc.bin \
    ${base_libdir}/firmware/mediatek/mt7986_rom_patch.bin\
    ${base_libdir}/firmware/mediatek/mt7986_rom_patch_mt7975.bin \
    ${base_libdir}/firmware/mediatek/mt7986_wa.bin \
    ${base_libdir}/firmware/mediatek/mt7986_wm.bin \
    ${base_libdir}/firmware/mediatek/mt7986_wm_mt7975.bin \
    ${base_libdir}/firmware/mediatek/mt7986_eeprom_mt7975_dual.bin \
    ${base_libdir}/firmware/mediatek/mt7986_eeprom_mt7976_dbdc.bin \
    ${base_libdir}/firmware/mediatek/mt7986_eeprom_mt7976.bin \
    ${base_libdir}/firmware/mediatek/mt7986_eeprom_mt7976_dual.bin \
    "
