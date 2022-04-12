
# This Program
import os
import unittest
import time
from ctypes import *

so_file = "/usr/lib/libhal_wifi.so.0.0.0"
lib = CDLL(so_file)
print ("Load Library is : " + str(lib))

class HalTestCases(unittest.TestCase):
    def test_wifi_getHalVersion(self):
        ver = c_char_p("")
        lib.wifi_getHalVersion(ver)
        self.assertEqual(ver.value, "3.0.0",
                         'incorrect HAL version')
        self.assertEqual(ver.value,
                         "3.0.0",
                         'incorrect HAL version')


class wifiBasicConfigTests(unittest.TestCase):
    # Set up envirnment var by $ export AP_IDX=0 before running this script
    def setUp(self):
        self.ap_index = 0
        self.ap_index = int(os.environ["AP_IDX"])
    """
    def test_wifi_getCountryCode(self):
        code = c_char_p("")
        lib.wifi_getRadioCountryCode(self.ap_index, code)
        self.assertEqual(code.value.rstrip(), "US",
                         'incorrect Country Code %s' %code.value)

    def test_wifi_setAndgetCountryCode(self):
        tw_code = c_char_p("TW")
        lib.wifi_setRadioCountryCode(self.ap_index, tw_code)
        time.sleep(1)

        code = c_char_p("")
        lib.wifi_getRadioCountryCode(self.ap_index, code)
        self.assertEqual(code.value.rstrip(), "TW",
                         'incorrect Country Code %s' %code.value)

        tw_code = c_char_p("US")
        lib.wifi_setRadioCountryCode(self.ap_index, tw_code)
        time.sleep(1)

        code = c_char_p("")
        lib.wifi_getRadioCountryCode(self.ap_index, code)
        self.assertEqual(code.value.rstrip(), "US",
                         'incorrect Country Code %s' %code.value)

    def test_wifi_getRadioChannel(self):
        radio_channel_p = (c_ulong*2)()
        lib.wifi_getRadioChannel(self.ap_index, radio_channel_p)
        channel_str = str(radio_channel_p[0])
        channel_int = int(channel_str)

        # set radio channel as 1
        lib.wifi_setRadioChannel(self.ap_index, 1)
        lib.wifi_reset()

        radio_channel_p = (c_ulong*2)()
        lib.wifi_getRadioChannel(self.ap_index, radio_channel_p)
        _radio_channel_str = str(radio_channel_p[0])

        self.assertEqual(_radio_channel_str, "1",
                         'Radio channel has to be 1 for wlan%s. Current channel is %s'
                         %(self.ap_index, _radio_channel_str))

        lib.wifi_setRadioChannel(self.ap_index, channel_str)
        time.sleep(1)
        lib.wifi_reset()
        time.sleep(1)

        radio_channel_p = (c_ulong*2)()
        lib.wifi_getRadioChannel(self.ap_index, radio_channel_p)
        _radio_channel_str = str(radio_channel_p[0])

        self.assertEqual(_radio_channel_str, channel_str,
                         'Radio channel has to be %s for wlan%s. Current channel is %s'
                         %(channel_str, self.ap_index, _radio_channel_str))
    """
    def test_wifi_ApEnable(self):
        lib.wifi_setApEnable(self.ap_index, 0)
        ap_en = (c_ubyte*4)()
        lib.wifi_getApEnable(self.ap_index, ap_en)
        _ap_en_str = str(ap_en[0])

        self.assertEqual(_ap_en_str, "0",
                         'AP Enable has to be False. Current is %s.' %(_ap_en_str))

        _ap_en_p = create_string_buffer(32)
        lib.wifi_getApStatus(self.ap_index, _ap_en_p)
        self.assertEqual(_ap_en_p.value, "Disabled")


        lib.wifi_setApEnable(self.ap_index, 1)
        ap_en[0] = 0
        lib.wifi_getApEnable(self.ap_index, ap_en)
        _ap_en_str = str(ap_en[0])

        self.assertEqual(_ap_en_str, "1",
                         'AP Enable has to be True. Current is %s.' %(_ap_en_str))

        _ap_en_p = create_string_buffer(32)
        lib.wifi_getApStatus(self.ap_index, _ap_en_p)
        self.assertEqual(_ap_en_p.value, "Enabled")
    """
    def test_wifi_SecurityMFPConfig(self):
        config = c_char_p("")
        lib.wifi_getApSecurityMFPConfig(self.ap_index, config)
        self.assertEqual(config.value.rstrip(), "Disabled",
                         'MFP Config(ieee80211w) has to be Disabled, but current value is %s' %config.value)

        lib.wifi_setApSecurityMFPConfig(self.ap_index, "Required")

        config = c_char_p("")
        lib.wifi_getApSecurityMFPConfig(self.ap_index, config)
        self.assertEqual(config.value.rstrip(), "Required",
                         'MFP Config(ieee80211w) has to be Required, but current value is %s' %config.value)

        lib.wifi_setApSecurityMFPConfig(self.ap_index, "Disabled")
        config = c_char_p("")
        lib.wifi_getApSecurityMFPConfig(self.ap_index, config)
        self.assertEqual(config.value.rstrip(), "Disabled",
                         'MFP Config(ieee80211w) has to be Disabled, but current value is %s' %config.value)

    def test_wifi_ApMaxAssociatedDevicesAndWatermark(self):
        lib.wifi_setApMaxAssociatedDevices(self.ap_index, 45)
        time.sleep(1)

        device_num = (c_uint*2)()
        lib.wifi_getApMaxAssociatedDevices(self.ap_index, device_num)
        device_num_str = str(device_num[0])
        self.assertEqual(device_num_str, "45",
                         'max_num_sta has to be 45, but current value is %s'
                         %device_num_str)

        lib.wifi_setApMaxAssociatedDevices(self.ap_index, 0)
        time.sleep(1)

        device_num = (c_uint*2)()
        lib.wifi_getApMaxAssociatedDevices(self.ap_index, device_num)
        device_num_str = str(device_num[0])
        self.assertEqual(device_num_str, "0",
                         'max_num_sta has to be 0, but current value is %s'
                         %device_num_str)

        device_watermark = (c_uint*2)()
        lib.wifi_getApAssociatedDevicesHighWatermarkThreshold(self.ap_index,
                                                              device_watermark)
        device_watermark_str = str(device_watermark[0])
        self.assertEqual(device_watermark_str, "50",
                         'ApAssociatedDevicesHighWatermarkThreshold has to be 50, but'\
                         'current value is %s' %(device_watermark_str))

    def test_wifi_WmmEnabled(self):

        init_wmm_enabled = (c_ubyte*2)()
        lib.wifi_getApWmmEnable(self.ap_index, init_wmm_enabled)
        init_wmm_enabled_str = str(init_wmm_enabled[0])

        lib.wifi_setApWmmEnable(self.ap_index, 1)
        wmm_enabled = (c_ubyte*2)()
        lib.wifi_getApWmmEnable(self.ap_index, wmm_enabled)
        wmm_enabled_str = str(wmm_enabled[0])

        self.assertEqual(wmm_enabled_str, "1",
                         'wmm_enabled has to be True. Current is %s.' %(wmm_enabled_str))

        lib.wifi_setApWmmEnable(self.ap_index, int(init_wmm_enabled_str))


    def test_wifi_UapsdAdvertisementEnabled(self):

        init_uapsd_enabled = (c_ubyte*2)()
        lib.wifi_getApWmmUapsdEnable(self.ap_index, init_uapsd_enabled)
        init_uapsd_enabled_str = str(init_uapsd_enabled[0])

        lib.wifi_setApWmmUapsdEnable(self.ap_index, 1)
        uapsd_enabled = (c_ubyte*2)()
        lib.wifi_getApWmmUapsdEnable(self.ap_index, uapsd_enabled)
        uapsd_enabled_str = str(uapsd_enabled[0])

        self.assertEqual(uapsd_enabled_str, "1",
                         'uapsd_enabled has to be True. Current is %s.' %(uapsd_enabled_str))

        lib.wifi_setApWmmUapsdEnable(self.ap_index, int(init_uapsd_enabled_str))
    """
    def test_wifi_getApRadiIndex(self):
        index = (c_int*2)()
        lib.wifi_getApRadioIndex(3, index)
        self.assertEqual(index[0], 1)

        index = (c_int*2)()
        lib.wifi_getApRadioIndex(4, index)
        self.assertEqual(index[0], 0)

    def test_wifi_ApIsolation(self):
        ap_isolation_enabled = (c_ubyte*2)()
        lib.wifi_getApIsolationEnable(self.ap_index, ap_isolation_enabled)
        ori_ap_isolation_str = str(ap_isolation_enabled[0])

        lib.wifi_setApIsolationEnable(self.ap_index, 0)
        lib.wifi_reset()
        time.sleep(1)
        ap_isolation_enabled = (c_ubyte*2)()
        lib.wifi_getApIsolationEnable(self.ap_index, ap_isolation_enabled)
        ap_isolation_str = str(ap_isolation_enabled[0])
        self.assertEqual(ap_isolation_str, "0",
                         'ap_isolate shall be false, but current is %s.'
                         %(ap_isolation_enabled))


        lib.wifi_setApIsolationEnable(self.ap_index, 1)
        lib.wifi_reset()
        time.sleep(1)
        ap_isolation_enabled = (c_ubyte*2)()
        lib.wifi_getApIsolationEnable(self.ap_index, ap_isolation_enabled)
        ap_isolation_str = str(ap_isolation_enabled[0])
        self.assertEqual(ap_isolation_str, "1",
                         'ap_isolate shall be true, but current is %s.'
                         %(ap_isolation_enabled))

        lib.wifi_setApIsolationEnable(self.ap_index, ori_ap_isolation_str)
        lib.wifi_reset()
        time.sleep(1)

    def test_wifi_ApMacAddressControlMode(self):
         ori_mode = (c_ubyte*2)()
         lib.wifi_getApMacAddressControlMode(self.ap_index, ori_mode)
         ori_mode_str = str(ori_mode[0])

         lib.wifi_setApMacAddressControlMode(self.ap_index, 2)
         mac_address_mode = (c_ubyte*2)()
         lib.wifi_getApMacAddressControlMode(self.ap_index, mac_address_mode)
         mac_address_mode_str = str(mac_address_mode[0])
         self.assertEqual(mac_address_mode_str, "2",
                         'MacAddressControlMode shall be 2, but current is %s'
                          %(mac_address_mode_str))


         lib.wifi_setApMacAddressControlMode(self.ap_index, 0)
         mac_address_mode = (c_ubyte*2)()
         lib.wifi_getApMacAddressControlMode(self.ap_index, mac_address_mode)
         mac_address_mode_str = str(mac_address_mode[0])
         self.assertEqual(mac_address_mode_str, "0",
                         'MacAddressControlMode shall be 0, but current is %s'
                          %(mac_address_mode_str))

         lib.wifi_setApMacAddressControlMode(self.ap_index, ori_mode_str)

    def test_wifi_getApName(self):
        name = c_char_p("")
        lib.wifi_getApName(0, name)
        self.assertEqual(name.value.rstrip(), "wifi0",
                         'AP Name shall be wifi0, but current is %s' %name.value.rstrip())

        name = c_char_p("")
        lib.wifi_getApName(10, name)
        self.assertEqual(name.value.rstrip(), "wifi10",
                         'AP Name shall be wifi10, but current is %s' %name.value.rstrip())


    def test_wifi_ApSsidAdvertisementEnable(self):

        init_ssidAdvertisement_enabled = (c_ubyte*2)()
        lib.wifi_getApSsidAdvertisementEnable(self.ap_index, init_ssidAdvertisement_enabled)

        lib.wifi_setApSsidAdvertisementEnable(self.ap_index, 1)
        ssid_enabled = (c_ubyte*2)()
        lib.wifi_getApSsidAdvertisementEnable(self.ap_index, ssid_enabled)
        ssid_enabled_str = str(ssid_enabled[0])

        self.assertEqual(ssid_enabled_str, "1",
                         'ssid_enabled has to be True. Current is %s.' %(ssid_enabled_str))

        lib.wifi_setApSsidAdvertisementEnable(self.ap_index, init_ssidAdvertisement_enabled[0])

