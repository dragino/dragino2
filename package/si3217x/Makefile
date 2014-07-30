# SPI control for Silicon Labs Si3217x Single-Chip ProSLIC
# 
# Dimitar Penev - dpn at switchvoice dot com
# Copyright (C) 2013 Village Telco Ltd.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id$

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=si3217x
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/si3217x
	SUBMENU:=SPI Support
	TITLE:=SPI control for Silicon Labs Si3217x ProSLIC
	URL:=http://www.silabs.com/
	VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(PKG_RELEASE)
	FILES:= $(PKG_BUILD_DIR)/si3217x.$(LINUX_KMOD_SUFFIX)
	DEPENDS:=kmod-spi-gpio
endef

define KernelPackage/si3217x/description
 This package contains a SPI driver for Silicon Labs Si3217x ProSLIC.
endef

include $(INCLUDE_DIR)/kernel-defaults.mk

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) $(KERNEL_MAKEOPTS) SUBDIRS="$(PKG_BUILD_DIR)" modules
endef


define KernelPackage/si3217x/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)
	$(INSTALL_BIN) ./files/si3217x.init $(1)/etc/init.d/si3217x
	$(CP) $(PKG_BUILD_DIR)/si3217x.ko $(1)/lib/modules/$(LINUX_VERSION)/
	$(CP) $(PKG_BUILD_DIR)/proslic_api/proslic.ko $(1)/lib/modules/$(LINUX_VERSION)/
	$(CP) $(PKG_BUILD_DIR)/tdm/tdm.ko $(1)/lib/modules/$(LINUX_VERSION)/
endef

$(eval $(call KernelPackage,si3217x))
