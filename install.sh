##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=true
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
	set_perm_recursive $MODPATH 0 0 0755 0644
	set_perm $MODPATH/system/$BIN/props 0 0 0755
}

##########################################################################################
# Installation variables and functions for the Magisk module "MagiskHide Props Config"
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers.
# Licence: MIT
##########################################################################################

print_modname() {
	ui_print "*******************************"
	ui_print "MagiskHide Props Config $(grep "version=" $TMPDIR/module.prop | sed 's|.*=||' | sed 's|-.*||')"
	ui_print "    By Didgeridoohan @XDA"
	ui_print "*******************************"

	# Load functions and variables
	INSTFN=true
	. $TMPDIR/util_functions.sh
	# Start module installation log
	log_start
	# Check Magisk version
	if [ $MAGISK_VER_CODE -lt 19000 ]; then
		ui_print ""
		log_print "! Detected Magisk build $MAGISK_VER_CODE!"
		log_print "! Magisk version not supported!"
		abort "! Please install Magisk v19+!"
	fi
}

on_install() {
	ui_print "- Extracting module files"
	unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

	# Module script installation
	script_install
}
