#!/system/bin/sh

# MagiskHide Props Config
# By Didgeridoohan @ XDA Developers

# Variables
MODVERSION=VER_PLACEHOLDER
POSTFILE=$IMGPATH/.core/post-fs-data.d/propsconf_post
LATEFILE=$IMGPATH/.core/service.d/propsconf_late
CACHELOC=CACHE_PLACEHOLDER
LOGFILE=$CACHELOC/propsconf.log
LASTLOGFILE=$CACHELOC/propsconf_last.log
CONFFILE=$CACHELOC/propsconf_conf
RESETFILE=$CACHELOC/reset_mhpc
MAGISKLOC=/data/adb/magisk
BBPATH=$MAGISKLOC/busybox
PRINTSLOC=$MODPATH/prints.sh
PRINTSTMP=$CACHELOC/prints.sh
PRINTSWWW="https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/prints.sh"
BIN=BIN_PLACEHOLDER
USNFLIST=USNF_PLACEHOLDER
alias cat="$BBPATH cat"
alias grep="$BBPATH grep"
alias printf="$BBPATH printf"
alias resetprop="$MAGISKLOC/magisk resetprop"
alias sed="$BBPATH sed"
alias sort="$BBPATH sort"
alias tr="$BBPATH tr"
alias wget="$BBPATH wget"

# MagiskHide props
PROPSLIST="
ro.debuggable
ro.secure
ro.build.type
ro.build.tags
ro.build.selinux
"

# Safe values
SAFELIST="
ro.debuggable=0
ro.secure=1
ro.build.type=user
ro.build.tags=release-keys
ro.build.selinux=0
"

# Logs
log_handler() {
	echo "" >> $LOGFILE
	echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $LOGFILE
}
log_print() {
	echo "$1"
	log_handler "$1"
}

#Divider
DIVIDER="${Y}=====================================${N}"

# Header
menu_header() {
	if [ "$MODVERSION" == "VER_PLACEHOLDER" ]; then
		VERSIONTXT=""
	else
		VERSIONTXT=$MODVERSION
	fi
	echo ""
	echo "${W}MagiskHide Props Config $VERSIONTXT${N}"
	echo "${W}by Didgeridoohan @ XDA Developers${N}"
	echo ""
	echo $DIVIDER
	echo -e " $1"
	echo $DIVIDER
}

# Finding file values
get_file_value() {
	cat $1 | grep $2 | sed "s/.*$2//" | sed 's/\"//g'
}

# Find prop type
get_prop_type() {
	echo $1 | sed 's/.*\.//'
}

# Get left side of =
get_eq_left() {
	echo $1 | sed 's/=.*//'
}

# Get right side of =
get_eq_right() {
	echo $1 | sed 's/.*=//'
}

# Get first word in string
get_first() {
	echo $1 | sed 's/\ .*//'
}

# Updates placeholders
placeholder_update() {
	FILEVALUE=$(get_file_value $1 "$2=")
	log_handler "Checking for '$3' in '$1'. Current value is '$FILEVALUE'."
	case $FILEVALUE in
		*PLACEHOLDER*)	sed -i "s@${2}=${3}@${2}=${4}@g" $1
						log_handler "Placeholder '$3' updated to '$4' in '$1'."
		;;
	esac
}

orig_check() {
	PROPSTMPLIST=$PROPSLIST"
	ro.build.fingerprint
	"
	ORIGLOAD=0
	for PROPTYPE in $PROPSTMPLIST; do
		PROP=$(get_prop_type $PROPTYPE)
		ORIGPROP=$(echo "ORIG${PROP}" | tr '[:lower:]' '[:upper:]')
		ORIGVALUE=$(get_file_value $LATEFILE "${ORIGPROP}=")
		if [ "$ORIGVALUE" ]; then
			ORIGLOAD=1
		fi
	done
}

# Currently set values
curr_values() {
	CURRDEBUGGABLE=$(resetprop ro.debuggable)
	CURRSECURE=$(resetprop ro.secure)
	CURRTYPE=$(resetprop ro.build.type)
	CURRTAGS=$(resetprop ro.build.tags)
	CURRSELINUX=$(resetprop ro.build.selinux)
	CURRFINGERPRINT=$(resetprop ro.build.fingerprint)
	if [ -z "$CURRFINGERPRINT" ]; then
		CURRFINGERPRINT=$(resetprop ro.bootimage.build.fingerprint)
	fi
}

