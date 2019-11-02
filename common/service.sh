#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

MODPATH=${0%/*}
BOOTSTAGE="late"

# Load functions
. $MODPATH/util_functions.sh

if [ "$OPTIONBOOT" == 1 ]; then
	until [ ! -f "$POSTCHKFILE" ]; do
		sleep 1
	done
fi

log_script_chk "Running service.sh module script."

# Retrieving default values from props file
log_handler "Saving device default values."
default_save
log_handler "Default values saved to $LATEFILE."

# Edits prop values if set for late_start service
echo -e "\n----------------------------------------" >> $LOGFILE 2>&1
log_handler "Editing prop values in late_start service mode."
if [ "$OPTIONBOOT" == 2 ]; then
	# ---Setting/Changing fingerprint---				
	if [ "$PRINTSTAGE" == 0 ]; then
		print_edit
	fi
	# ---Setting/Changing security patch date---
	if [ "$PATCHSTAGE" == 0 ]; then
		patch_edit
	fi
	# ---Setting device simulation props---
	if [ "$SIMSTAGE" == 0 ]; then
		dev_sim_edit
	fi
	# ---Setting custom props---
	custom_edit "CUSTOMPROPS"
fi
# Edit fingerprint if set for late_start service
if [ "$OPTIONBOOT" != 2 ] && [ "$PRINTSTAGE" == 2 ]; then
	print_edit
fi
# Edit security patch date if set for late_start service
if [ "$OPTIONBOOT" != 2 ] && [ "$PATCHSTAGE" == 2 ]; then
	patch_edit
fi
# Edit simulation props if set for late_start service
if [ "$OPTIONBOOT" != 2 ] && [ "$SIMSTAGE" == 2 ]; then
	dev_sim_edit
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
			resetprop -nv $ITEM $(eval "echo \$$MODULEPROP") >> $LOGFILE 2>&1
		fi
	done
fi
echo -e "\n----------------------------------------" >> $LOGFILE 2>&1

# Get currently saved values
log_handler "Checking current values."
curr_values
# Check system.prop content
system_prop_cont

log_script_chk "service.sh module script finished.\n\n=================="