class wifiWPSTests(unittest.TestCase):
    def setUp(self):
        self.ap_index = 0
        self.ap_index = int(os.environ["AP_IDX"])
    """
    def test_wifi_getApWpsEnable(self):
        # at least 2 bytes
        wps_en = (c_ubyte*2)()
        lib.wifi_getApWpsEnable(self.ap_index, wps_en)
        wps_en_str = str(wps_en[0])

        self.assertEqual(wps_en_str, "0",
                         'WPS state has to be unconfigured. Current state is %s.' %(wps_en_str))

    def test_wifi_setAndGetApWpsEnable(self):
        lib.wifi_setApWpsEnable(self.ap_index, 1)

        wps_en = (c_ubyte*2)()
        lib.wifi_getApWpsEnable(self.ap_index, wps_en)
        wps_en_str = str(wps_en[0])

        self.assertEqual(wps_en_str, "1",
                         'WPS state has to be configured. Current state is %s.' %(wps_en_str))
    """
    def test_wifi_getApWpsConfigurationState(self):
        lib.wifi_setApWpsEnable(self.ap_index, 1)

        wps_state = create_string_buffer(32)
        lib.wifi_getApWpsConfigurationState(self.ap_index, wps_state)
        self.assertEqual(wps_state.value, "Configured",
                         'WPS state has to be Configured. Current state is %s'
                         %wps_state.value)

    def test_wifi_ApWpsButtonPush(self):
        lib.wifi_setApWpsEnable(self.ap_index, 1)

        lib.wifi_setApWpsButtonPush(self.ap_index)
        cmd= "hostapd_cli -i wifi%s wps_get_status | grep 'PBC Status' | cut -d ' ' -f3" %(str(self.ap_index))

        pbc_status = os.popen(cmd).read()
        self.assertEqual(pbc_status.rstrip(), "Active", 'wps status shall be Active, but'\
                         'current is %s' %(pbc_status.rstrip()))

        lib.wifi_cancelApWPS(self.ap_index)

        pbc_status = os.popen(cmd).read()
        self.assertEqual(pbc_status.rstrip(), "Timed-out", 'wps status shall be Timed-out, but'\
                         ' current is %s' %(pbc_status.rstrip()))



    def tearDown(self):
        lib.wifi_setApWpsEnable(self.ap_index, 0)

