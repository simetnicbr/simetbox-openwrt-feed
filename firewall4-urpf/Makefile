#
# Copyright (c) 2022 NIC.br <medicoes@simet.nic.br>
#
# This is free software, licensed under the GNU General Public License v3+

include $(TOPDIR)/rules.mk

PKG_NAME:=firewall4-urpf
PKG_VERSION:=1
PKG_RELEASE:=1
PKG_LICENCE:=GPL-3.0-or-later
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_I18N_DIR:=$(PKG_BUILD_DIR)/luci-i18n
PKG_BUILD_DEPENDS:=luci-base

include $(INCLUDE_DIR)/package.mk

define Package/firewall4-urpf
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=source address anti-spoofing (BCP38 uRPF) for firewall4
  URL:=https://github.com/simetnicbr
  MAINTAINER:=SIMET <medicoes@simet.nic.br>
  DEPENDS:=firewall4
  CONFLICTS:=firewall-urpf
  PKGARCH:=all
endef

define Package/firewall4-urpf/description
 firewall4-urpf implements IETF BCP38 (spoofed source address filtering)
 using unicast reverse-path filtering (uRPF).
 Refer to https://tools.ietf.org/html/bcp38 for the details.

 This package provides anti-spoofing protection against forged source
 addresses.  It protects both internal and external hosts automatically,
 at the cost of one extra route lookup per packet.

 This package includes integration with the LuCI firewall module.

 This is the package for firewall4, used by default in OpenWRT 22.03 and
 later.  For firewall3 (used by default in OpenWRT 21.02 and earlier),
 you need the "firewall-urpf" package.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(CURDIR)/po PKG_BUILD_DIR=$(PKG_BUILD_DIR) PKG_I18N_DIR=$(PKG_I18N_DIR) i18n-build
endef

define Package/firewall4-urpf/install
	$(INSTALL_DIR) $(1)/usr/lib/firewall-urpf
	$(INSTALL_BIN) ./files/fw4-urpf.nft $(1)/usr/lib/firewall-urpf/fw4-urpf.nft
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/firewall4-urpf.uci-defaults $(1)/etc/uci-defaults/firewall4-urpf
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(CP) $(PKG_I18N_DIR)/* $(1)/usr/lib/lua/luci/i18n
endef

#define Package/firewall4-urpf/postinst
#!/bin/sh
#[ -z "$IPKG_INSTROOT" ] && [ -x /etc/uci-defaults/firewall4-urpf ] && /etc/uci-defaults/firewall4-urpf || exit 0
#endef

#define Package/firewall4-urpf/postrm
##!/bin/sh
#[ -z "$IPKG_INSTROOT" ] && uci delete firewall.urpf && uci commit firewall
#endef

$(eval $(call BuildPackage,firewall4-urpf))
