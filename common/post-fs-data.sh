#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

MODPATH=${0%/*}
BOOTSTAGE="post"

# Load functions
. $MODPATH/util_functions.sh

# Start logging
log_start
bb_check

# Clears out the script check file
rm -f $RUNFILE
touch $RUNFILE

# Clears out the script control file
touch $POSTCHKFILE

# Checks the reboot and print update variables in propsconf_late
if [ "$REBOOTCHK" == 1 ]; then
	replace_fn REBOOTCHK 1 0 $LATEFILE
fi
if [ "$PRINTCHK" == 1 ]; then
	replace_fn PRINTCHK 1 0 $LATEFILE
fi

# Check for the boot script and restore backup if deleted, or if the resetfile is present
RESETFILE=""
for ITEM in $RESETFILELST; do
	if [ -f "$ITEM" ]; then
		RESETFILE="$ITEM"
		break
	fi
done
if [ ! -f "$LATEFILE" ] || [ -f "$RESETFILE" ]; then
	if [ -f "$RESETFILE" ]; then
		RSTTXT="Resetting"
		for ITEM in $RESETFILELST; do
			rm -f $ITEM
		done
	else
		RSTTXT="Restoring"
		log_handler "The module settings file could not be found."
	fi	
	log_handler "$RSTTXT module settings file (${LATEFILE})."
	cp -af $MODPATH/propsconf_late $LATEFILE >> $LOGFILE 2>&1
	rm -f $MODPATH/system.prop >> $LOGFILE 2>&1
fi

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

# Save default values
log_handler "Saving device prop values."
resetprop > $MHPCPATH/defaultprops
log_handler "Prop values saved to $MHPCPATH/defaultprops."

# Loading module settings
. $LATEFILE

# Checks for configuration file
config_file

# Edits prop values if set for post-fs-data
echo -e "\n----------------------------------------" >> $LOGFILE 2>&1
log_handler "Editing prop values in post-fs-data mode."
if [ "$OPTIONBOOT" == 1 ]; then
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
# Edit fingerprint if set for post-fs-data
if [ "$OPTIONBOOT" != 1 ] && [ "$PRINTSTAGE" == 1 ]; then
	print_edit
fi
# Edit security patch date if set for post-fs-data
if [ "$OPTIONBOOT" != 1 ] && [ "$PATCHSTAGE" == 1 ]; then
	patch_edit
fi
# Edit simulation props if set for post-fs-data
if [ "$OPTIONBOOT" != 1 ] && [ "$SIMSTAGE" == 1 ]; then
	dev_sim_edit
fi
# Edit custom props set for post-fs-data
custom_edit "CUSTOMPROPSPOST"
# Deleting props
prop_del
echo -e "\n----------------------------------------" >> $LOGFILE 2>&1

log_script_chk "post-fs-data.sh module script finished.\n\n===================="

# Deletes the post-fs-data control file
rm -f $POSTCHKFILE