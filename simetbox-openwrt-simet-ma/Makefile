include $(TOPDIR)/rules.mk

#
# Copyright (C) 2018-2019 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PKG_NAME:=simetbox-openwrt-simet-ma
PKG_RELEASE:=1

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_REV:=stable
PKG_VERSION:=0.9.3
PKG_SOURCE_VERSION:=$(PKG_REV)

PKG_SOURCE_URL:=https://github.com/simetnicbr/simet-ma.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz

PKG_BUILD_DEPENDS:=curl

include $(INCLUDE_DIR)/package.mk

CONFIGURE_ARGS += --enable-simetbox

define Package/simetbox-openwrt-simet-ma
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox SIMET-2 measurement engine
  DEPENDS:=+simetbox-openwrt-base +libcurl +curl +ca-certificates +!BUSYBOX_CONFIG_FLOCK:flock
  URL:=https://simet.nic.br
#  MENU:=1
endef

define Package/simetbox-openwrt-simet-ma/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

# default target gratuitously overrides CC, etc and undoes the work
# done by autoconf.
define Build/Compile
	make -C "$(PKG_BUILD_DIR)"
endef

define Package/simetbox-openwrt-simet-ma/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/simet $(1)/usr/lib/simet
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/simet/* $(1)/usr/lib/simet
	# this one can fail, we often have it empty
	-$(INSTALL_DATA) $(PKG_INSTALL_DIR)/etc/simet/* $(1)/etc/simet
	chmod -R og-w files/ && $(CP) files/. $(1)/
endef

define Package/simetbox-openwrt-simet-ma/postinst
#!/bin/sh
#check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	echo "Enabling rc.d symlink for simetbox-openwrt-simet-ma (simet-ma)"
	/etc/init.d/simet-ma enable
fi
:
endef

define Package/simetbox-openwrt-simet-ma/prerm
#!/bin/sh
#check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	echo "Removing rc.d symlink for simetbox-openwrt-simet-ma (simet-ma)"
	/etc/init.d/simet-ma disable
fi
:
endef

$(eval $(call BuildPackage,simetbox-openwrt-simet-ma))
