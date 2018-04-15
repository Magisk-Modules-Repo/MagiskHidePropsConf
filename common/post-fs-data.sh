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

# Saves the previous log (if available) and creates a new one
if [ -f "$LOGFILE" ]; then
	mv -f $LOGFILE $LASTLOGFILE
fi
touch $LOGFILE
echo "***************************************************" >> $LOGFILE
echo "******** MagiskHide Props Config $MODVERSION ********" >> $LOGFILE
echo "**************** By Didgeridoohan ***************" >> $LOGFILE
echo "***************************************************" >> $LOGFILE
log_handler "Log start."

# Check for boot scripts and restore backup if deleted, or if the resetfile is present
if [ ! -f "$LATEFILE" ] || [ -f "$RESETFILE" ]; then
	cp -af $MODPATH/propsconf_late $LATEFILE
	chmod 755 $LATEFILE
	log_handler "Boot script restored/reset (${LATEFILE})."
fi

# Update placeholders
# Image path
placeholder_update $LATEFILE IMGPATH IMG_PLACEHOLDER $IMGPATH
placeholder_update $MODPATH/system/$BIN/props IMGPATH IMG_PLACEHOLDER $IMGPATH

# Check the reboot variable
if [ "$(get_file_value $LATEFILE "REBOOTCHK=")" == 1 ]; then
	sed -i 's/REBOOTCHK=1/REBOOTCHK=0/' $LATEFILE
fi

# Get the current values saved in propsconf_late
orig_values
latefile_values

# Get default file values
file_values

# Save default file values in propsconf_late
sed -i "s/FILEDEBUGGABLE=\"$LATEFILEDEBUGGABLE\"/FILEDEBUGGABLE=\"$FILEDEBUGGABLE\"/" $LATEFILE
sed -i "s/FILESECURE=\"$LATEFILESECURE\"/FILESECURE=\"$FILESECURE\"/" $LATEFILE
sed -i "s/FILETYPE=\"$LATEFILETYPE\"/FILETYPE=\"$FILETYPE\"/" $LATEFILE
sed -i "s/FILETAGS=\"$LATEFILETAGS\"/FILETAGS=\"$FILETAGS\"/" $LATEFILE
sed -i "s/FILESELINUX=\"$LATEFILESELINUX\"/FILESELINUX=\"$FILESELINUX\"/" $LATEFILE
log_handler "Default file values saved to $LATEFILE."

# Get the default prop values
curr_values

# Save default prop values in propsconf_late
sed -i "s/ORIGDEBUGGABLE=\"$ORIGDEBUGGABLE\"/ORIGDEBUGGABLE=\"$CURRDEBUGGABLE\"/" $LATEFILE
sed -i "s/ORIGSECURE=\"$ORIGSECURE\"/ORIGSECURE=\"$CURRSECURE\"/" $LATEFILE
sed -i "s/ORIGTYPE=\"$ORIGTYPE\"/ORIGTYPE=\"$CURRTYPE\"/" $LATEFILE
sed -i "s/ORIGTAGS=\"$ORIGTAGS\"/ORIGTAGS=\"$CURRTAGS\"/" $LATEFILE
sed -i "s/ORIGSELINUX=\"$ORIGSELINUX\"/ORIGSELINUX=\"$CURRSELINUX\"/" $LATEFILE
sed -i "s@ORIGFINGERPRINT=\"$ORIGFINGERPRINT\"@ORIGFINGERPRINT=\"$CURRFINGERPRINT\"@" $LATEFILE
log_handler "Current prop values saved to $LATEFILE."

# Checks for the Universal SafetyNet Fix module and similar modules editing the device fingerprint
PRINTMODULE=false
for USNF in $USNFLIST; do
	if [ -d "$IMGPATH/$USNF" ]; then
		NAME=$(get_file_value $IMGPATH/$USNF/module.prop "name=")			
		log_handler "'$NAME' installed (modifies the device fingerprint)."
		PRINTMODULE=true
	fi
done
if [ "$PRINTMODULE" == "true" ]; then
	sed -i 's/FINGERPRINTENB=1/FINGERPRINTENB=0/' $LATEFILE
	log_handler "Fingerprint modification disabled."	
else
	sed -i 's/FINGERPRINTENB=0/FINGERPRINTENB=1/' $LATEFILE
	if [ "$(get_file_value $LATEFILE "FINGERPRINTENB=")" == 1 ]; then
		log_handler "Fingerprint modification enabled."
	else
		log_handler "Fingerprint modification disabled."
	fi
fi

# Check if original file values are safe
orig_safe

# Checks for configuration file
config_file

# Edits build.prop
if [ "$(get_file_value $LATEFILE "FILESAFE=")" == 0 ]; then
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
		sed -i 's/BUILDPROPENB=1/BUILDPROPENB=0/' $LATEFILE
	else
		sed -i 's/BUILDPROPENB=0/BUILDPROPENB=1/' $LATEFILE
	fi

	# Copies the stock build.prop to the module. Only if set in propsconf_late.
	if [ "$(get_file_value $LATEFILE "BUILDPROPENB=")" == 1 ] && [ "$(get_file_value $LATEFILE "BUILDEDIT=")" == 1 ]; then
		log_handler "Build.prop editing enabled."
		cp /system/build.prop $MODPATH/system/build.prop
		log_handler "Stock build.prop copied from /system."

		# Edits the module copy of build.prop
		MODULETYPE=$(get_file_value $LATEFILE "MODULETYPE=")
		MODULETAGS=$(get_file_value $LATEFILE "MODULETAGS=")
		MODULESELINUX=$(get_file_value $LATEFILE "MODULESELINUX=")
		log_handler "Editing build.prop."
		if [ "$MODULETYPE" ]; then
			SEDTYPE=$MODULETYPE
		else
			SEDTYPE=user
		fi
		if [ "$(get_file_value $LATEFILE "SETTYPE=")" == "true" ]; then
			sed -i "s/ro.build.type=$FILETYPE/ro.build.type=$SEDTYPE/" $MODPATH/system/build.prop && log_handler "ro.build.type"
		fi
		if [ "$MODULETAGS" ]; then
			SEDTAGS=$MODULETAGS
		else
			SEDTAGS=release-keys
		fi
		if [ "$(get_file_value $LATEFILE "SETTAGS=")" == "true" ]; then
			sed -i "s/ro.build.tags=$FILETAGS/ro.build.tags=$SEDTAGS/" $MODPATH/system/build.prop && log_handler "ro.build.tags"
		fi
		if [ "$MODULESELINUX" ]; then
			SEDSELINUX=$MODULESELINUX
		else
			SEDSELINUX=0
		fi
		if [ "$(get_file_value $LATEFILE "SETSELINUX=")" == "true" ]; then
			sed -i "s/ro.build.selinux=$FILESELINUX/ro.build.selinux=$SEDSELINUX/" $MODPATH/system/build.prop && log_handler "ro.build.selinux"
		fi
	else
		rm -f $MODPATH/system/build.prop
		log_handler "Build.prop editing disabled."
	fi
else
	rm -f $MODPATH/system/build.prop
	log_handler "Prop file editing disabled. All values ok."
fi

log_handler "post-fs-data.sh finished.\n\n===================="
