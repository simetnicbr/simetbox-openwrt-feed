include $(TOPDIR)/rules.mk

#
# Copyright (C) 2017 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#


PKG_NAME:=simetbox-openwrt-ntpd
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

define Package/simetbox-openwrt-ntpd
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Ntpd Support
  DEPENDS:=+ntpd +simetbox-openwrt-base
  URL:=http://simet.nic.br
#  MENU:=1
endef

define Build/Compile
endef

define Package/simetbox-openwrt-ntpd/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

define Package/simetbox-openwrt-ntpd/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) files/ntp.conf $(1)/etc/ntp.conf_simetbox
	$(INSTALL_DIR) $(1)/usr/lib/simet/simet_installed
	$(INSTALL_DIR) $(1)/usr/bin
	$(LN) /usr/bin/simet_tools $(1)/usr/bin/simet_ntpq
	touch $(1)/usr/lib/simet/simet_installed/simetbox_ntpd_installed
endef

$(eval $(call BuildPackage,simetbox-openwrt-ntpd))
