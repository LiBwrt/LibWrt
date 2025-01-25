include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=qualcommax
BOARDNAME:=Qualcomm Atheros 802.11ax WiSoC-s
FEATURES:=squashfs ramdisk fpu nand rtc emmc
KERNELNAME:=Image
CPU_TYPE:=cortex-a53
SUBTARGETS:=ipq807x ipq60xx

KERNEL_PATCHVER:=6.12

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES += \
	kmod-usb3 kmod-usb-dwc3 kmod-usb-dwc3-qcom \
	kmod-leds-gpio kmod-gpio-button-hotplug \
	autocore cpufreq wpad-openssl uboot-envtools \
	e2fsprogs f2fsck mkf2fs losetup \
	kmod-fs-ext4 kmod-fs-f2fs \
	kmod-qca-nss-dp kmod-ath11k-ahb \
	kmod-qca-nss-drv kmod-qca-nss-ecm \
	kmod-qca-nss-drv-bridge-mgr

$(eval $(call BuildTarget))
