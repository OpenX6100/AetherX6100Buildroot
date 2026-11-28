include $(sort $(wildcard $(BR2_EXTERNAL_X6100_PATH)/package/*/*.mk))

define UBOOT_COPY_OLD_LICENSE_FILE
	if [ -f $(@D)/COPYING ] && [ ! -f $(@D)/Licenses/gpl-2.0.txt ]; then \
		$(INSTALL) -m 0644 -D $(@D)/COPYING $(@D)/Licenses/gpl-2.0.txt; \
	fi
endef
UBOOT_POST_EXTRACT_HOOKS += UBOOT_COPY_OLD_LICENSE_FILE
