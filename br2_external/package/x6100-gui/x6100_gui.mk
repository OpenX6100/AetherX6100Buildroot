################################################################################
#
#  X6100 GUI application
#
################################################################################

X6100_GUI_VERSION = v0.23.0-rc.3
X6100_GUI_SITE = https://github.com/OpenX6100/x6100_gui
X6100_GUI_SITE_METHOD = git
X6100_GUI_GIT_SUBMODULES = YES
# The GUI's own code is LGPL-2.1+. JS8's engine (third-party/js8core, from
# x6100_gui#301 on) is GPL-3.0, which makes the program GPL-3.0 as a whole.
# Its licence file joins X6100_GUI_LICENSE_FILES once X6100_GUI_VERSION is
# a release that has it.
X6100_GUI_LICENSE = LGPL-2.1+, GPL-3.0 (JS8 engine, third-party/js8core)
X6100_GUI_LICENSE_FILES = LICENSE

X6100_GUI_INSTALL_STAGING = YES

# boost (headers only) and fftw-single: JS8's engine (x6100_gui#301)
X6100_GUI_DEPENDENCIES = rhvoice libpng aether-x6100-control ft8lib boost fftw-single

$(eval $(cmake-package))
