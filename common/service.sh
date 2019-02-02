#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODPATH/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODPATH=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

# Load functions
. $MODPATH/util_functions.sh

if [ "$OPTIONLATE" == 0 ]; then
	until [ ! -f "$POSTCHKFILE" ]; do
		sleep 1
	done
fi

log_script_chk "Running service.sh module script."

# Edits prop values if set for late_start service
echo -e "\n--------------------" >> $LOGFILE 2>&1
log_handler "Editing prop values in late_start service mode."
if [ "$OPTIONLATE" == 1 ]; then
	# ---Setting/Changing fingerprint---				
	print_edit
	# ---Setting device simulation props---
	dev_sim_edit
	# ---Setting custom props---
	custom_edit "CUSTOMPROPS"
fi
# Edit custom props set for late_start service
custom_edit "CUSTOMPROPSLATE"
# Edit MagiskHide sensitive values
if [ "$PROPEDIT" == 1 ]; then
	log_handler "Changing sensitive props."
	for ITEM in $PROPSLIST; do
		PROP=$(get_prop_type $ITEM)
		REPROP=$(echo "RE${PROP}" | tr '[:lower:]' '[:upper:]')
		MODULEPROP=$(echo "MODULE${PROP}" | tr '[:lower:]' '[:upper:]')
		if [ "$(eval "echo \$$REPROP")" == "true" ]; then
			log_handler "Changing/writing $ITEM."
			resetprop -v $ITEM >> $LOGFILE 2>&1
			resetprop -nv $ITEM $(eval "echo \$$MODULEPROP") >> $LOGFILE 2>&1
		fi
	done
fi
echo -e "\n--------------------" >> $LOGFILE 2>&1

# ---Edits default.prop---
if [ "$DEFAULTEDIT" == 1 ] && [ "$FILESAFE" == 0 ]; then
	log_handler "Editing default.prop."
	mount -wo remount rootfs /
	change_prop_file "default"
	mount -ro remount rootfs /
else
	log_handler "Default.prop editing disabled."
fi

# Get currently saved values
log_handler "Checking current values."
curr_values

log_script_chk "service.sh module script finished.\n\n=================="
