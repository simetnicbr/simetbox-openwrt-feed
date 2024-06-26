include $(TOPDIR)/rules.mk

#
# Copyright (C) 2017-2020 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#


PKG_BRANCH:=branches/master

PKG_NAME:=simetbox-openwrt-base
PKG_RELEASE:=1

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_BUILD_PARALLEL:=0

PKG_VERSION:=111
PKG_REV:=v$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_HASH:=828534142e684df99eed1f3f321cf55d07468c763cf7cb0e4931840c2ca5090a
PKG_HASH:=skip
PKG_MIRROR_HASH:=$(PKG_HASH)

PKG_SOURCE_URL:=https://github.com/simetnicbr/simetbox-openwrt-base.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz

PKG_BUILD_DEPENDS+=openssl libpthread simetbox-openwrt-config

include $(INCLUDE_DIR)/package.mk

# CONFIGURE_ARGS += --with-ssl-dir="$(STAGING_DIR)/usr"

ifeq ($(CONFIG_SIMETBOX_COMMON),y)
	LN_SIMET_CLIENT:=$(LN)
	CP_SIMET_CLIENT:=$(CP)
	INSTALL_BIN_SIMET_CLIENT:=$(INSTALL_BIN)
	TOUCH_SIMET_CLIENT:=touch
	SIMET1_DEPS:=+libopenssl +libpthread +simetbox-openwrt-config

  ifeq ($(CONFIG_SIMETBOX_PORT25),y)
	LN_PORT25:=$(LN)
	CP_PORT25:=$(CP)
	TOUCH_PORT25:=touch
  else
	LN_PORT25:=echo Not configured -\> $(LN)
	CP_PORT25:=echo Not configured -\> $(CP)
	TOUCH_PORT25:=echo Not configured -\> touch
  endif
  ifeq ($(CONFIG_SIMETBOX_BCP38),y)
	LN_BCP38:=$(LN)
	CP_BCP38:=$(CP)
	TOUCH_BCP38:=touch
  else
	LN_BCP38:=echo Not configured -\> $(LN)
	CP_BCP38:=echo Not configured -\> $(CP)
	TOUCH_BCP38:=echo Not configured -\> touch
  endif
  ifeq ($(CONFIG_SIMETBOX_CONTENT_PROVIDER),y)
	LN_SIMETBOX_CONTENT_PROVIDER:=$(LN)
	CP_SIMETBOX_CONTENT_PROVIDER:=$(CP)
	TOUCH_SIMETBOX_CONTENT_PROVIDER:=touch
  else
	LN_SIMETBOX_CONTENT_PROVIDER:=echo Not configured -\> $(LN)
	CP_SIMETBOX_CONTENT_PROVIDER:=echo Not configured -\> $(CP)
	TOUCH_SIMETBOX_CONTENT_PROVIDER:=echo Not configured -\> touch
  endif
  ifeq ($(CONFIG_SIMETBOX_TOP10),y)
	LN_SIMETBOX_TOP10:=$(LN)
	CP_SIMETBOX_TOP10:=$(CP)
	TOUCH_SIMETBOX_TOP10:=touch
  else
	LN_SIMETBOX_TOP10:=echo Not configured -\> $(LN)
	CP_SIMETBOX_TOP10:=echo Not configured -\> $(CP)
	TOUCH_SIMETBOX_TOP10:=echo Not configured -\> touch
  endif
  ifeq ($(CONFIG_SIMETBOX_TRAFFIC),y)
	LN_SIMETBOX_TRAFFIC:=$(LN)
	CP_SIMETBOX_TRAFFIC:=$(CP)
	TOUCH_SIMETBOX_TRAFFIC:=touch
  else
	LN_SIMETBOX_TRAFFIC:=echo Not configured -\> $(LN)
	CP_SIMETBOX_TRAFFIC:=echo Not configured -\> $(CP)
	TOUCH_SIMETBOX_TRAFFIC:=echo Not configured -\> touch
  endif
  ifeq ($(CONFIG_SIMETBOX_DNS),y)
	LN_SIMETBOX_DNS:=$(LN)
	CP_SIMETBOX_DNS:=$(CP)
	TOUCH_SIMETBOX_DNS:=touch
  else
	LN_SIMETBOX_DNS:=echo Not configured -\> $(LN)
	CP_SIMETBOX_DNS:=echo Not configured -\> $(CP)
	TOUCH_SIMETBOX_DNS:=echo Not configured -\> touch
  endif
  ifeq ($(CONFIG_SIMETBOX_PING),y)
	LN_SIMETBOX_PING:=$(LN)
	CP_SIMETBOX_PING:=$(CP)
	TOUCH_SIMETBOX_PING:=touch
  else
	LN_SIMETBOX_PING:=echo Not configured -\> $(LN)
	CP_SIMETBOX_PING:=echo Not configured -\> $(CP)
	TOUCH_SIMETBOX_PING:=echo Not configured -\> touch
  endif
else
	LN_SIMET_CLIENT:=echo Not configured -\> $(LN)
	CP_SIMET_CLIENT:=echo Not configured -\> $(CP)
	INSTALL_BIN_SIMET_CLIENT:=echo Not configured -\> $(INSTALL_BIN)
	TOUCH_SIMET_CLIENT:=echo Not configured -\> touch
	SIMET1_DEPS:=
