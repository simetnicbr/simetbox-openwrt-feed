#
# Copyright (c) 2020 NIC.br <medicoes@simet.nic.br>
#
# This is free software, licensed under the GNU General Public License v3+

include $(TOPDIR)/rules.mk

PKG_NAME:=firewall-urpf
PKG_VERSION:=1
PKG_RELEASE:=2
PKG_LICENCE:=GPL-3.0-or-later
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_I18N_DIR:=$(PKG_BUILD_DIR)/luci-i18n
PKG_BUILD_DEPENDS:=luci-base

include $(INCLUDE_DIR)/package.mk

define Package/firewall-urpf
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=source address anti-spoofing (BCP38 uRPF) for firewall3
  URL:=https://github.com/simetnicbr
  MAINTAINER:=SIMET <medicoes@simet.nic.br>
  DEPENDS:=firewall +kmod-ipt-rpfilter +iptables-mod-rpfilter
  PKGARCH:=all
endef

define Package/firewall-urpf/description
 firewall-urpf implements IETF BCP38 (spoofed source address filtering)
 using unicast reverse-path filtering (uRPF).
 Refer to https://tools.ietf.org/html/bcp38 for the details.

 This package provides anti-spoofing protection against forged source
 addresses.  It protects both internal and external hosts automatically,
 at the cost of one extra route lookup per packet.

 This package includes integration with the LuCI firewall module.

 This is the package for firewall3, used by default in OpenWRT 21.02 and
 earlier.  For firewall4 (used by default in OpenWRT 22.03 and later),
 you need the "firewall4-urpf" package.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(CURDIR)/po PKG_BUILD_DIR=$(PKG_BUILD_DIR) PKG_I18N_DIR=$(PKG_I18N_DIR) i18n-build
endef

define Package/firewall-urpf/install
	$(INSTALL_DIR) $(1)/usr/lib/firewall-urpf
	$(INSTALL_BIN) ./files/fw3-urpf.script $(1)/usr/lib/firewall-urpf/fw3-urpf.script
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/firewall-urpf.uci-defaults $(1)/etc/uci-defaults/firewall-urpf
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(CP) $(PKG_I18N_DIR)/* $(1)/usr/lib/lua/luci/i18n
endef

#define Package/firewall-urpf/postinst
##!/bin/sh
#[ -z "$$IPKG_INSTROOT" ] && [ -x /etc/uci-defaults/firewall-urpf ] && /etc/uci-defaults/firewall-urpf || exit 0
#endef

#define Package/firewall-urpf/postrm
##!/bin/sh
#[ -z "$IPKG_INSTROOT" ] && uci delete firewall.urpf && uci commit firewall
#endef

$(eval $(call BuildPackage,firewall-urpf))
