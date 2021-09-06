##########################################################################################
# Installation variables and functions for the Magisk module "MagiskHide Props Config"
# Copyright (c) 2018-2021 Didgeridoohan @ XDA Developers.
# Licence: MIT
##########################################################################################

# Load functions and variables
INSTFN=true
. $MODPATH/common/util_functions.sh

# Print module info
ui_print ""
ui_print "************************"
ui_print " Installing $MODVERSION "
ui_print "************************"
ui_print ""

# Remove module directory if it exists on a fresh install
if [ ! -d "$MODULESPATH/MagiskHidePropsConf"] && [ -d "$MHPCPATH" ]; then
  rm -rf $MHPCPATH
fi

# Create module directory
mkdir -pv $MHPCPATH

# Start module installation log
echo "***************************************************" > $LOGFILE 2>&1
echo "********* MagiskHide Props Config $MODVERSION ********" >> $LOGFILE 2>&1
echo "***************** By Didgeridoohan ***************" >> $LOGFILE 2>&1
echo "***************************************************" >> $LOGFILE 2>&1
log_print "- Starting module installation script"

# Module script installation
script_install

# Permission
log_print "- Setting permissions"
set_perm $MODPATH/system/$BIN/props 0 0 0755

log_print "- Module installation complete."
