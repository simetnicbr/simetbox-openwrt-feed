include $(TOPDIR)/rules.mk

#
# Copyright (C) 2017 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#


PKG_NAME:=simetbox-openwrt-zabbix
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/simetbox-openwrt-zabbix
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Zabbix Support
  DEPENDS:=+zabbix-agentd +simetbox-openwrt-base
  URL:=http://simet.nic.br
#  MENU:=1
endef

define Package/simetbox-openwrt-zabbix/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

define Build/Compile/Default
endef

define Package/simetbox-openwrt-zabbix/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/zabbix_agentd_v2.conf $(1)/etc/zabbix_agentd_v2_simetbox.conf
	$(INSTALL_BIN) files/zabbix_agentd_v3.conf $(1)/etc/zabbix_agentd_v3_simetbox.conf
endef

$(eval $(call BuildPackage,simetbox-openwrt-zabbix))
