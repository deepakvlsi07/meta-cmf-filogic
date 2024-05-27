# Mediatek Upstream SoftMAC WiFi Driver - MT76 Release Note (RDK-B)

## Compile Environment Requirement

- Use Ubuntu 18.04

---

## Latest Release Version

#### Filogic 880/860 WiFi7 MLO Alpha Release (20240514)

##### External Release

```
#Get  latest RDKB core release  : https://wiki.rdkcentral.com/display/CMF/RDK-B+Code+Releases

dunfell : repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests  -b rdkb-2024q1-dunfell -m rdkb-nosrc.xml

kirkstone : repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests  -b rdkb-2024q1-kirkstone -m rdkb-nosrc.xml

repo sync -j `nproc` --no-clone-bundle --no-tags

#Get filogic BSP meta layer
git clone https://git01.mediatek.com/filogic/rdk-b/meta-filogic
cd meta-filogic; git checkout 5c8e7ef29bd1801c75126c10f67e1d0d1cac7485; cd -;

#Get filogic Adapter cmf layer
git clone https://git01.mediatek.com/filogic/rdk-b/meta-cmf-filogic
cd meta-cmf-filogic; git checkout ab57bb162d5e3009f09c49092ce3b88790dd0669; cd -;

#Choose one platform to build
#Filogic880
MACHINE=filogic880 source meta-cmf-filogic/setup-environment-release && bitbake rdk-generic-broadband-image

#Bpi-r4
MACHINE=filogic880-bpi-r4 source meta-cmf-filogic/setup-environment-release && bitbake rdk-generic-broadband-image
```

##### WiFi Package Version

refer to https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/refs/heads/master/autobuild_mac80211_release/Release.md#filogic-880_860-wifi7-mlo-alpha-release-20240426



#### Filogic 830/820/630/615 WiFi6 MP2.3 Release (20240514)

```
#Get  latest RDKB core release  : https://wiki.rdkcentral.com/display/CMF/RDK-B+Code+Releases

dunfell : repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests  -b rdkb-2024q1-dunfell -m rdkb-nosrc.xml

kirkstone : repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests  -b rdkb-2024q1-kirkstone -m rdkb-nosrc.xml

repo sync -j `nproc` --no-clone-bundle --no-tags

#Get filogic BSP meta layer
git clone https://git01.mediatek.com/filogic/rdk-b/meta-filogic
cd meta-filogic; git checkout 5c8e7ef29bd1801c75126c10f67e1d0d1cac7485; cd -;

#Get filogic Adapter cmf layer
git clone https://git01.mediatek.com/filogic/rdk-b/meta-cmf-filogic
cd meta-cmf-filogic; git checkout ab57bb162d5e3009f09c49092ce3b88790dd0669; cd -;

#Choose one platform to build
#Filogic830
MACHINE=filogic830 source meta-cmf-filogic/setup-environment-release && bitbake rdk-generic-broadband-image

```

##### WiFi Package Version

refer to https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/refs/heads/master/autobuild_mac80211_release/Release.md#filogic-830_820_630_615-wifi6-mp2_3-release-20240510

---