class wifiClientMgmt(unittest.TestCase):
    def setUp(self):
        self.ap_index = 0
        self.ap_index = int(os.environ["AP_IDX"])

    def test_wifi_BSSTransitionActivation(self):
        init_bss_transition = (c_ubyte*2)()
        lib.wifi_getBSSTransitionActivation(self.ap_index, init_bss_transition)

        lib.wifi_setBSSTransitionActivation(self.ap_index, 1)
        bss_transition = (c_ubyte*2)()
        lib.wifi_getBSSTransitionActivation(self.ap_index, bss_transition)
        bss_transition_str = str(bss_transition[0])
        self.assertEqual(bss_transition_str, "1",
                         'bss_transition shall be True, but current is %s'
                         %(bss_transition_str))

        lib.wifi_setBSSTransitionActivation(self.ap_index, init_bss_transition[0])

    def test_wifi_NeighborReportActivation(self):
        init_rrm = (c_ubyte*2)()
        lib.wifi_getNeighborReportActivation(self.ap_index, init_rrm)

        lib.wifi_setNeighborReportActivation(self.ap_index, 1)
        rrm = (c_ubyte*2)()
        lib.wifi_getNeighborReportActivation(self.ap_index, rrm)
        rrm_str = str(rrm[0])
        self.assertEqual(rrm_str, "1",
                         'rrm_neighbor_report shall be true, but current is %s'
                         %(rrm_str))

        lib.wifi_setNeighborReportActivation(self.ap_index, init_rrm[0])