# Prop file values
file_values() {
	FILEDEBUGGABLE=$(get_file_value /default.prop "ro.debuggable=")
	FILESECURE=$(get_file_value /default.prop "ro.secure=")
	FILETYPE=$(get_file_value /system/build.prop "ro.build.type=")
	FILETAGS=$(get_file_value /system/build.prop "ro.build.tags=")
	FILESELINUX=$(get_file_value /system/build.prop "ro.build.selinux=")
}

# Latefile values
latefile_values() {
	LATEFILEDEBUGGABLE=$(get_file_value $LATEFILE "FILEDEBUGGABLE=")
	LATEFILESECURE=$(get_file_value $LATEFILE "FILESECURE=")
	LATEFILETYPE=$(get_file_value $LATEFILE "FILETYPE=")
	LATEFILETAGS=$(get_file_value $LATEFILE "FILETAGS=")
	LATEFILESELINUX=$(get_file_value $LATEFILE "FILESELINUX=")
}

# Original prop values
orig_values() {
	ORIGDEBUGGABLE=$(get_file_value $LATEFILE "ORIGDEBUGGABLE=")
	ORIGSECURE=$(get_file_value $LATEFILE "ORIGSECURE=")
	ORIGTYPE=$(get_file_value $LATEFILE "ORIGTYPE=")
	ORIGTAGS=$(get_file_value $LATEFILE "ORIGTAGS=")
	ORIGSELINUX=$(get_file_value $LATEFILE "ORIGSELINUX=")
	ORIGFINGERPRINT=$(get_file_value $LATEFILE "ORIGFINGERPRINT=")
}

# Module values
module_values() {
	MODULEDEBUGGABLE=$(get_file_value $LATEFILE "MODULEDEBUGGABLE=")
	MODULESECURE=$(get_file_value $LATEFILE "MODULESECURE=")
	MODULETYPE=$(get_file_value $LATEFILE "MODULETYPE=")
	MODULETAGS=$(get_file_value $LATEFILE "MODULETAGS=")
	MODULESELINUX=$(get_file_value $LATEFILE "MODULESELINUX=")
	MODULEFINGERPRINT=$(get_file_value $LATEFILE "MODULEFINGERPRINT=")
	CUSTOMPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")
}

# Run all value functions
all_values() {
	# Currently set values
	curr_values
	# Prop file values
	file_values
	# Latefile values
	latefile_values
	# Original prop values
	orig_values
	# Module values
	module_values
}

after_change() {
	# Update the reboot variable
	reboot_chk
	# Load all values
	all_values
	# Ask to reboot
	reboot_fn "$1"
}

after_change_file() {
	# Update the reboot variable
	reboot_chk
	# Load all values
	INPUT=""
	all_values
	# Ask to reboot
	reboot_fn "$1" "$2"
}

reboot_chk() {
	sed -i 's/REBOOTCHK=0/REBOOTCHK=1/' $LATEFILE
}

reset_fn() {
	BUILDPROPENB=$(get_file_value $LATEFILE "BUILDPROPENB=")
	FINGERPRINTENB=$(get_file_value $LATEFILE "FINGERPRINTENB=")
	cp -af $MODPATH/propsconf_late $LATEFILE
	if [ "$BUILDPROPENB" ] && [ -z "$BUILDPROPENB" == 1 ]; then
		sed -i "s@BUILDPROPENB=1@BUILDPROPENB=$BUILDPROPENB@g" $LATEFILE
	fi
	if [ "$FINGERPRINTENB" ] && [ -z "$FINGERPRINTENB" == 1 ]; then
		sed -i "s@FINGERPRINTENB=1@FINGERPRINTENB=$FINGERPRINTENB@g" $LATEFILE
	fi
	chmod 755 $LATEFILE	
	placeholder_update $LATEFILE IMGPATH IMG_PLACEHOLDER $IMGPATH

	# Update the reboot variable
	reboot_chk

	# Update all prop value variables
	all_values
}

