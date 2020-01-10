##########################################################################################
# Installation variables and functions for the Magisk module "MagiskHide Props Config"
# Copyright (c) 2018-2020 Didgeridoohan @ XDA Developers.
# Licence: MIT
##########################################################################################

# Load functions and variables
INSTFN=true
. $MODPATH/common/util_functions.sh

# Print module info
ui_print "$pounds"
ui_print " Installing $MODVERSION "
ui_print " By Didgeridoohan "
ui_print "$pounds"

# Create install directory
mkdir -pv $MHPCPATH

# Start module installation log
echo "***************************************************" > $LOGFILE 2>&1
echo "********* MagiskHide Props Config $MODVERSION ********" >> $LOGFILE 2>&1
echo "***************** By Didgeridoohan ***************" >> $LOGFILE 2>&1
echo "***************************************************" >> $LOGFILE 2>&1
log_handler "Starting module installation script"

# Module script installation
script_install

set_perm $MODPATH/system/$BIN/props 0 0 0755