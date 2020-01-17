##########################################################################################
# Installation variables and functions for the Magisk module "MagiskHide Props Config"
# Copyright (c) 2018-2020 Didgeridoohan @ XDA Developers.
# Licence: MIT
##########################################################################################

# Load functions and variables
INSTFN=true
. $MODPATH/common/util_functions.sh

# Print module info
ui_print ""
ui_print "************************"
ui_print " Installing $MODVERSION "
ui_print " By Didgeridoohan @ XDA "
ui_print "************************"
ui_print ""

# Create module directory
mkdir -pv $MHPCPATH

# Start module installation log
echo "***************************************************" > $LOGFILE 2>&1
echo "********* MagiskHide Props Config $MODVERSION ********" >> $LOGFILE 2>&1
echo "***************** By Didgeridoohan ***************" >> $LOGFILE 2>&1
echo "***************************************************" >> $LOGFILE 2>&1
log_handler "Starting module installation script"

# Module script installation
script_install

# Permission
set_perm $MODPATH/system/$BIN/props 0 0 0755

# Remove unused files
rm -f $MODPATH/LICENSE