################################################################################
#
# xara-rust: the Rust compiler for xara only
#
# Buildroot 2023.02 brings Rust 1.67; xara needs 1.85 or newer (edition
# 2024). This one goes to $(HOST_DIR)/opt/xara-rust, so Buildroot's own
# host-rustc (if anything else wants it) is left alone. Only the parts
# xara needs are downloaded (rustc, cargo, the host's and the target's
# std: about 120 MB, not the 200 MB of the whole toolchain).
#
################################################################################

XARA_RUST_VERSION = 1.97.1
XARA_RUST_SITE = https://static.rust-lang.org/dist
XARA_RUST_LICENSE = Apache-2.0 or MIT
XARA_RUST_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

# The target as Buildroot names it for its own Rust (armv7-unknown-linux-
# gnueabihf on the X6100)
XARA_RUST_TARGET = $(RUSTC_TARGET_NAME)
XARA_RUST_PREFIX = $(HOST_DIR)/opt/xara-rust

HOST_XARA_RUST_SOURCE = rustc-$(XARA_RUST_VERSION)-$(RUSTC_HOST_NAME).tar.xz
HOST_XARA_RUST_EXTRA_DOWNLOADS = \
	cargo-$(XARA_RUST_VERSION)-$(RUSTC_HOST_NAME).tar.xz \
	rust-std-$(XARA_RUST_VERSION)-$(RUSTC_HOST_NAME).tar.xz \
	rust-std-$(XARA_RUST_VERSION)-$(XARA_RUST_TARGET).tar.xz

# Each extra one in its own directory, with its own install.sh
define HOST_XARA_RUST_EXTRACT_EXTRA
	mkdir -p $(@D)/extra
	$(foreach f,$(HOST_XARA_RUST_EXTRA_DOWNLOADS), \
		$(call suitable-extractor,$(f)) $(HOST_XARA_RUST_DL_DIR)/$(f) | \
			$(TAR) -C $(@D)/extra $(TAR_OPTIONS) - $(sep))
endef
HOST_XARA_RUST_POST_EXTRACT_HOOKS += HOST_XARA_RUST_EXTRACT_EXTRA

define HOST_XARA_RUST_INSTALL_CMDS
	(cd $(@D); ./install.sh --prefix=$(XARA_RUST_PREFIX) --disable-ldconfig)
	$(foreach f,$(HOST_XARA_RUST_EXTRA_DOWNLOADS), \
		(cd $(@D)/extra/$(f:.tar.xz=); \
			./install.sh --prefix=$(XARA_RUST_PREFIX) --disable-ldconfig) $(sep))
endef

$(eval $(host-generic-package))