endif

define Package/simetbox-openwrt-base
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox
  DEPENDS:=+libjson-c +luci-lib-jsonc +luci-lib-json +libuci-lua +curl +ca-bundle
  DEPENDS+=+SIMETBOX_COMMON:libopenssl +SIMETBOX_COMMON:libpthread +SIMETBOX_COMMON:simetbox-openwrt-config
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
ifeq ($(CONFIG_SIMETBOX_COMMON),y)
	$(INSTALL_DIR) $(1)/usr/lib/simet/simet_installed
	$(INSTALL_DIR) $(1)/etc/factory_config
endif
	$(INSTALL_DIR) $(1)/usr/lib/lua/simet
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_DIR) $(1)/lib/upgrade
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(CP) files/* $(1)/
ifeq ($(CONFIG_SIMETBOX_COMMON),y)
	$(INSTALL_BIN_SIMET_CLIENT) $(PKG_BUILD_DIR)/src/simet_tools $(1)/usr/bin/
	$(LN_SIMET_CLIENT) /usr/bin/simet_tools $(1)/usr/bin/simet_client
	$(LN_SIMET_CLIENT) /usr/bin/simet_tools $(1)/usr/bin/simet_ws
	$(LN_SIMET_CLIENT) /usr/bin/simet_tools $(1)/usr/bin/simet_hash_measure
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simetbox_config  $(1)/etc/init.d
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/get_lat_long.sh  $(1)/usr/bin
	$(TOUCH_SIMET_CLIENT) $(1)/usr/lib/simet/simet_installed/simetbox_base_installed

	$(LN_PORT25) /usr/bin/simet_tools $(1)/usr/bin/simet_porta25
	$(TOUCH_PORT25) $(1)/usr/lib/simet/simet_installed/simetbox_port25_installed
	
	$(LN_BCP38) /usr/bin/simet_tools $(1)/usr/bin/simet_bcp38
	$(TOUCH_BCP38) $(1)/usr/lib/simet/simet_installed/simetbox_bcp38_installed

	$(CP_SIMETBOX_CONTENT_PROVIDER) $(PKG_BUILD_DIR)/files/sendcontentprovider.sh  $(1)/usr/bin
	$(TOUCH_SIMETBOX_CONTENT_PROVIDER) $(1)/usr/lib/simet/simet_installed/simetbox_contentprovider_installed

	$(LN_SIMETBOX_TOP10) /usr/bin/simet_tools $(1)/usr/bin/simet_alexa
	$(TOUCH_SIMETBOX_TOP10) $(1)/usr/lib/simet/simet_installed/simetbox_top10alexa_installed

	$(CP_SIMETBOX_TRAFFIC) $(PKG_BUILD_DIR)/files/simet_send_if_traffic.sh  $(1)/usr/bin
	$(TOUCH_SIMETBOX_TRAFFIC) $(1)/usr/lib/simet/simet_installed/simetbox_iftraffic_installed

	$(LN_SIMETBOX_DNS) /usr/bin/simet_tools $(1)/usr/bin/simet_dns
	$(CP_SIMETBOX_DNS) $(PKG_BUILD_DIR)/files/simet_dns_ping_traceroute.sh  $(1)/usr/bin
	$(CP_SIMETBOX_DNS) $(PKG_BUILD_DIR)/files/simet_traceroute.sh $(1)/usr/bin
	$(CP_SIMETBOX_DNS) $(PKG_BUILD_DIR)/files/simet_ping.sh $(1)/usr/bin
	$(TOUCH_SIMETBOX_DNS) $(1)/usr/lib/simet/simet_installed/simetbox_dns_installed
	$(TOUCH_SIMETBOX_DNS) $(1)/usr/lib/simet/simet_installed/simetbox_ping_installed

	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simet_geolocation_legado.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/personal_data.lua  $(1)/usr/lib/lua/simet
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/run_simet.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/get_uci.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/set_uci.sh  $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/files/simet1.conf  $(1)/etc/simet/simet1.conf
endif
	$(CP) $(PKG_BUILD_DIR)/files/get_mac_address.sh  $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/files/get_model.sh  $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/files/get_simet_box_version.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simet_utils.lua  $(1)/usr/lib/lua/simet
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simetbox_register.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/uci-defaults/99-simet-cron  $(1)/etc/uci-defaults
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/uci-defaults/01-simet1-cleanup  $(1)/etc/uci-defaults
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/crontab_writer.lua  $(1)/usr/lib/lua/simet
endef

define Package/simetbox-openwrt-base/config
	select BUSYBOX_CUSTOM
	select BUSYBOX_CONFIG_TRACEROUTE
	select BUSYBOX_CONFIG_FEATURE_TRACEROUTE_USE_ICMP
	select BUSYBOX_CONFIG_FEATURE_TRACEROUTE_VERBOSE
	select BUSYBOX_CONFIG_TRACEROUTE6 if IPV6 && !PACKAGE_iputils-traceroute6
	select BUSYBOX_CONFIG_SHA256SUM
	select BUSYBOX_CONFIG_MD5SUM
	source "$(SOURCE)/Config.in"
endef

define Build/Compile
endef


$(eval $(call BuildPackage,simetbox-openwrt-base))
