#
# Copyright (c) 2019 NIC.br
# Copyright (C) 2006-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

# This builds a hackish variant of nping-ssl that SIMET requires.  All
# changes are in patch form, and are distributed under the same license as
# nmap itself.

#TODO
# * uClibcpp not supported, performance +100x slower. libstdcpp is being used. https://bugs.busybox.net/show_bug.cgi?id=2545
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nmap
PKG_VERSION:=7.70
PKG_RELEASE:=102
PKG_MAINTAINER:=SIMET <medicoes@simet.nic.br>

PKG_SOURCE:=nmap-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://nmap.org/dist/
PKG_HASH:=847b068955f792f4cc247593aca6dc3dc4aae12976169873247488de147a6e18
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

# because we do build nmap, even if we only take nping
PKG_BUILD_DEPENDS:=pcre zlib

include $(INCLUDE_DIR)/package.mk

define Package/simet-nping
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  URL:=http://nmap.org/
  DEPENDS:=+libpcap +libpthread +libstdcpp +libopenssl
  VARIANT:=simet
  TITLE:=SIMET nping variant with tracefilter-like behavior
endef

CONFIGURE_ARGS += \
	--with-openssl="$(STAGING_DIR)/usr" --without-libssh2 \
	--with-libdnet=included \
	--with-libpcre="$(STAGING_DIR)/usr" \
	--with-libpcap="$(STAGING_DIR)/usr" \
	--without-liblua \
	--without-zenmap \
	--without-ndiff \
	--without-ncat \
	--without-nmap-update

CONFIGURE_VARS += \
	ac_cv_dnet_bsd_bpf=no \
	CXXFLAGS="$$$$CXXFLAGS -fno-builtin"

# NOTE: we use an uci-defaults script to make nping suid.  It could
# use setcap cap_net_raw+ep instead, but that would add an extra dependency
define Package/simet-nping/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/nping $(1)/usr/bin/simet-nping
	chmod -R og-w files/ && $(CP) files/. $(1)/
endef

$(eval $(call BuildPackage,simet-nping))