# Check if original file values are safe
orig_safe() {
	sed -i 's/FILESAFE=0/FILESAFE=1/' $LATEFILE
	for V in $PROPSLIST; do
		PROP=$(get_prop_type $V)
		FILEPROP=$(echo "FILE${PROP}" | tr '[:lower:]' '[:upper:]')
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
}

# Checks for configuration file
config_file() {
	if [ -f "$CONFFILE" ]; then
		log_handler "Configuration file detected."
		# Loads custom variables
		. $CONFFILE
		# Updates prop values (including fingerprint)	
		PROPSTMPLIST=$PROPSLIST"
		ro.build.fingerprint
		"
		for PROPTYPE in $PROPSTMPLIST; do
			CONFPROP=$(echo "CONF$(get_prop_type $PROPTYPE)" | tr '[:lower:]' '[:upper:]')
			TMPPROP=$(eval "echo \$$CONFPROP")
			if [ "$TMPPROP" ]; then
				log_handler "Checking $PROPTYPE settings."
				if [ "$TMPPROP" != "preserve" ]; then
					if [ "$PROPTYPE" == "ro.build.fingerprint" ]; then
						if [ "$(get_file_value $LATEFILE "FINGERPRINTENB=")" == 1 ]; then
							change_print "$PROPTYPE" "$TMPPROP" "file"
						fi
					else
						change_prop "$PROPTYPE" "$TMPPROP" "file"
					fi
				fi
			else
				if [ "$PROPTYPE" == "ro.build.fingerprint" ]; then
					if [ "$(get_file_value $LATEFILE "FINGERPRINTENB=")" == 1 ]; then
						reset_print "$PROPTYPE" "file"
					fi
				else
					reset_prop "$PROPTYPE" "file"
				fi
			fi
		done

		# Updates prop file editing
		if [ "$(get_file_value $LATEFILE "FILESAFE=")" == 0 ]; then
			if [ "$CONFPROPFILES" == "true" ]; then
				edit_prop_files "file" "" " (configuration file)"
			elif [ "$CONFPROPFILES" == "false" ]; then
				reset_prop_files "file" "" " (configuration file)"
			fi
		fi

		# Updates custom props
		if [ "$PROPOPTION" != "preserve" ]; then
			if [ "$CONFPROPS" ]; then
				if [ "$PROPOPTION" == "add" ] || [ "$PROPOPTION" == "replace" ]; then
					if [ "$PROPOPTION" == "replace" ]; then
						reset_all_custprop "file"
					fi
					for ITEM in $CONFPROPS; do
						set_custprop "$(get_eq_left $ITEM)" "$(get_eq_right $ITEM)" "file"
					done
				fi
			else
				reset_all_custprop "file"
			fi
		fi

		# Updates options
		OPTCCURR=$(get_file_value $LATEFILE "OPTIONCOLOUR=")
		OPTWCURR=$(get_file_value $LATEFILE "OPTIONWEB=")
		if [ "$CONFCOLOUR" == "enabled" ]; then
			
			sed -i "s@OPTIONCOLOUR=$OPTCCURR@OPTIONCOLOUR=1@" $LATEFILE
		else
			sed -i "s@OPTIONCOLOUR=$OPTCCURR@OPTIONCOLOUR=0" $LATEFILE
		fi
		log_handler "Colour $CONFCOLOUR."
		if [ "$CONFWEB" == "enabled" ]; then
			sed -i "s@OPTIONWEB=$OPTWCURR@OPTIONWEB=1@" $LATEFILE
		else
			sed -i "s@OPTIONWEB=$OPTWCURR@OPTIONWEB=0@" $LATEFILE
		fi
		log_handler "Automatic fingerprints list update $CONFWEB."

		# Deletes the configuration file
		log_handler "Deleting configuration file."
		rm -f $CONFFILE
	fi
}

