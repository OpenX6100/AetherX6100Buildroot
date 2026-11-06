################################################################################
#
# xara-rust: the Rust compiler for xara only
#
# Buildroot 2023.02 brings Rust 1.67; xara needs 1.85 or newer (edition
# 2024). This one goes to $(HOST_DIR)/opt/xara-rust, so Buildroot's own
# host-rustc (if anything else wants it) is left alone.
#
################################################################################

XARA_RUST_VERSION = 1.97.1
XARA_RUST_SITE = https://static.rust-lang.org/dist
XARA_RUST_LICENSE = Apache-2.0 or MIT
XARA_RUST_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

# The X6100's CPU (Cortex-A7, hard float)
XARA_RUST_TARGET = armv7-unknown-linux-gnueabihf
XARA_RUST_PREFIX = $(HOST_DIR)/opt/xara-rust

HOST_XARA_RUST_SOURCE = rust-$(XARA_RUST_VERSION)-$(RUSTC_HOST_NAME).tar.xz
HOST_XARA_RUST_EXTRA_DOWNLOADS = rust-std-$(XARA_RUST_VERSION)-$(XARA_RUST_TARGET).tar.xz

define HOST_XARA_RUST_EXTRACT_STD
	mkdir -p $(@D)/std
	$(call suitable-extractor,$(HOST_XARA_RUST_EXTRA_DOWNLOADS)) \
		$(HOST_XARA_RUST_DL_DIR)/$(HOST_XARA_RUST_EXTRA_DOWNLOADS) | \
		$(TAR) -C $(@D)/std $(TAR_OPTIONS) -
endef
HOST_XARA_RUST_POST_EXTRACT_HOOKS += HOST_XARA_RUST_EXTRACT_STD

define HOST_XARA_RUST_INSTALL_CMDS
	(cd $(@D); ./install.sh --prefix=$(XARA_RUST_PREFIX) --disable-ldconfig \
		--components=rustc,cargo,rust-std-$(RUSTC_HOST_NAME))
	(cd $(@D)/std/rust-std-$(XARA_RUST_VERSION)-$(XARA_RUST_TARGET); \
		./install.sh --prefix=$(XARA_RUST_PREFIX) --disable-ldconfig)
endef

$(eval $(host-generic-package))
