#
# Copyright 2017 NIC.br
#
# You may redistribute this program and/or modify it under the terms of
# the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=simetbox-openwrt-luci
PKG_VERSION:=1.0
PKG_RELEASE:=3
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_I18N_DIR:=$(PKG_BUILD_DIR)/luci-i18n
PKG_BUILD_DEPENDS:=luci-base

include $(INCLUDE_DIR)/package.mk

define Package/simetbox-openwrt-luci
	SUBMENU:=SIMETBox
	SECTION:=net
	CATEGORY:=Network
	TITLE:=SIMETBox Luci Files
	DEPENDS:=+simetbox-openwrt-base +!PACKAGE_luci-ssl:luci-ssl-openssl
	URL:=http://simet.nic.br
endef

define Package/simetbox-openwrt-luci/description
        This package allows you to configure SIMETBox Measurements
endef

define Build/Compile
	$(MAKE) -C $(CURDIR)/po PKG_BUILD_DIR=$(PKG_BUILD_DIR) PKG_I18N_DIR=$(PKG_I18N_DIR) i18n-build
endef

define Package/simetbox-openwrt-luci/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/www
	$(CP) htdocs/* $(1)/www
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(CP) $(PKG_I18N_DIR)/* $(1)/usr/lib/lua/luci/i18n
	-chmod -R og-w files/ && $(CP) files/. $(1)/
endef

$(eval $(call BuildPackage,simetbox-openwrt-luci))
