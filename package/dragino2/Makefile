# Copyright (c) 2013 Edwin Chen

include $(TOPDIR)/rules.mk

PKG_NAME:=dragino2
PKG_VERSION:=1.0-IoT
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/dragino2
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=
  TITLE:=Dragino -- OpenWrt Sensor Project
  URL:=http://www.dragino.com
  MAINTAINER:=Edwin Chen <edwin@dragino.com>
endef

define Package/dragino2/description
	Code for dragino2 project.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
#	$(CP) ./src/* $(PKG_BUILD_DIR)/
#	$(CP) ./luasrc/* $(PKG_BUILD_DIR)/
	$(CP) ./config/* $(PKG_BUILD_DIR)/
	$(CP) -r ./files $(PKG_BUILD_DIR)/files
endef

define Build/Compile
endef
BUILD_TIME:=$(shell date)

define Package/dragino2/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/files/etc/banner $(1)/etc/banner
	
#	$(SED) 's,$$$$R,$(REVISION),g' $(1)/etc/banner
	$(SED) 's,$$$$F,$(PKG_VERSION)-$(PKG_RELEASE),g' $(1)/etc/banner
	$(SED) 's,$$$$T,$(BUILD_TIME),g' $(1)/etc/banner

#	$(INSTALL_DIR) $(1)/usr/lib/sensor
#	$(INSTALL_DATA) $(PKG_BUILD_DIR)/files/usr/lib/sensor/* $(1)/usr/lib/sensor/

#	$(INSTALL_DIR) $(1)/etc/config
#	$(INSTALL_DATA) $(PKG_BUILD_DIR)/sensor.uci $(1)/etc/config/sensor
#	$(INSTALL_DATA) $(PKG_BUILD_DIR)/IoTServer.uci $(1)/etc/config/IoTServer
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dragino.init $(1)/etc/init.d/dragino

#	$(INSTALL_DIR) $(1)/usr/sbin
#	$(INSTALL_BIN) $(PKG_BUILD_DIR)/luad $(1)/usr/sbin/
#	$(LN) /usr/sbin/luad $(1)/usr/sbin/IoTd
#	$(INSTALL_BIN) $(PKG_BUILD_DIR)/IoTd.lua $(1)/usr/sbin/

#	$(INSTALL_DIR) $(1)/usr/bin
#	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fdude.lua $(1)/usr/bin/fdude

#	$(INSTALL_DIR) $(1)/usr/lib/lua/dragino
#	$(INSTALL_DATA) $(PKG_BUILD_DIR)/dragino/*.lua $(1)/usr/lib/lua/dragino/
endef

$(eval $(call BuildPackage,dragino2))
