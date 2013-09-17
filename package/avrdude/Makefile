#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=avrdude
PKG_VERSION:=5.10
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.savannah.gnu.org/releases/avrdude
PKG_MD5SUM:=69b082683047e054348088fd63bad2ff

include $(INCLUDE_DIR)/package.mk

define Package/avrdude
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=AVR Downloader/UploaDEr
  URL:=http://www.bsdhome.com/avrdude/
  DEPENDS:=@GPIO_SUPPORT +libncurses
endef

define Package/avrdude/description
 AVRDUDE is a full featured program for programming Atmel's AVR CPU's.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	chmod -R u+w $(PKG_BUILD_DIR)
endef

CONFIGURE_ARGS+= \
	--disable-parport \

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" CFLAGS="-I$(LINUX_DIR)/include"\
		install-exec
endef

define Package/avrdude/conffiles
/etc/avrdude.conf
endef

define Package/avrdude/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/avrdude.conf $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/avrdude $(1)/usr/bin/
endef

$(eval $(call BuildPackage,avrdude))
