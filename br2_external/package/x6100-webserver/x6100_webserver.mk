################################################################################
#
#  X6100 GUI
#
################################################################################

X6100_WEBSERVER_VERSION = e6eab54b616edd9ac1fb15a2af3262c689c9df2b
X6100_WEBSERVER_SITE = https://github.com/OpenX6100/x6100_webserver
X6100_WEBSERVER_SITE_METHOD = git
X6100_WEBSERVER_LICENSE = GPLv2
X6100_WEBSERVER_DEPENDENCIES = python-bottle-sqlite
X6100_WEBSERVER_SETUP_TYPE = flit

$(eval $(python-package))
