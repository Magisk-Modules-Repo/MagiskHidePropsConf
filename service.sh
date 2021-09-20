#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2021 Didgeridoohan @ XDA Developers
# Licence: MIT

MODPATH=${0%/*}
BOOTSTAGE="late"

# Variables
MODULESPATH=${MODPATH%/*}
ADBPATH=${MODULESPATH%/*}
MHPCPATH=$ADBPATH/mhpc

TMP_WAIT=0
while [ ! -f "$MHPCPATH/propsconf_postchk" ] && [ "$TMP_WAIT" -lt 10 ]; do
	sleep 1
	TMP_WAIT=$(($TMP_WAIT + 1))
done

# Load functions
. $MODPATH/common/util_functions.sh

log_script_chk "Running service.sh module script."

# Check for reboot flag
if [ -f "$MHPCPATH/reboot" ]; then
	rm -f $MHPCPATH/reboot >> $LOGFILE 2>&1
	force_reboot
fi

# Resets the reboot and print update variables in propsconf_late
replace_fn REBOOTCHK 1 0 $LATEFILE
replace_fn PRINTCHK 1 0 $LATEFILE

# Retrieving default values from props file
log_handler "Saving device default values."
default_save
log_handler "Default values saved to $LATEFILE."

# Checks for the Universal SafetyNet Fix module and similar modules editing the device fingerprint
TMPUSNF=false
for USNF in $USNFLIST; do
	if [ -d "$MODULESPATH/$USNF" ]; then
		if [ ! -f "$MODULESPATH/$USNF/disable" ]; then
			NAME=$(get_file_value $MODULESPATH/$USNF/module.prop "name=")
			log_handler "Magisk module '$NAME' installed (modifies the device fingerprint)."
			TMPUSNF=true
		fi
	fi
done
if [ "$TMPUSNF" == "true" ]; then
	replace_fn FINGERPRINTENB 1 0 $LATEFILE
	replace_fn PRINTMODULE 0 1 $LATEFILE
	log_handler "Fingerprint modification disabled."
	# Reset current fingerprint if set
	if [ "$MODULEFINGERPRINT" ]; then
		log_handler "Resetting current fingerprint."
		reset_print
		force_reboot
	fi
else
	replace_fn FINGERPRINTENB 0 1 $LATEFILE
	replace_fn PRINTMODULE 1 0 $LATEFILE
fi

# Checks for configuration file
config_file

# Edits prop values if set for late_start service
PROPLATE=false
echo -e "\n----------------------------------------" >> $LOGFILE 2>&1
log_handler "Editing prop values in late_start service mode."
if [ "$OPTIONBOOT" == 2 ]; then
	# ---Setting/Changing fingerprint---
	if [ "$PRINTSTAGE" == 0 ]; then
		print_edit "none"
	fi
	# ---Setting/Changing security patch date---
	if [ "$PATCHSTAGE" == 0 ]; then
		patch_edit "none"
	fi
	# Forced basic attestation
	if [ "$BASICATTEST" == 1 ]; then
		forced_basic "none"
	fi
	# ---Setting device simulation props---
	if [ "$SIMSTAGE" == 0 ]; then
		dev_sim_edit "none"
	fi
	# ---Setting custom props---
	custom_edit "CUSTOMPROPS"
else
	# Edit fingerprint if set for late_start service
	if [ "$PRINTSTAGE" == 2 ]; then
		print_edit "none"
	fi
	# Edit security patch date if set for late_start service
	if [ "$PATCHSTAGE" == 2 ]; then
		patch_edit "none"
	fi
	# Edit simulation props if set for late_start service
	if [ "$SIMSTAGE" == 2 ]; then
		dev_sim_edit "none"
	fi
fi

# Edit MagiskHide sensitive props
if [ "$PROPEDIT" == 1 ]; then
	# Edit all sensitive props, if set for late_start service
	if [ "$PROPBOOT" == 2 ]; then
		sensitive_props "$PROPSLIST"
	fi
	if [ "$PROPBOOT" == 0 ] || [ "$PROPBOOT" == 2 ]; then
		sensitive_props "$TRIGGERPROPS"
	fi

	# Edit late senstive props
	{
	until [ $(getprop sys.boot_completed) == 1 ]; do
		sleep 1
	done
	sensitive_props "$LATEPROPS" "late"
	}&
fi

# Edit custom props set for late_start service
custom_edit "CUSTOMPROPSLATE"
custom_edit "CUSTOMPROPSDELAY"

# SELinux
# Remove ro.build.selinux if present
if [ "$(grep "ro.build.selinux" $MHPCPATH/defaultprops)" ]; then
	log_handler "Removing ro.build.selinux."
	resetprop -v --delete ro.build.selinux >> $LOGFILE 2>&1
fi
# Check for permissive SELinux
if [ "$(getenforce)" == "Permissive" ] || [ "$(getenforce)" == "0" ]; then
	log_handler "Dealing with permissive SELinux."
	chmod 640 /sys/fs/selinux/enforce >> $LOGFILE 2>&1
	chmod 440 /sys/fs/selinux/policy >> $LOGFILE 2>&1
fi

# Do a soft restart if the option is active and a prop has been set in service.sh
if [ "$PROPLATE" == "true" ]; then
	log_handler "Soft rebooting."
	stop
	start
fi

echo -e "\n----------------------------------------" >> $LOGFILE 2>&1

# Get currently saved values
log_handler "Checking current values."
curr_values
# Check system.prop content
system_prop_cont

log_script_chk "service.sh module script finished."
