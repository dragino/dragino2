# Copyright (c) 2013 Edwin Chen

include $(TOPDIR)/rules.mk

PKG_NAME:=dragino2
PKG_VERSION:=IoT-1.1
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
	mkdir -p $(PKG_BUILD_DIR)/etc
	mkdir -p $(PKG_BUILD_DIR)/usr/bin
	$(CP) ./files/etc/* $(PKG_BUILD_DIR)/etc
	$(CP) ./files/usr/* $(PKG_BUILD_DIR)/usr
endef

define Build/Compile
endef
BUILD_TIME:=$(shell date)

define Package/dragino2/install
	$(INSTALL_DIR) $(1)/etc
	$(RM) $(TOPDIR)/files/etc/banner
	$(CP) $(PKG_BUILD_DIR)/etc/banner $(TOPDIR)/files/etc/banner
	
	$(SED) 's,$$$$F,$(PKG_VERSION).$(PKG_RELEASE),g' $(TOPDIR)/files/etc/banner
	$(SED) 's,$$$$T,$(BUILD_TIME),g' $(TOPDIR)/files/etc/banner

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/init.d/dragino.init $(1)/etc/init.d/dragino

	$(INSTALL_DIR) $(1)/etc/arduino/ATmegaBoot
	$(CP) $(PKG_BUILD_DIR)/etc/arduino/* $(1)/etc/arduino/

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/usr/* $(1)/usr/

endef

$(eval $(call BuildPackage,dragino2))
