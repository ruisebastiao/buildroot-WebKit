################################################################################
#
# rpi-userland
#
################################################################################

RPI_USERLAND_VERSION = 40e377862410371a9962db79b81fd4f0f266430a
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3c
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPT = -DVMCS_INSTALL_PREFIX=/usr -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="$(TARGET_CFLAGS)"

ifeq ($(BR2_PACKAGE_WAYLAND),y)
RPI_USERLAND_DEPENDENCIES += wayland
RPI_USERLAND_CONF_OPT += -DBUILD_WAYLAND=1
endif

define RPI_USERLAND_POST_TARGET_CLEANUP
	rm -f $(TARGET_DIR)/etc/init.d/vcfiled
	rm -f $(TARGET_DIR)/usr/share/install/vcfiled
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/install
	rm -Rf $(TARGET_DIR)/usr/src
endef

RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP

define RPI_USERLAND_POST_TARGET_CLEANUP_TOOLS
	rm -f $(TARGET_DIR)/usr/bin/tvservice
	rm -f $(TARGET_DIR)/usr/bin/vc{smem,gencmd,hiq_test,mailbox}
	rm -f $(TARGET_DIR)/usr/sbin/vcfiled
	rm -f $(TARGET_DIR)/usr/bin/raspi*
	rm -f $(TARGET_DIR)/usr/bin/containers_*
	rm -f $(TARGET_DIR)/usr/bin/mmal_vc*
	rm -rf $(TARGET_DIR)/usr/lib/plugins
endef

ifneq ($(BR2_PACKAGE_RPI_USERLAND_INSTALL_TOOLS),y)
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP_TOOLS
endif

$(eval $(cmake-package))
