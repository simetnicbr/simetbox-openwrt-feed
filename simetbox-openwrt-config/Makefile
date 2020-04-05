include $(TOPDIR)/rules.mk

PKG_BRANCH:=branches/master

PKG_NAME:=simetbox-openwrt-config
PKG_RELEASE:=1

PKG_INSTALL:=1

PKG_BUILD_PARALLEL:=0

PKG_REV:=master
PKG_VERSION:=1
PKG_SOURCE_VERSION:=$(PKG_REV)

PKG_SOURCE_URL:=https://github.com/simetnicbr/simetbox-openwrt-config.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

# Specify package information for this program. 
# The variables defined here should be self explanatory.
define Package/simetbox-openwrt-config
	SUBMENU:=SIMETBox
	SECTION:=net
	CATEGORY:=Network
	DEFAULT:=n
	TITLE:=SIMETBOX Config Library
	description:=SIMET library to load config files
endef


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/simet_config.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libsimetconfig.{a,so*} $(1)/usr/lib/
endef

define Package/simetbox-openwrt-config/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libsimetconfig.so.* $(1)/usr/lib/
endef


# This line executes the necessary commands to compile our program.
# The above define directives specify all the information needed, but this
# line calls BuildPackage which in turn actually uses this information to
# build a package.
$(eval $(call BuildPackage,simetbox-openwrt-config))
