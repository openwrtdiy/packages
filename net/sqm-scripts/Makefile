#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sqm-scripts
PKG_SOURCE_VERSION:=47998169a5b5daa5850edf8f29c66cd4b65fadc2
PKG_VERSION:=20230217
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/openwrtdiy/sqm-scripts.git
PKG_MIRROR_HASH:=2e80f4772626b01759cfabe5ae234f36cfc178124f66f665bfc2456dd0f48683

PKG_MAINTAINER:=Toke Høiland-Jørgensen <toke@toke.dk>
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk

define Package/sqm-scripts
  SECTION:=net
  CATEGORY:=Base system
  DEPENDS:=+tc +kmod-sched-cake +kmod-ifb +iptables +iptables-mod-ipopt +@BUSYBOX_CONFIG_FEATURE_STAT_FORMAT
  TITLE:=SQM Scripts (QoS)
  PKGARCH:=all
endef

define Package/sqm-scripts/description
 A set of scripts that does simple SQM configuration.
endef

define Package/sqm-scripts/conffiles
/etc/config/sqm
/etc/sqm/sqm.conf
endef

define Package/sqm-scripts/install
	make -C $(PKG_BUILD_DIR) DESTDIR=$(1) PLATFORM=openwrt install
endef

$(eval $(call BuildPackage,sqm-scripts))
