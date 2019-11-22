#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

MODPATH=${0%/*}
BOOTSTAGE="late"

# Load functions
. $MODPATH/util_functions.sh

TMP_WAIT=0
until [ ! -f "$POSTCHKFILE" ] || [ "$TMP_WAIT" == 10 ]; do
	sleep 1
	TMP_WAIT=$(($TMP_WAIT + 1))
done

log_script_chk "Running service.sh module script."

# Resets the reboot and print update variables in propsconf_late
replace_fn REBOOTCHK 1 0 $LATEFILE
replace_fn PRINTCHK 1 0 $LATEFILE

# Retrieving default values from props file
log_handler "Saving device default values."
default_save
log_handler "Default values saved to $LATEFILE."

# Checks for the Universal SafetyNet Fix module and similar modules editing the device fingerprint
PRINTMODULE=false
for USNF in $USNFLIST; do
	if [ -d "$MODULESPATH/$USNF" ]; then
		if [ ! -f "$MODULESPATH/$USNF/disable" ]; then
			NAME=$(get_file_value $MODULESPATH/$USNF/module.prop "name=")
			log_handler "Magisk module '$NAME' installed (modifies the device fingerprint)."
			PRINTMODULE=true
		fi
	fi
done
if [ "$PRINTMODULE" == "true" ]; then
	replace_fn FINGERPRINTENB 1 0 $LATEFILE
	replace_fn PRINTMODULE 0 1 $LATEFILE
	log_handler "Fingerprint modification disabled."
else
	replace_fn FINGERPRINTENB 0 1 $LATEFILE
	replace_fn PRINTMODULE 1 0 $LATEFILE
fi

# Checks for configuration file
config_file

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

log_script_chk "service.sh module script finished."
