include $(TOPDIR)/rules.mk

#
# Copyright (C) 2017 NIC.br
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

PKG_REV:=HEAD
PKG_VERSION:=100
PKG_SOURCE_VERSION:=$(PKG_REV)

PKG_SOURCE_URL:=https://github.com/simetnicbr/simetbox-openwrt-base.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz

include $(INCLUDE_DIR)/package.mk

# CONFIGURE_ARGS += --with-ssl-dir="$(STAGING_DIR)/usr"

ifeq ($(CONFIG_SIMETBOX_COMMON),y)
	LN_SIMET_CLIENT:=$(LN)
	CP_SIMET_CLIENT:=$(CP)
	TOUCH_SIMET_CLIENT:=touch 
else
	LN_SIMET_CLIENT:=echo Not configured -\> $(LN) 
	CP_SIMET_CLIENT:=echo Not configured -\> $(CP)
	TOUCH_SIMET_CLIENT:=echo Not configured -\> touch
endif

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

define Package/simetbox-openwrt-base
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox
  DEPENDS:=+libjson-c +simetbox-openwrt-config +libopenssl +libpthread +luci-lib-jsonc +luci-lib-json +curl +ca-certificates
  URL:=http://simet.nic.br
#  MENU:=1
endef

define Package/simetbox-openwrt-base/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

define Package/simetbox-openwrt-base/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/config/simet_installed
	$(INSTALL_DIR) $(1)/usr/lib/lua/simet
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_DIR) $(1)/etc/factory_config
	$(INSTALL_DIR) $(1)/lib/upgrade
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(CP) files/* $(1)/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/simet_tools $(1)/usr/bin/
	$(LN_SIMET_CLIENT) /usr/bin/simet_tools $(1)/usr/bin/simet_client
	$(LN_SIMET_CLIENT) /usr/bin/simet_tools $(1)/usr/bin/simet_ws
	$(LN_SIMET_CLIENT) /usr/bin/simet_tools $(1)/usr/bin/simet_hash_measure
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simetbox_config  $(1)/etc/init.d
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/get_mac_address.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/get_model.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/get_lat_long.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/get_simet_box_version.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simet.conf  $(1)/etc/config
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simet_utils.lua  $(1)/usr/lib/lua/simet
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/get_uci.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/set_uci.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simet_geolocation.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/run_simet.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/simetbox_register.sh  $(1)/usr/bin
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/uci-defaults/99-simet-cron  $(1)/etc/uci-defaults
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/crontab_writer.lua  $(1)/usr/lib/lua/simet
	$(CP_SIMET_CLIENT) $(PKG_BUILD_DIR)/files/personal_data.lua  $(1)/usr/lib/lua/simet
	$(TOUCH_SIMET_CLIENT) $(1)/etc/config/simet_installed/simetbox_base_installed

	$(LN_PORT25) /usr/bin/simet_tools $(1)/usr/bin/simet_porta25
	$(TOUCH_PORT25) $(1)/etc/config/simet_installed/simetbox_port25_installed
	
	$(LN_BCP38) /usr/bin/simet_tools $(1)/usr/bin/simet_bcp38
	$(TOUCH_BCP38) $(1)/etc/config/simet_installed/simetbox_bcp38_installed

	$(CP_SIMETBOX_CONTENT_PROVIDER) $(PKG_BUILD_DIR)/files/sendcontentprovider.sh  $(1)/usr/bin
	$(TOUCH_SIMETBOX_CONTENT_PROVIDER) $(1)/etc/config/simet_installed/simetbox_contentprovider_installed

	$(LN_SIMETBOX_TOP10) /usr/bin/simet_tools $(1)/usr/bin/simet_alexa
	$(TOUCH_SIMETBOX_TOP10) $(1)/etc/config/simet_installed/simetbox_top10alexa_installed

	$(CP_SIMETBOX_TRAFFIC) $(PKG_BUILD_DIR)/files/simet_send_if_traffic.sh  $(1)/usr/bin
	$(TOUCH_SIMETBOX_TRAFFIC) $(1)/etc/config/simet_installed/simetbox_iftraffic_installed

	$(LN_SIMETBOX_DNS) /usr/bin/simet_tools $(1)/usr/bin/simet_dns
	$(CP_SIMETBOX_DNS) $(PKG_BUILD_DIR)/files/simet_dns_ping_traceroute.sh  $(1)/usr/bin
	$(CP_SIMETBOX_DNS) $(PKG_BUILD_DIR)/files/simet_traceroute.sh $(1)/usr/bin
	$(CP_SIMETBOX_DNS) $(PKG_BUILD_DIR)/files/simet_ping.sh $(1)/usr/bin
	$(TOUCH_SIMETBOX_DNS) $(1)/etc/config/simet_installed/simetbox_dns_installed
	$(TOUCH_SIMETBOX_DNS) $(1)/etc/config/simet_installed/simetbox_ping_installed
endef

define Package/simetbox-openwrt-base/config
	select BUSYBOX_CUSTOM
	select BUSYBOX_CONFIG_TRACEROUTE
	select BUSYBOX_CONFIG_FEATURE_TRACEROUTE_USE_ICMP
	select BUSYBOX_CONFIG_FEATURE_TRACEROUTE_VERBOSE
	select BUSYBOX_CONFIG_TRACEROUTE6 if IPV6 && !PACKAGE_iputils-traceroute6
	source "$(SOURCE)/Config.in"
endef

define Build/Compile
endef


$(eval $(call BuildPackage,simetbox-openwrt-base))