# ======================== Fingerprint functions ========================
# Checks and updates the prints list
download_prints() {
	clear
	menu_header "Updating fingerprints list"
	echo ""
	log_print "Checking list version."
	wget -T 10 -O $PRINTSTMP $PRINTSWWW 2>> $LOGFILE	
	if [ -f "$PRINTSTMP" ]; then
		LISTVERSION=$(get_file_value $PRINTSTMP "PRINTSV=")
		if [ "$LISTVERSION" -gt "$(get_file_value $PRINTSLOC "PRINTSV=")" ]; then
			if [ "$(get_file_value $PRINTSTMP "PRINTSTRANSF=")" -le "$(get_file_value $PRINTSLOC "PRINTSTRANSF=")" ]; then
				mv -f $PRINTSTMP $PRINTSLOC
				# Updates list version in module.prop
				VERSIONTMP=$(get_file_value $MODPATH/module.prop "version=")
				sed -i "s/version=$VERSIONTMP/version=$MODVERSION-v$LISTVERSION/g" $MODPATH/module.prop
				log_print "Updated list to v${LISTVERSION}."
			else
				rm -f $PRINTSTMP
				log_print "New fingerprints list requires module update."
			fi
		else
			rm -f $PRINTSTMP
			log_print "Fingerprints list up-to-date."
		fi
	else
		log_print "No connection."
	fi
	if [ "$1" == "manual" ]; then
		sleep 2
	fi
}

# Reset the module fingerprint change
reset_print() {
	log_handler "Resetting device fingerprint."

	SUBA=$(get_file_value $LATEFILE "MODULEFINGERPRINT=")

	# Saves new module value
	sed -i "s@MODULEFINGERPRINT=\"$SUBA\"@MODULEFINGERPRINT=\"\"@" $LATEFILE
	# Updates prop change variables in propsconf_late
	sed -i 's/PRINTEDIT=1/PRINTEDIT=0/g' $LATEFILE

	if [ "$2" != "file" ]; then
		after_change "$1"
	fi
}

# Use fingerprint
change_print() {
	log_handler "Changing device fingerprint to $2."

	SUBA=$(get_file_value $LATEFILE "MODULEFINGERPRINT=")

	# Saves new module value
	sed -i "s@MODULEFINGERPRINT=\"$SUBA\"@MODULEFINGERPRINT=\"$2\"@" $LATEFILE
	# Updates prop change variables in propsconf_late
	sed -i 's/PRINTEDIT=0/PRINTEDIT=1/' $LATEFILE

	NEWFINGERPRINT=""

	if [ "$3" != "file" ]; then
		after_change "$1"
	fi
}

# ======================== Props files functions ========================
# Reset prop files
reset_prop_files() {
	log_handler "Resetting prop files$3."

	# Changes file	
	for PROPTYPE in $PROPSLIST; do
		log_handler "Disabling prop file editing for '$PROPTYPTE'."
		PROP=$(get_prop_type $PROPTYPE)
		FILEPROP=$(echo "FILE$PROP" | tr '[:lower:]' '[:upper:]')
		SETPROP=$(echo "SET$PROP" | tr '[:lower:]' '[:upper:]')
		
		sed -i "s/$SETPROP=true/$SETPROP=false/" $LATEFILE
		sed -i 's/BUILDEDIT=1/BUILDEDIT=0/' $LATEFILE
		sed -i 's/DEFAULTEDIT=1/DEFAULTEDIT=0/' $LATEFILE
	done

	if [ "$1" != "file" ]; then
		after_change_file "$1" "$2"
	fi
}

