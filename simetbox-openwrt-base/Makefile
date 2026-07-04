#
# Copyright (C) 2017-2020 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=simetbox-openwrt-base
PKG_RELEASE:=200.1

include $(INCLUDE_DIR)/package.mk

define Package/simetbox-openwrt-base
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox
  DEPENDS:=+libjson-c +luci-lib-jsonc +luci-lib-json +libuci-lua +curl +ca-bundle
  URL:=http://simet.nic.br
#  MENU:=1
endef

define Package/simetbox-openwrt-base/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

define Package/simetbox-openwrt-base/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/simet
	$(INSTALL_DIR) $(1)/usr/lib/lua/simet
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_DIR) $(1)/lib/upgrade
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d

	$(CP) files/* $(1)/
endef

define Package/simetbox-openwrt-base/config
	select BUSYBOX_CUSTOM
	select BUSYBOX_CONFIG_TRACEROUTE
	select BUSYBOX_CONFIG_FEATURE_TRACEROUTE_USE_ICMP
	select BUSYBOX_CONFIG_FEATURE_TRACEROUTE_VERBOSE
	select BUSYBOX_CONFIG_TRACEROUTE6 if IPV6 && !PACKAGE_iputils-traceroute6
	select BUSYBOX_CONFIG_SHA256SUM
	select BUSYBOX_CONFIG_MD5SUM
endef

define Build/Compile
endef

$(eval $(call BuildPackage,simetbox-openwrt-base))
