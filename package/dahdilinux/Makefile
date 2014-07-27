# 
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: $

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dahdi-linux
PKG_VERSION:=2.4.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://downloads.digium.com/pub/telephony/dahdi-linux/releases/
PKG_MD5SUM:=3a4403a0abafa4574ac1a6b50c2f9dde

DAHDI_MODULES_EXTRA:=dfxs

include $(INCLUDE_DIR)/package.mk

define KernelPackage/dahdi-linux
  SUBMENU:=Other modules
  TITLE:=DAHDI basic infrastructure.
  DEPENDS:=@USB_SUPPORT kmod-si3217x
  URL:=http://www.asterisk.org/
  FILES:=$(PKG_BUILD_DIR)/drivers/dahdi/dahdi.$(LINUX_KMOD_SUFFIX)
  #AUTOLOAD:=$(call AutoLoad,90,dahdi)
endef

define KernelPackage/dahdi-linux/description
	This package contains DAHDI basic infrastructure.
endef

define Build/Configure
endef

TARGET_CFLAGS += $(FPIC)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		ARCH="$(LINUX_KARCH)" \
		$(TARGET_CONFIGURE_OPTS) \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELVERSION="$(KERNEL)" \
		KERNEL_VERSION="$(LINUX_VERSION)" \
		KERNELDIR="$(LINUX_DIR)" \
		KSRC:="$(LINUX_DIR)" \
		KVERS:="$(LINUX_VERSION)" \
		TOPDIR:="$(TOPDIR)" \
		INCLUDE_DIR:="$(INCLUDE_DIR)" \
		PWD:="$(PKG_BUILD_DIR)" \
		MODULES_EXTRA:="$(DAHDI_MODULES_EXTRA)"
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include/dahdi
	$(CP) $(PKG_BUILD_DIR)/include/dahdi/fasthdlc.h   $(1)/usr/include/dahdi/
	$(CP) $(PKG_BUILD_DIR)/include/dahdi/kernel.h     $(1)/usr/include/dahdi/
	$(CP) $(PKG_BUILD_DIR)/include/dahdi/user.h       $(1)/usr/include/dahdi/
	$(CP) $(PKG_BUILD_DIR)/include/dahdi/wctdm_user.h $(1)/usr/include/dahdi/
endef

define KernelPackage/dahdi-linux/install
	$(INSTALL_DIR) $(1)/etc/hotplug.d/dahdi
	$(INSTALL_DATA) ./files/10-create-device-node $(1)/etc/hotplug.d/dahdi/
#	$(INSTALL_DATA) ./files/hotplug2.rules $(1)/etc/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/dahdi.init $(1)/etc/init.d/dahdi

	$(INSTALL_DATA) $(PKG_BUILD_DIR)/drivers/dahdi/dfxs.ko $(1)/lib/modules/$(LINUX_VERSION)/
endef

$(eval $(call KernelPackage,dahdi-linux))
