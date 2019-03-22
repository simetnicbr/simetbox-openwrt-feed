#
# Copyright (C) 2018-2019 NIC.br
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=simetbox-openwrt-simet-lmapd
PKG_RELEASE:=9

#PKG_FIXUP:=
PKG_INSTALL:=1

PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/simetnicbr/simet-lmapd.git

PKG_REV:=HEAD
PKG_VERSION:=0.10.0
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=$(PKG_REV)

PKG_BUILD_DEPENDS:=libevent2 libjson-c pkg-config check

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/simetbox-openwrt-simet-lmapd
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox SIMET-2 lmapd scheduler
  DEPENDS:=+libevent2 +libjson-c
  URL:=https://simet.nic.br
  USERID:=nicbr-simet:nicbr-simet
#  MENU:=1
#  DEPENDS:=+simetbox-openwrt-base +libcurl +curl +ca-certificates +!BUSYBOX_CONFIG_FLOCK:flock
endef

define Package/simetbox-openwrt-simet-lmapd/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

CMAKE_OPTIONS += -DCMAKE_BUILD_TYPE:STRING=MinSizeRel -DBUILD_SHARED_LIBS:BOOL=ON \
	-DBUILD_TESTS:BOOL=OFF -DBUILD_XML:BOOL=OFF -DBUILD_JSON:BOOL=ON \
	-DLMAPD_CONFIG_DIR:PATH="/usr/lib/simet/lmap/config.d:/etc/simet/lmap:/var/run/lmapd/lmap-schedule.json" \
	-DLMAPD_CAPABILITY_DIR:PATH="/usr/lib/simet/lmap/registry.d" \
	-DLMAPD_RUN_DIR:PATH="/var/run/lmapd"

define Package/simetbox-openwrt-simet-lmapd/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/lib/simet $(1)/usr/lib/simet/lmap $(1)/etc/simet/lmap
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/lib*.so* $(1)/usr/lib
	# these may fail if we're not using them on this build
	-$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/simet/* $(1)/usr/lib/simet
	-chmod -R og-w files/ && $(CP) files/. $(1)/
endef

$(eval $(call BuildPackage,simetbox-openwrt-simet-lmapd))
