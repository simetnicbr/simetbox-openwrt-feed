#
# Copyright (C) 2018-2019 NIC.br
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=simetbox-openwrt-simet-ma
PKG_RELEASE:=1

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_VERSION:=0.18.13.2
PKG_REV:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=skip

PKG_SOURCE_URL:=https://github.com/simetnicbr/simet-ma.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_SOURCE_VERSION:=$(PKG_REV)

PKG_BUILD_DEPENDS:=curl

include $(INCLUDE_DIR)/package.mk

CONFIGURE_ARGS += --enable-simetbox
ifndef CONFIG_SIMET2_SPOOFER
	CONFIGURE_ARGS += --disable-simet-spoofer
endif

define Package/simetbox-openwrt-simet-ma
  SUBMENU:=SIMETBox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=SIMETBox SIMET-2 measurement engine
  DEPENDS:=+simetbox-openwrt-base
  DEPENDS+=+libcurl +curl +ca-bundle +!BUSYBOX_CONFIG_FLOCK:flock
  DEPENDS+=+simetbox-openwrt-simet-lmapd
  DEPENDS+=+!BUSYBOX_CONFIG_SHA256SUM:coreutils-sha256sum
  DEPENDS+=+!BUSYBOX_CONFIG_MD5SUM:coreutils-md5sum
  URL:=https://simet.nic.br
  USERID:=nicbr-simet:nicbr-simet
#  MENU:=1
endef

define Package/simetbox-openwrt-simet-ma/conffiles
/etc/config/simet_ma
endef

define Package/simetbox-openwrt-simet-ma/description
 SIMETBox is a suite of tools to measure the quality of the internet. It's designed to be used mainly in Brazil measuring the internet from users home to Internet Exchange Points.
endef

define Package/simetbox-openwrt-simet-ma/config
	source "$(SOURCE)/Config.in"
endef

# default target gratuitously overrides CC, etc and undoes the work
# done by autoconf.
define Build/Compile
	make -C "$(PKG_BUILD_DIR)"
endef

define Package/simetbox-openwrt-simet-ma/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/simet $(1)/etc/simet/lmap \
		$(1)/usr/lib/simet/lmap/registry.d $(1)/usr/lib/simet/lmap/config.d
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/simet/. $(1)/usr/lib/simet/
	# this one can fail, we often have it empty
	-$(INSTALL_DATA) $(PKG_INSTALL_DIR)/etc/simet/* $(1)/etc/simet
	chmod -R og-w files/ && $(CP) files/. $(1)/
	# "uci commit" since LEDE is broken and will force mode 0600 anyway
	-chmod 0600 $(1)/etc/config/*
ifdef CONFIG_SIMETBOX_APPLINK
	# simet-app link
	$(INSTALL_DIR) $(1)/www/simet
	$(INSTALL_DATA) applink-htdocs/* $(1)/www/simet/
	chmod -R og-w applink-files/ && $(CP) applink-files/. $(1)/
endif
endef

define Package/simetbox-openwrt-simet-ma/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && {
	echo "Clearing previous non-hardcoded LMAP configuration"
	rm -f /var/run/lmapd/*.json
	/etc/init.d/simet-ma enable
	[ -d /var/run/lmapd ] && {
	       # no need to touch symlinks, they're either dangling or point to up-to-date packaged data
	       find /var/run/lmapd -maxdepth 2 -type f -name '*.json' -delete || true

	       # We ensure there *is* a schedule for each lmapd just in case
	       # shellcheck disable=SC2015
	       find /var/run/lmapd -mindepth 1 -maxdepth 1 -type d -exec ln -sf /usr/lib/simet/lmap-empty-schedule.json "{}/lmap-schedule.json" \; || true
	       ln -sf /usr/lib/simet/lmap-emergency-schedule.json /var/run/lmapd/lmap-schedule.json || true
	       find /var/run/lmapd -maxdepth 2 \( -type f -o -type l \) -name lmap-schedule.json -exec chown -h nicbr-simet:nicbr-simet "{}" + || true
	}
	( . /usr/lib/simet/simet_lib_config.sh && {
	       [ -n "$${AGENT_TOKEN_LOCK}" ] \
		       && test -s "$${AGENT_TOKEN_LOCK}" \
		       && printf "0\n" > "$${AGENT_TOKEN_LOCK}" \
		       || true
	       [ -n "$${AGENT_LOCK}" ] \
		       && test -s "$${AGENT_LOCK}" \
		       && : > "$${AGENT_LOCK}" \
		       || true
	} ) 2>/dev/null >/dev/null </dev/null || true
}
:
endef

$(eval $(call BuildPackage,simetbox-openwrt-simet-ma))
