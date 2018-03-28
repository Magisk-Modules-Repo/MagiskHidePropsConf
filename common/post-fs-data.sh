#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

# MagiskHide Props Config
# By Didgeridoohan @ XDA-Developers

# Variables
IMGPATH=$(dirname "$MODDIR")
LASTLOGFILE=/cache/propsconf_last.log
BIN=BIN_PLACEHOLDER
USNFLIST=USNF_PLACEHOLDER

# Load functions
. $MODDIR/util_functions.sh

MODVERSION=$(echo $(get_file_value $MODDIR/module.prop "version=") | sed 's/-.*//')

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

# Check for boot scripts, restore backup if deleted
if [ ! -f "$LATEFILE" ]; then
	cp -af $MODDIR/propsconf_late $LATEFILE
	chmod 755 $LATEFILE
	log_handler "Boot script restored."
fi

# Update placeholders in util_functions.sh
# Image path
placeholder_update $LATEFILE IMGPATH IMG_PLACEHOLDER $IMGPATH
placeholder_update $MODDIR/system/$BIN/props IMGPATH IMG_PLACEHOLDER $IMGPATH
# Module version
placeholder_update $MODDIR/system/$BIN/props MODVERSION VER_PLACEHOLDER $MODVERSION

# Check the reboot variable
if [ "$(get_file_value $LATEFILE "REBOOTCHK=")" == 1 ]; then
	sed -i 's/REBOOTCHK=1/REBOOTCHK=0/' $LATEFILE
fi

# Get the current values saved in propsconf_late
LATEDEBUGGABLE=$(get_file_value $LATEFILE "ORIGDEBUGGABLE=")
LATEFILEDEBUGGABLE=$(get_file_value $LATEFILE "FILEDEBUGGABLE=")
LATESECURE=$(get_file_value $LATEFILE "ORIGSECURE=")
LATEFILESECURE=$(get_file_value $LATEFILE "FILESECURE=")
LATETYPE=$(get_file_value $LATEFILE "ORIGTYPE=")
LATEFILETYPE=$(get_file_value $LATEFILE "FILETYPE=")
LATETAGS=$(get_file_value $LATEFILE "ORIGTAGS=")
LATEFILETAGS=$(get_file_value $LATEFILE "FILETAGS=")
LATESELINUX=$(get_file_value $LATEFILE "ORIGSELINUX=")
LATEFILESELINUX=$(get_file_value $LATEFILE "FILESELINUX=")
LATEFINGERPRINT=$(get_file_value $LATEFILE "ORIGFINGERPRINT=")

# Get default file values
FILEDEBUGGABLE=$(get_file_value /default.prop ro.debuggable)
FILESECURE=$(get_file_value /default.prop ro.secure)
FILETYPE=$(get_file_value /system/build.prop ro.build.type)
FILETAGS=$(get_file_value /system/build.prop ro.build.tags)
FILESELINUX=$(get_file_value /system/build.prop ro.build.selinux)

# Save default file values in propsconf_late
sed -i "s/FILEDEBUGGABLE=$LATEFILEDEBUGGABLE/FILEDEBUGGABLE=$FILEDEBUGGABLE/" $LATEFILE
sed -i "s/FILESECURE=$LATEFILESECURE/FILESECURE=$FILESECURE/" $LATEFILE
sed -i "s/FILETYPE=$LATEFILETYPE/FILETYPE=$FILETYPE/" $LATEFILE
sed -i "s/FILETAGS=$LATEFILETAGS/FILETAGS=$FILETAGS/" $LATEFILE
sed -i "s/FILESELINUX=$LATEFILESELINUX/FILESELINUX=$FILESELINUX/" $LATEFILE
log_handler "Default file values saved to $LATEFILE."

# Get the default prop values
ORIGDEBUGGABLE=$(resetprop ro.debuggable)
ORIGSECURE=$(resetprop ro.secure)
ORIGTYPE=$(resetprop ro.build.type)
ORIGTAGS=$(resetprop ro.build.tags)
ORIGSELINUX=$(resetprop ro.build.selinux)
ORIGFINGERPRINT=$(resetprop ro.build.fingerprint)
if [ ! "$ORIGFINGERPRINT" ]; then
	ORIGFINGERPRINT=$(resetprop ro.bootimage.build.fingerprint)
fi

# Save defatul prop values in propsconf_late
sed -i "s/ORIGDEBUGGABLE=$LATEDEBUGGABLE/ORIGDEBUGGABLE=$ORIGDEBUGGABLE/" $LATEFILE
sed -i "s/ORIGSECURE=$LATESECURE/ORIGSECURE=$ORIGSECURE/" $LATEFILE
sed -i "s/ORIGTYPE=$LATETYPE/ORIGTYPE=$ORIGTYPE/" $LATEFILE
sed -i "s/ORIGTAGS=$LATETAGS/ORIGTAGS=$ORIGTAGS/" $LATEFILE
sed -i "s/ORIGSELINUX=$LATESELINUX/ORIGSELINUX=$ORIGSELINUX/" $LATEFILE
sed -i "s@ORIGFINGERPRINT=$LATEFINGERPRINT@ORIGFINGERPRINT=$ORIGFINGERPRINT@" $LATEFILE
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
sed -i 's/FILESAFE=0/FILESAFE=1/' $LATEFILE
for V in $PROPSLIST; do
	PROP=$(get_prop_type $V)
	FILEPROP=$(echo "FILE$PROP" | tr '[:lower:]' '[:upper:]')
	FILEVALUE=$(eval "echo \$$FILEPROP")
	log_handler "Checking $FILEPROP=$FILEVALUE"
	safe_props $V $FILEVALUE
	if [ "$SAFE" == 0 ]; then
		log_handler "Prop $V set to triggering value in prop file."
		sed -i 's/FILESAFE=1/FILESAFE=0/' $LATEFILE
	else
		log_handler "Prop $V set to \"safe\" value in prop file."
	fi
done

if [ "$(get_file_value $LATEFILE "FILESAFE=")" == 0 ]; then
	# Checks if any other modules are using a local copy of build.prop
	BUILDMODULE=false
	MODID=$(get_file_value $MODDIR/module.prop "id=")
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
		cp /system/build.prop $MODDIR/system/build.prop
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
			sed -i "s/ro.build.type=$FILETYPE/ro.build.type=$SEDTYPE/" $MODDIR/system/build.prop && log_handler "ro.build.type"
		fi
		if [ "$MODULETAGS" ]; then
			SEDTAGS=$MODULETAGS
		else
			SEDTAGS=release-keys
		fi
		if [ "$(get_file_value $LATEFILE "SETTAGS=")" == "true" ]; then
			sed -i "s/ro.build.tags=$FILETAGS/ro.build.tags=$SEDTAGS/" $MODDIR/system/build.prop && log_handler "ro.build.tags"
		fi
		if [ "$MODULESELINUX" ]; then
			SEDSELINUX=$MODULESELINUX
		else
			SEDSELINUX=0
		fi
		if [ "$(get_file_value $LATEFILE "SETSELINUX=")" == "true" ]; then
			sed -i "s/ro.build.selinux=$FILESELINUX/ro.build.selinux=$SEDSELINUX/" $MODDIR/system/build.prop && log_handler "ro.build.selinux"
		fi
	else
		rm -f $MODDIR/system/build.prop
		log_handler "Build.prop editing disabled."
	fi
else
	rm -f $MODDIR/system/build.prop
	log_handler "Prop file editing disabled. All values ok."
fi

log_handler "post-fs-data.sh finished.\n\n===================="
