#
# Copyright (C) 2019 NIC.br
#
# This is free software, licensed under the GNU General Public License v3
# or later. See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=simetbox-openwrt-core
PKG_RELEASE:=2
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_MAINTAINER:=SIMET <medicoes@simet.nic.br>

include $(INCLUDE_DIR)/package.mk

define Package/simetbox-openwrt-core
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox openwrt core
  DEPENDS:= +bcp38
  URL:=https://simet.nic.br
#  MENU:=1
endef

define Package/simetbox-openwrt-core/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/simetbox-openwrt-core/install
	chmod -R og-w files/ && $(CP) files/. $(1)/
endef

#define Package/simetbox-openwrt-core/postinst
##!/bin/sh
##check if we are on real system
#if [ -z "$${IPKG_INSTROOT}" ]; then
#	echo "Clearing previous non-hardcoded LMAP configuration"
#	rm -f /var/run/lmapd/*.json
#fi
#:
#endef

$(eval $(call BuildPackage,simetbox-openwrt-core))
