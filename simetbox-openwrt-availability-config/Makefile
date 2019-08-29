include $(TOPDIR)/rules.mk

#
# Copyright (C) 2017 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#


PKG_NAME:=simetbox-openwrt-availability-config
PKG_RELEASE:=3

include $(INCLUDE_DIR)/package.mk

define Package/simetbox-openwrt-availability-config
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Availability analysis and remote configuration using PAS (https://pas.nic.br)
  DEPENDS:=+simetbox-openwrt-base +easycwmp
  URL:=http://simet.nic.br
#  MENU:=1
endef

define Build/Compile
endef

define Package/simetbox-openwrt-availability-config/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

define Package/simetbox-openwrt-availability-config/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/config/simet_installed
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/sbin
	echo $(CONFIG_SIMETBOX_TR069) >> $(1)/etc/config/tr069_server
	touch $(1)/etc/config/simet_installed/simetbox_network_and_config_installed
endef

define Package/simetbox-openwrt-availability-config/config
        source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage,simetbox-openwrt-availability-config))