class wifiExtender(unittest.TestCase):
    def setUp(self):
        self.ap_index = 0
        self.ap_index = int(os.environ["AP_IDX"])

    def test_wifi_getSSIDRadioIndex(self):
        index = (c_int*2)()
        lib.wifi_getSSIDRadioIndex(3, index)
        self.assertEqual(index[0], 1)

        index = (c_int*2)()
        lib.wifi_getSSIDRadioIndex(6, index)
        self.assertEqual(index[0], 0)

class wifiRadio(unittest.TestCase):
    def setUp(self):
        self.ap_index = 0
        self.ap_index = int(os.environ["AP_IDX"])

    def test_wifi_getRadioIfName(self):
        radio_name = create_string_buffer(64)
        lib.wifi_getRadioIfName(1, radio_name)
        self.assertEqual(radio_name.value, "wlan1",
                         'Radio name shall be wifi1, but current is %s' %(radio_name.value))

        rtn_val = lib.wifi_getRadioIfName(4, radio_name)
        self.assertEqual(rtn_val, -1, 'The return value of wifi_getRadioIfName() shall'\
                         'be -1, but current is %d.' %(rtn_val))

    def test_wifi_RadioEnable(self):
        init_radio = (c_ubyte*2)()
        lib.wifi_getRadioEnable(self.ap_index, init_radio)

        lib.wifi_setRadioEnable(self.ap_index, 0)
        time.sleep(2)

        radio_enable = (c_ubyte*2)()
        lib.wifi_getRadioEnable(self.ap_index, radio_enable)
        self.assertEqual(str(radio_enable[0]), "0", 'Radio%d shall be disabled, but'\
                         'current is %s' %(self.ap_index,str(radio_enable[0])))


        lib.wifi_setRadioEnable(self.ap_index, 1)
        time.sleep(2)

        radio_enable = (c_ubyte*2)()
        lib.wifi_getRadioEnable(self.ap_index, radio_enable)
        self.assertEqual(str(radio_enable[0]), "1", 'Radio%d shall be enabled, but'\
                         ' current is %s' %(self.ap_index,str(radio_enable[0])))


        lib.wifi_setRadioEnable(self.ap_index, init_radio[0])
        time.sleep(2)

if __name__ == '__main__':

    unittest.main(verbosity=2)