# Editing prop files
edit_prop_files() {	
	log_handler "Modifying prop files$3."

	# Checks if editing prop files is enabled
	if [ "$(get_file_value $LATEFILE "BUILDPROPENB=")" == 0 ]; then
		log_handler "Editing build.prop is disabled. Only editing default.prop."		
		PROPSLIST="
		ro.debuggable
		ro.secure
		"
	fi

	for PROPTYPE in $PROPSLIST; do
		log_handler "Checking original file value for '$PROPTYPE'."
		PROP=$(get_prop_type $PROPTYPE)
		FILEPROP=$(echo "FILE$PROP" | tr '[:lower:]' '[:upper:]')
		SETPROP=$(echo "SET$PROP" | tr '[:lower:]' '[:upper:]')

		# Check the original file value
		PROPVALUE=$(get_file_value $LATEFILE "$FILEPROP=")
		if [ -z "$PROPVALUE" ]; then
			if [ "$PROPTYPE" == "ro.debuggable" ] || [ "$PROPTYPE" == "ro.secure" ]; then
				PROPVALUE=$(get_file_value /default.prop "${PROPTYPE}=")
			else
				PROPVALUE=$(get_file_value /system/build.prop "${PROPTYPE}=")
			fi
		fi

		# Checks for default/set values
		safe_props $PROPTYPE $PROPVALUE

		# Changes file only if necessary
		if [ "$SAFE" == 0 ]; then
			log_handler "Enabling prop file editing for '$PROPTYPE'."
			sed -i "s/$SETPROP=false/$SETPROP=true/" $LATEFILE
		elif [ "$SAFE" == 1 ]; then
			log_handler "Prop file editing unnecessary for '$PROPTYPE'."
			sed -i "s/$SETPROP=true/$SETPROP=false/" $LATEFILE
		else
			log_handler "Couldn't check safe value for '$PROPTYPE'."
		fi
		sed -i 's/DEFAULTEDIT=0/DEFAULTEDIT=1/' $LATEFILE
		sed -i 's/BUILDEDIT=0/BUILDEDIT=1/' $LATEFILE
	done

	if [ "$1" != "file" ]; then
		after_change_file "$1" "$2"
	fi
}

# ======================== MagiskHide Props functions ========================
# Check safe values
safe_props() {
	SAFE=""
	if [ "$2" ]; then
		for P in $SAFELIST; do
			if [ "$(get_eq_left $P)" == "$1" ]; then
				if [ "$2" == "$(get_eq_right $P)" ]; then
					SAFE=1
				else
					SAFE=0
				fi
				break
			fi
		done
	fi
}

# Find what prop value to change to
change_to() {
	CHANGE=""
	case "$1" in
		ro.debuggable) if [ "$2" == 0 ]; then CHANGE=1; else CHANGE=0; fi
		;;
		ro.secure) if [ "$2" == 0 ]; then CHANGE=1; else CHANGE=0; fi
		;;
		ro.build.type) if [ "$2" == "userdebug" ]; then CHANGE="user"; else CHANGE="userdebug"; fi
		;;
		ro.build.tags) if [ "$2" == "test-keys" ]; then CHANGE="release-keys"; else CHANGE="test-keys"; fi
		;;
		ro.build.selinux) if [ "$2" == 0 ]; then CHANGE=1; else CHANGE=0; fi
		;;
	esac
}

# Reset the module prop change
reset_prop() {
	# Sets variables
	PROP=$(get_prop_type $1)
	MODULEPROP=$(echo "MODULE${PROP}" | tr '[:lower:]' '[:upper:]')
	REPROP=$(echo "RE${PROP}" | tr '[:lower:]' '[:upper:]')
	SUBA=$(get_file_value $LATEFILE "${MODULEPROP}=")

	log_handler "Resetting $1 to default value."

	# Saves new module value
	sed -i "s/$MODULEPROP=\"$SUBA\"/$MODULEPROP=\"\"/" $LATEFILE
	# Changes prop
	sed -i "s/$REPROP=true/$REPROP=false/" $LATEFILE

	# Updates prop change variable in propsconf_late
	PROPCOUNT=$(get_file_value $LATEFILE "PROPCOUNT=")
	if [ "$SUBA" ]; then
		if [ "$PROPCOUNT" -gt 0 ]; then
			PROPCOUNTP=$(($PROPCOUNT-1))
			sed -i "s/PROPCOUNT=$PROPCOUNT/PROPCOUNT=$PROPCOUNTP/" $LATEFILE
		fi
		if [ "$PROPCOUNT" == 0 ]; then
			sed -i 's/PROPEDIT=1/PROPEDIT=0/' $LATEFILE
		fi
	fi

	if [ "$2" != "file" ]; then
		after_change "$1"
	fi
}

