require ccsp_common_filogic.inc

LDFLAGS_append_dunfell = " -lsafec-3.5.1"

do_install_append() {
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${S}/config/bbhm_def_cfg_qemu.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
    install -m 755 ${S}/scripts/bbhm_patch.sh ${D}/usr/ccsp/psm/bbhm_patch.sh

#WanManager Feature
    DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
    if [ $DISTRO_WAN_ENABLED = 'true' ]; then
    sed -i '/AccessPoint.16.vAPStatsEnable/a \
   <!-- rdkb-wanmanager related --> \
   <Record name="dmsb.wanmanager.wanenable" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.wanifcount" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.wanpolicy" type="astr">2</Record> \ 
   <Record name="dmsb.wanmanager.wanidletimeout" type="astr">0</Record> \
   <Record name="dmsb.selfheal.rebootstatus"  type="astr">0</Record> \
   <Record name="dmsb.wanmanager.allowremoteinterfaces" type="astr">0</Record> \
   <Record name="dmsb.wanmanager.RestorationDelay" type="astr">45</Record> \
   <Record name="dmsb.wanmanager.if.1.Name" type="astr">eth2</Record> \
   <Record name="dmsb.wanmanager.if.1.DisplayName" type="astr">WanOE</Record> \
   <Record name="dmsb.wanmanager.if.1.Enable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.Type" type="astr">2</Record> \
   <Record name="dmsb.wanmanager.if.1.Priority" type="astr">0</Record> \
   <Record name="dmsb.wanmanager.if.1.SelectionTimeout" type="astr">0</Record> \
   <Record name="dmsb.wanmanager.if.1.DynTriggerEnable" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.DynTriggerDelay" type="astr">0</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.List" type="astr">DATA</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.Alias" type="astr">DATA</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.SKBPort" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.SKBMark" type="astr"> </Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.EthernetPriorityMark" type="astr"></Record> \
   <Record name="dmsb.wanmanager.if.1.EnableDHCP" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.EnableIPoE" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPEnable" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPLinkType" type="astr">PPPoE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPIPCPEnable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPIPV6CPEnable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPIPCPEnable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.ActiveLink" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.EnableMAPT" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.EnableDSLite" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.EnableIPoEHealthCheck" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.RebootOnConfiguration" type="astr">FALSE</Record> \
   <!-- ccsp-vlanmanager EthLink records --> \
   <Record name="dmsb.ethlink.ifcount" type="astr">1</Record> \
   <Record name="dmsb.ethlink.1.Enable" type="astr">FALSE</Record> \
   <Record name="dmsb.ethlink.1.alias" type="astr">WANOE</Record> \
   <Record name="dmsb.ethlink.1.name" type="astr">erouter0</Record> \
   <Record name="dmsb.ethlink.1.lowerlayers" type="astr"></Record> \
   <Record name="dmsb.ethlink.1.macoffset" type="astr">3</Record> \
   <Record name="dmsb.ethlink.1.baseiface" type="astr">eth2</Record> \
   <Record name="dmsb.ethlink.1.path" type="astr">Device.X_RDK_WanManager.Interface.1.VirtualInterface.1</Record> \
   <Record name="dmsb.vlanmanager.ifcount" type="astr">1</Record> \
   <Record name="dmsb.vlanmanager.1.Enable" type="astr">FALSE</Record> \
   <Record name="dmsb.vlanmanager.1.alias" type="astr">WANOE</Record> \
   <Record name="dmsb.vlanmanager.1.name" type="astr">erouter0</Record> \
   <Record name="dmsb.vlanmanager.1.lowerlayers" type="astr">Device.X_RDK_Ethernet.Link.3</Record> \
   <Record name="dmsb.vlanmanager.1.baseinterface" type="astr">eth2</Record> \
   <Record name="dmsb.vlanmanager.1.vlanid" type="astr">-1</Record> \
   <Record name="dmsb.vlanmanager.1.tpid" type="astr">0</Record> \
   <Record name="dmsb.vlanmanager.1.path" type="astr">Device.X_RDK_WanManager.Interface.1.VirtualInterface.1</Record> \
   <!-- Wanmanger Unified  struct --> \
   <Record name="dmsb.wanmanager.wan.interfacecount" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.group.Count" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.group.1.policy" type="astr">6</Record> \
   <Record name="dmsb.wanmanager.if.1.BaseInterface" type="astr">Device.Ethernet.X_RDK_Interface.3</Record> \
   <Record name="dmsb.wanmanager.if.1.Selection.Enable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.Selection.ActiveLink" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.Selection.RequiresReboot" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.Selection.Group" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.if.1.Selection.Priority" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.if.1.Selection.Timeout" type="astr">20</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterfaceifcount" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.Enable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.Alias" type="astr">WANOE</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.Name" type="astr">erouter0</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.EnableMAPT" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.EnableDSLite" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.EnableIPoE" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.PPPInterface" type="astr"></Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.IPInterface" type="astr">Device.IP.Interface.1</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.IP.Mode" type="astr">3</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.IP.IPv4Source" type="astr">2</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.IP.IPv6Source" type="astr">2</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.VlanInUse" type="astr">Device.X_RDK_Ethernet.VLANTermination.1</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.Timeout" type="astr">20</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.VlanCount" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.VLAN.1.Interface" type="astr">Device.X_RDK_Ethernet.VLANTermination.1</Record> \
   <Record name="dmsb.wanmanager.if.1.VirtualInterface.1.MarkingCount" type="astr">0</Record>' ${D}/usr/ccsp/config/bbhm_def_cfg.xml
    fi
}

LDFLAGS_append_dunfell = " -lpthread"
