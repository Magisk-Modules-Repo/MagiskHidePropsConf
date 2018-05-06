#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODPATH/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODPATH=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

# MagiskHide Props Config
# By Didgeridoohan @ XDA Developers

# Variables
IMGPATH=$(dirname "$MODPATH")

# Load functions
. $MODPATH/util_functions.sh

# Clears out the script check file
rm -f $RUNFILE
touch $RUNFILE

# Start logging
log_start

# Check for boot scripts and restore backup if deleted, or if the resetfile is present
if [ ! -f "$LATEFILE" ] || [ -f "$RESETFILE" ]; then
	cp -af $MODPATH/propsconf_late $LATEFILE
	chmod 755 $LATEFILE
	if [ -f "$RESETFILE" ]; then
		RSTTXT="reset"
	else
		RSTTXT="restored"
	fi
	log_handler "Boot script $RSTTXT (${LATEFILE})."
fi

# Get the current values saved in propsconf_late
latefile_values
# Get default values
file_values

# Save default file values in propsconf_late
replace_fn FILEDEBUGGABLE "\"$LATEFILEDEBUGGABLE\"" "\"$FILEDEBUGGABLE\"" $LATEFILE
replace_fn FILESECURE "\"$LATEFILESECURE\"" "\"$FILESECURE\"" $LATEFILE
replace_fn FILETYPE "\"$LATEFILETYPE\"" "\"$FILETYPE\"" $LATEFILE
replace_fn FILETAGS "\"$LATEFILETAGS\"" "\"$FILETAGS\"" $LATEFILE
replace_fn FILESELINUX "\"$LATEFILESELINUX\"" "\"$FILESELINUX\"" $LATEFILE
replace_fn FILEFINGERPRINT "\"$LATEFILEFINGERPRINT\"" "\"$FILEFINGERPRINT\"" $LATEFILE
log_handler "Default values saved to $LATEFILE."

# Check if original file values are safe
orig_safe

# Checks for configuration file
config_file

# Edits build.prop
if [ "$(get_file_value $LATEFILE "FILESAFE=")" == 0 ]; then
	log_handler "Checking for conflicting build.prop modules."
	# Checks if any other modules are using a local copy of build.prop
	BUILDMODULE=false
	MODID=$(get_file_value $MODPATH/module.prop "id=")
	for D in $(ls $IMGPATH); do
		if [ $D != "$MODID" ]; then
			if [ -f "$IMGPATH/$D/system/build.prop" ]; then
				NAME=$(get_file_value $IMGPATH/$D/module.prop "name=")
				log_handler "Conflicting build.prop editing in module '$NAME'."
				BUILDMODULE=true
			fi
		fi
	done
	if [ "$BUILDMODULE" == "true" ]; then
		replace_fn BUILDPROPENB 1 0 $LATEFILE
	else
		replace_fn BUILDPROPENB 0 1 $LATEFILE
	fi

	# Copies the stock build.prop to the module. Only if set in propsconf_late.
	if [ "$(get_file_value $LATEFILE "BUILDPROPENB=")" == 1 ] && [ "$(get_file_value $LATEFILE "BUILDEDIT=")" == 1 ]; then
		cp -f /system/build.prop $MODPATH/system/build.prop
		log_handler "Stock build.prop copied from /system."

		# Edits the module copy of build.prop
		module_values
		log_handler "Editing build.prop."
		# ro.build props
		change_prop_file "build"		
		# Fingerprint
		if [ "$MODULEFINGERPRINT" ] && [ "$(get_file_value $LATEFILE "SETFINGERPRINT=")" == "true" ]; then
			PRINTSTMP="$(cat /system/build.prop | grep "$FILEFINGERPRINT")"
			for ITEM in $PRINTSTMP; do
				replace_fn $(get_eq_left "$ITEM") $(get_eq_right "$ITEM") $MODULEFINGERPRINT $MODPATH/system/build.prop && log_handler "$(get_eq_left "$ITEM")=$MODULEFINGERPRINT"
			done
		fi
	else
		rm -f $MODPATH/system/build.prop
		log_handler "Build.prop editing disabled."
	fi
else
	rm -f $MODPATH/system/build.prop
	log_handler "Prop file editing disabled. All values ok."
fi

log_script_chk "post-fs-data.sh finished.\n\n===================="