# Use prop value
change_prop() {
	# Sets variables
	PROP=$(get_prop_type $1)
	MODULEPROP=$(echo "MODULE${PROP}" | tr '[:lower:]' '[:upper:]')
	REPROP=$(echo "RE${PROP}" | tr '[:lower:]' '[:upper:]')
	SUBA=$(get_file_value $LATEFILE "${MODULEPROP}=")

	log_handler "Changing $1 to $2."

	# Saves new module value
	sed -i "s/$MODULEPROP=\"$SUBA\"/$MODULEPROP=\"$2\"/" $LATEFILE
	# Changes prop
	sed -i "s/$REPROP=false/$REPROP=true/" $LATEFILE

	# Updates prop change variables in propsconf_late
	if [ -z "$SUBA" ]; then
		PROPCOUNT=$(get_file_value $LATEFILE "PROPCOUNT=")
		PROPCOUNTP=$(($PROPCOUNT+1))
		sed -i "s/PROPCOUNT=$PROPCOUNT/PROPCOUNT=$PROPCOUNTP/" $LATEFILE
	fi
	sed -i 's/PROPEDIT=0/PROPEDIT=1/' $LATEFILE

	if [ "$3" != "file" ]; then
		after_change "$1"
	fi
}

# Reset all module prop changes
reset_prop_all() {
	log_handler "Resetting all props to default values."

	for PROPTYPE in $PROPSLIST; do
		PROP=$(get_prop_type $PROPTYPE)
		MODULEPROP=$(echo "MODULE${PROP}" | tr '[:lower:]' '[:upper:]')
		REPROP=$(echo "RE${PROP}" | tr '[:lower:]' '[:upper:]')
		SUBA=$(get_file_value $LATEFILE "${MODULEPROP}=")

		# Saves new module value
		sed -i "s/$MODULEPROP=\"$SUBA\"/$MODULEPROP=\"\"/" $LATEFILE
		# Changes prop
		sed -i "s/$REPROP=true/$REPROP=false/" $LATEFILE

		# Updates prop change variables in propsconf_late
		PROPCOUNT=$(get_file_value $LATEFILE "PROPCOUNT=")
		sed -i "s/PROPCOUNT=$PROPCOUNT/PROPCOUNT=0/" $LATEFILE
		sed -i 's/PROPEDIT=1/PROPEDIT=0/' $LATEFILE
	done
	
	after_change "$1"
}

# ======================== Custom Props functions ========================
# Set custom prop value
set_custprop() {
	if [ "$2" ]; then
		CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")
		TMPCUSTPROPS=$(echo "$CURRCUSTPROPS  ${1}=${2}" | sed 's/^[ \t]*//')
		SORTCUSTPROPS=$(echo $(printf '%s\n' $TMPCUSTPROPS | sort -u))

		log_handler "Setting custom prop $1."
		sed -i "s/CUSTOMPROPS=\"$CURRCUSTPROPS\"/CUSTOMPROPS=\"$SORTCUSTPROPS\"/" $LATEFILE
		sed -i 's/CUSTOMEDIT=0/CUSTOMEDIT=1/' $LATEFILE

		if [ "$3" != "file" ]; then
			after_change "$1"
		fi
	fi
}

# Reset all custom prop values
reset_all_custprop() {
	CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")

	log_handler "Resetting all custom props."
	# Removing all custom props
	sed -i "s/CUSTOMPROPS=\"$CURRCUSTPROPS\"/CUSTOMPROPS=\"\"/" $LATEFILE
	sed -i 's/CUSTOMEDIT=1/CUSTOMEDIT=0/' $LATEFILE

	if [ "$1" != "file" ]; then
		after_change "$1"
	fi
}

# Reset custom prop value
reset_custprop() {
	CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")

	log_handler "Resetting custom props $1."
	TMPCUSTPROPS=$(echo $CURRCUSTPROPS | sed "s/$1=$2//" | tr -s " " | sed 's/^[ \t]*//')

	# Removing all custom props
	sed -i "s/CUSTOMPROPS=\"$CURRCUSTPROPS\"/CUSTOMPROPS=\"$TMPCUSTPROPS\"/" $LATEFILE
	CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")
	if [ -z "$CURRCUSTPROPS" ]; then
		sed -i 's/CUSTOMEDIT=1/CUSTOMEDIT=0/' $LATEFILE
	fi

	after_change "$1"
}