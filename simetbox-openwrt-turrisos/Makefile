#
# Copyright (C) 2024 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=simetbox-openwrt-turrisos
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/simetbox-openwrt-turrisos
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox for NIC.cz Turris devices
  DEPENDS:=+crypto-wrapper +simetbox-openwrt-simet-ma +simetbox-openwrt-simet-lmapd +simetbox-openwrt-luci
  URL:=http://simet.nic.br
#  MENU:=1
endef

define Build/Compile
endef

define Package/simetbox-openwrt-turrisos/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
 The simetbox-openwrt-turrisos package must be installed on Turris devices for SIMETBox to work properly.
endef

define Package/simetbox-openwrt-turrisos/install
	$(INSTALL_DIR) $(1)/usr/lib/simet/vendor/
	$(INSTALL_BIN) files/vendor/turrisos/get_mac_label $(1)/usr/lib/simet/vendor/
	$(INSTALL_BIN) files/vendor/turrisos/get_platform_simet_secret $(1)/usr/lib/simet/vendor/
endef

$(eval $(call BuildPackage,simetbox-openwrt-turrisos))
