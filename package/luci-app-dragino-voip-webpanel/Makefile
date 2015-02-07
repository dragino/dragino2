#
# Copyright (c) 2015 Dragino All right reserved.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-dragino-voip-webpanel
PKG_VERSION:=Dragino-VoIP-UI-1.0
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:= Dragino VoIP web panel
  DEPENDS:=+luci +luci-lib-json
endef

define Package/$(PKG_NAME)/description
	Dragino VoIP web panel
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)/usr
	mkdir -p $(PKG_BUILD_DIR)/etc/config
	$(CP) ./files/usr/* $(PKG_BUILD_DIR)/usr
	$(CP) ./files/etc/* $(PKG_BUILD_DIR)/etc
endef

define Build/Compile
	# NOOP
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/etc/* $(1)/etc/

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/admin_voip
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/admin_voip
	$(INSTALL_DIR) $(1)/usr/lib/lua/dragino

	$(CP) $(PKG_BUILD_DIR)/usr/* $(1)/usr/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

