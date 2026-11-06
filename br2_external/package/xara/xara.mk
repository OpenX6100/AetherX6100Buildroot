################################################################################
#
# xara: a VARA HF compatible modem (github.com/x0rro/xara, MIT), run by
# the GUI's XARA app. VARA is EA5HVK's modem; xara is x0rro's own,
# independent program. VARA's free speed levels unless
# BR2_PACKAGE_XARA_REGISTERED (the app's Settings > Full speed).
#
# For now from randal007/xara: x0rro's 0.1.1 plus the X6100 work that
# made it run on the radio (offered to x0rro, who merges himself):
# the answer gate (the app decides when calls are answered: plain xara
# answers every call from start), the busy detector bypass, PSK frames
# built and searched on several threads (the Cortex-A7 sent them late),
# catching up when receiving falls behind, separate send and receive
# buffers, the send buffer counted as TX latency, the poll/NACK loop
# fix, and --local-only (the host and KISS ports take local addresses
# only: the VARA protocol has no password). 919f5dd passed the radio
# tests (2026-11-02); 2a33e96 adds only --local-only. Moves to
# x0rro's own release (libxara, 0.1.4) once it has these.
#
################################################################################

XARA_VERSION = 2a33e96f824fb370a4e90491831a085237ede7cb
XARA_SITE = $(call github,randal007,xara,$(XARA_VERSION))
XARA_LICENSE = MIT
XARA_LICENSE_FILES = LICENSE
XARA_DEPENDENCIES = host-xara-rust pulseaudio

# Its crates are put in the download (cargo vendor, as Buildroot's cargo
# packages do), with our Rust, so the build itself needs no network.
XARA_DOWNLOAD_DEPENDENCIES = host-xara-rust
XARA_DOWNLOAD_POST_PROCESS = cargo
XARA_DL_ENV = \
	CARGO_HOME=$(BR_CARGO_HOME) \
	PATH=$(XARA_RUST_PREFIX)/bin:$(BR_PATH)

XARA_CARGO_ENV = \
	CARGO_HOME=$(BR_CARGO_HOME) \
	PATH=$(XARA_RUST_PREFIX)/bin:$(BR_PATH) \
	CARGO_TARGET_$(call UPPERCASE,$(XARA_RUST_TARGET))_LINKER=$(TARGET_CC) \
	RUSTFLAGS="-C target-cpu=cortex-a7 -C link-arg=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib/pulseaudio"

# cargo vendor writes .cargo/config; newer cargo wants config.toml
define XARA_CARGO_CONFIG
	if [ -f $(@D)/.cargo/config ] && [ ! -f $(@D)/.cargo/config.toml ]; then \
		mv $(@D)/.cargo/config $(@D)/.cargo/config.toml; \
	fi
endef
XARA_POST_EXTRACT_HOOKS += XARA_CARGO_CONFIG

XARA_FEATURES = pulse
ifeq ($(BR2_PACKAGE_XARA_REGISTERED),y)
XARA_FEATURES += registered
endif

define XARA_BUILD_CMDS
	cd $(@D) && $(XARA_CARGO_ENV) cargo build --offline --locked --release \
		--target $(XARA_RUST_TARGET) --no-default-features --features $(subst $(space),$(comma),$(strip $(XARA_FEATURES))) \
		-p xara --bin xara --bin xara-monitor
endef

define XARA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/target/$(XARA_RUST_TARGET)/release/xara $(TARGET_DIR)/usr/bin/xara
	$(INSTALL) -D -m 0755 $(@D)/target/$(XARA_RUST_TARGET)/release/xara-monitor $(TARGET_DIR)/usr/bin/xara-monitor
endef

$(eval $(generic-package))
