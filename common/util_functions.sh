#!/system/bin/sh

# MagiskHide Props Config
# By Didgeridoohan @ XDA Developers

# Variables
MODVERSION=VER_PLACEHOLDER
POSTFILE=$IMGPATH/.core/post-fs-data.d/propsconf_post
LATEFILE=$IMGPATH/.core/service.d/propsconf_late
CACHELOC=CACHE_PLACEHOLDER
RUNFILE=$MODPATH/script_check
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

# Print props
PRINTPROPS="
ro.build.fingerprint
ro.bootimage.build.fingerprint
ro.vendor.build.fingerprint
"

# Finding file values
get_file_value() {
	cat $1 | grep $2 | sed "s|.*${2}||" | sed 's|\"||g'
}

# Logs
# Saves the previous log (if available) and creates a new one
log_start() {
	if [ -f "$LOGFILE" ]; then
		mv -f $LOGFILE $LASTLOGFILE
	fi
	touch $LOGFILE
	echo "***************************************************" >> $LOGFILE
	echo "******** MagiskHide Props Config $MODVERSION ********" >> $LOGFILE
	echo "**************** By Didgeridoohan ***************" >> $LOGFILE
	echo "***************************************************" >> $LOGFILE
	log_script_chk "Log start."
}
log_handler() {
	echo "" >> $LOGFILE
	echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $LOGFILE
}
log_print() {
	echo "$1"
	log_handler "$1"
}
log_script_chk() {
	log_handler "$1"
	echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $RUNFILE
}

#Divider
DIVIDER="${Y}=====================================${N}"

# Header
menu_header() {
	if [ -z "$LOGNAME" ]; then
		clear
	fi
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

# Find prop type
get_prop_type() {
	echo $1 | sed 's|.*\.||'
}

# Get left side of =
get_eq_left() {
	echo $1 | sed 's|=.*||'
}

# Get right side of =
get_eq_right() {
	echo $1 | sed 's|.*=||'
}

# Get first word in string
get_first() {
	case $1 in
		*\ *) echo $1 | sed 's|\ .*||'
		;;
		*=*) get_eq_left "$1"
		;;
	esac
}

# Get the device for current fingerprint
get_device_used() {
	PRINTTMP=$(cat $MODPATH/prints.sh | grep "$1")
	if [ "$PRINTTMP" ]; then
		echo "${C}$(get_eq_left "$PRINTTMP" | sed "s| (.*||")${N}"
		echo ""
	fi
}

# Replace file values
replace_fn() {
	sed -i "s|${1}=${2}|${1}=${3}|" $4
}

# Updates placeholders
placeholder_update() {
	FILEVALUE=$(get_file_value $1 "$2=")
	log_handler "Checking for ${3} in ${1}. Current value is ${FILEVALUE}."
	case $FILEVALUE in
		*PLACEHOLDER*)	replace_fn $2 $3 $4 $1
						log_handler "Placeholder ${3} updated to ${4} in ${1}."
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
		ORIGPROP=$(echo "FILE${PROP}" | tr '[:lower:]' '[:upper:]')
		ORIGVALUE=$(get_file_value $LATEFILE "${ORIGPROP}=")
		if [ "$ORIGVALUE" ]; then
			ORIGLOAD=1
		fi
	done
}

script_ran_check() {
	POSTCHECK=0
	if [ "$(cat $RUNFILE | grep "post-fs-data.sh finished")" ]; then
		POSTCHECK=1
	fi
	LATECHECK=0
	if [ "$(cat $RUNFILE | grep "Boot script finished")" ]; then
		LATECHECK=1
	fi
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
		if [ -z "$CURRFINGERPRINT" ]; then
			CURRFINGERPRINT=$(resetprop ro.vendor.build.fingerprint)
		fi
	fi
}

# Prop file values
file_values() {
	FILEDEBUGGABLE=$(resetprop ro.debuggable)
	FILESECURE=$(resetprop ro.secure)
	FILETYPE=$(resetprop ro.build.type)
	FILETAGS=$(resetprop ro.build.tags)
	FILESELINUX=$(resetprop ro.build.selinux)
	FILEFINGERPRINT=$(resetprop ro.build.fingerprint)
	if [ -z "$FILEFINGERPRINT" ]; then
		FILEFINGERPRINT=$(resetprop ro.bootimage.build.fingerprint)
		if [ -z "$FILEFINGERPRINT" ]; then
			FILEFINGERPRINT=$(resetprop ro.vendor.build.fingerprint)
		fi
	fi
}

# Latefile values
latefile_values() {
	LATEFILEDEBUGGABLE=$(get_file_value $LATEFILE "FILEDEBUGGABLE=")
	LATEFILESECURE=$(get_file_value $LATEFILE "FILESECURE=")
	LATEFILETYPE=$(get_file_value $LATEFILE "FILETYPE=")
	LATEFILETAGS=$(get_file_value $LATEFILE "FILETAGS=")
	LATEFILESELINUX=$(get_file_value $LATEFILE "FILESELINUX=")
	LATEFILEFINGERPRINT=$(get_file_value $LATEFILE "FILEFINGERPRINT=")
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
	replace_fn REBOOTCHK 0 1 $LATEFILE
}

reset_fn() {
	BUILDPROPENB=$(get_file_value $LATEFILE "BUILDPROPENB=")
	FINGERPRINTENB=$(get_file_value $LATEFILE "FINGERPRINTENB=")
	cp -af $MODPATH/propsconf_late $LATEFILE
	if [ "$BUILDPROPENB" ] && [ -z "$BUILDPROPENB" == 1 ]; then
		replace_fn BUILDPROPENB 1 $BUILDPROPENB $LATEFILE
	fi
	if [ "$FINGERPRINTENB" ] && [ -z "$FINGERPRINTENB" == 1 ]; then
		replace_fn FINGERPRINTENB 1 $FINGERPRINTENB $LATEFILE
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
	replace_fn FILESAFE 0 1 $LATEFILE
	for V in $PROPSLIST; do
		PROP=$(get_prop_type $V)
		FILEPROP=$(echo "FILE${PROP}" | tr '[:lower:]' '[:upper:]')
		FILEVALUE=$(eval "echo \$$FILEPROP")
		log_handler "Checking $FILEPROP=$FILEVALUE"
		safe_props $V $FILEVALUE
		if [ "$SAFE" == 0 ]; then
			log_handler "Prop $V set to triggering value in prop file."
			replace_fn FILESAFE 1 0 $LATEFILE
		else
			log_handler "Prop $V set to \"safe\" value in prop file."
		fi
	done
}

# Checks for configuration file
config_file() {
	log_handler "Checking for configuration file."
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
						set_custprop "$(get_eq_left "$ITEM")" "$(get_eq_right "$ITEM")" "file"
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
			OPTCCHNG=1
		else
			OPTCCHNG=0
		fi
		replace_fn OPTIONCOLOUR $OPTCCURR $OPTCCHNG $LATEFILE
		log_handler "Colour $CONFCOLOUR."
		if [ "$CONFWEB" == "enabled" ]; then
			OPTWCHNG=1
		else
			OPTWCHNG=0
		fi
		replace_fn OPTIONWEB $OPTWCURR $OPTWCHNG $LATEFILE
		log_handler "Automatic fingerprints list update $CONFWEB."

		# Deletes the configuration file
		log_handler "Deleting configuration file."
		rm -f $CONFFILE
	else
		log_handler "No configuration file."
	fi
}

# ======================== Fingerprint functions ========================
# Checks and updates the prints list
download_prints() {
	if [ -z "$LOGNAME" ]; then
		clear
	fi
	if [ "$1" == "dev" ]; then
		PRINTSWWW="https://www.didgeridoohan.com/MagiskHidePropsConfig/prints.sh"
	fi
	menu_header "Updating fingerprints list"
	echo ""
	log_print "Checking list version."
	wget -T 10 -O $PRINTSTMP $PRINTSWWW 2>> $LOGFILE	
	if [ -f "$PRINTSTMP" ]; then
		LISTVERSION=$(get_file_value $PRINTSTMP "PRINTSV=")
		if [ "$LISTVERSION" == "DEV" ] || [ "$LISTVERSION" -gt "$(get_file_value $PRINTSLOC "PRINTSV=")" ]; then
			if [ "$(get_file_value $PRINTSTMP "PRINTSTRANSF=")" -le "$(get_file_value $PRINTSLOC "PRINTSTRANSF=")" ]; then
				mv -f $PRINTSTMP $PRINTSLOC
				# Updates list version in module.prop
				VERSIONTMP=$(get_file_value $MODPATH/module.prop "version=")
				replace_fn version $VERSIONTMP "${MODVERSION}-v${LISTVERSION}" $MODPATH/module.prop
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
	elif [ "$1" == "dev" ]; then
		sleep 2
		exit_fn
	else
		sleep 0.5
	fi
}

# Reset the module fingerprint change
reset_print() {
	log_handler "Resetting device fingerprint to default system value."

	SUBA=$(get_file_value $LATEFILE "MODULEFINGERPRINT=")

	# Saves new module value
	replace_fn MODULEFINGERPRINT "\"$SUBA\"" "\"\"" $LATEFILE
	# Updates prop change variables in propsconf_late
	replace_fn PRINTEDIT 1 0 $LATEFILE
	# Updates improved hiding setting
	if [ "$(get_file_value $LATEFILE "BUILDEDIT=")" ]; then
		replace_fn SETFINGERPRINT "true" "false" $LATEFILE
	fi

	if [ "$2" != "file" ]; then
		after_change "$1"
	fi
}

# Use fingerprint
change_print() {
	log_handler "Changing device fingerprint to $2."

	SUBA=$(get_file_value $LATEFILE "MODULEFINGERPRINT=")

	# Saves new module value
	replace_fn MODULEFINGERPRINT "\"$SUBA\"" "\"$2\"" $LATEFILE
	# Updates prop change variables in propsconf_late
	replace_fn PRINTEDIT 0 1 $LATEFILE
	# Updates improved hiding setting
	if [ "$(get_file_value $LATEFILE "BUILDEDIT=")" ]; then
		replace_fn SETFINGERPRINT "false" "true" $LATEFILE
	fi

	NEWFINGERPRINT=""

	if [ "$3" != "file" ]; then
		after_change "$1"
	fi
}

# ======================== Props files functions ========================
# Reset prop files
reset_prop_files() {
	log_handler "Resetting prop files$3."

	# Changes files
	for PROPTYPE in $PROPSLIST; do
		log_handler "Disabling prop file editing for '$PROPTYPTE'."
		PROP=$(get_prop_type $PROPTYPE)
		SETPROP=$(echo "SET$PROP" | tr '[:lower:]' '[:upper:]')
		replace_fn $SETPROP "true" "false" $LATEFILE
	done
	# Change fingerprint
	replace_fn SETFINGERPRINT "true" "false" $LATEFILE
	# Edit settings variables
	replace_fn BUILDEDIT 1 0 $LATEFILE
	replace_fn DEFAULTEDIT 1 0 $LATEFILE

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
	else
		# Checking if the device fingerprint is set by the module
		if [ "$(get_file_value $LATEFILE "FINGERPRINTENB=")" == 1 ] && [ "$(get_file_value $LATEFILE "PRINTEDIT=")" == 1 ]; then
			if [ "$(cat /system/build.prop | grep "$FILEFINGERPRINT")" ]; then
				log_handler "Enabling prop file editing for device fingerprint."
				replace_fn SETFINGERPRINT "false" "true" $LATEFILE
			fi
		fi
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
			replace_fn $SETPROP "false" "true" $LATEFILE
		elif [ "$SAFE" == 1 ]; then
			log_handler "Prop file editing unnecessary for '$PROPTYPE'."
			replace_fn $SETPROP "true" "false" $LATEFILE
		else
			log_handler "Couldn't check safe value for '$PROPTYPE'."
		fi
	done
	replace_fn BUILDEDIT 0 1 $LATEFILE
	replace_fn DEFAULTEDIT 0 1 $LATEFILE

	if [ "$1" != "file" ]; then
		after_change_file "$1" "$2"
	fi
}

change_prop_file() {
	case $1 in
		build)
			FNLIST="
			ro.build.type
			ro.build.tags
			ro.build.selinux
			"
			PROPFILELOC=$MODPATH/system/build.prop
		;;
		default)
			FNLIST="
			ro.debuggable
			ro.secure
			"
			PROPFILELOC=/default.prop
		;;
	esac
	for ITEM in $FNLIST; do
		PROP=$(get_prop_type $ITEM)
		MODULEPROP=$(echo "MODULE${PROP}" | tr '[:lower:]' '[:upper:]')
		FILEPROP=$(echo "FILE${PROP}" | tr '[:lower:]' '[:upper:]')
		SETPROP=$(echo "SET${PROP}" | tr '[:lower:]' '[:upper:]')
		if [ "$(eval "echo \$$MODULEPROP")" ]; then
			SEDVAR="$(eval "echo \$$MODULEPROP")"
		else
			for P in $SAFELIST; do
				if [ "$(get_eq_left "$P")" == "$ITEM" ]; then
					SEDVAR=$(get_eq_right "$P")
				fi
			done
		fi
		if [ "$(get_file_value $LATEFILE "${SETPROP}=")" == "true" ]; then
			replace_fn $ITEM $(eval "echo \$$FILEPROP") $SEDVAR $PROPFILELOC && log_handler "${ITEM}=${SEDVAR}"
		fi
	done	
}

# ======================== MagiskHide Props functions ========================
# Check safe values
safe_props() {
	SAFE=""
	if [ "$2" ]; then
		for P in $SAFELIST; do
			if [ "$(get_eq_left "$P")" == "$1" ]; then
				if [ "$2" == "$(get_eq_right "$P")" ]; then
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

	log_handler "Resetting $1 to default system value."

	# Saves new module value
	replace_fn $MODULEPROP "\"$SUBA\"" "\"\"" $LATEFILE
	# Changes prop
	replace_fn $REPROP "true" "false" $LATEFILE

	# Updates prop change variable in propsconf_late
	PROPCOUNT=$(get_file_value $LATEFILE "PROPCOUNT=")
	if [ "$SUBA" ]; then
		if [ "$PROPCOUNT" -gt 0 ]; then
			PROPCOUNTP=$(($PROPCOUNT-1))
			replace_fn PROPCOUNT $PROPCOUNT $PROPCOUNTP $LATEFILE
		fi
		if [ "$PROPCOUNT" == 0 ]; then
			replace_fn PROPEDIT 1 0 $LATEFILE
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
	replace_fn $MODULEPROP "\"$SUBA\"" "\"$2\"" $LATEFILE
	# Changes prop
	replace_fn $REPROP "false" "true" $LATEFILE

	# Updates prop change variables in propsconf_late
	if [ -z "$SUBA" ]; then
		PROPCOUNT=$(get_file_value $LATEFILE "PROPCOUNT=")
		PROPCOUNTP=$(($PROPCOUNT+1))
		replace_fn PROPCOUNT $PROPCOUNT $PROPCOUNTP $LATEFILE
	fi
	replace_fn PROPEDIT 0 1 $LATEFILE

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
		replace_fn $MODULEPROP "\"$SUBA\"" "\"\"" $LATEFILE
		# Changes prop
		replace_fn $REPROP "true" "false" $LATEFILE
	done
	
	# Updates prop change variables in propsconf_late
	PROPCOUNT=$(get_file_value $LATEFILE "PROPCOUNT=")
	replace_fn PROPCOUNT $PROPCOUNT 0 $LATEFILE
	replace_fn PROPEDIT 1 0 $LATEFILE
	
	after_change "$1"
}

# ======================== Custom Props functions ========================
# Set custom prop value
set_custprop() {
	if [ "$2" ]; then
		CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")
		TMPCUSTPROPS=$(echo "$CURRCUSTPROPS  ${1}=${2}" | sed 's|^[ \t]*||')
		SORTCUSTPROPS=$(echo $(printf '%s\n' $TMPCUSTPROPS | sort -u))

		log_handler "Setting custom prop $1."
		replace_fn CUSTOMPROPS "\"$CURRCUSTPROPS\"" "\"$SORTCUSTPROPS\"" $LATEFILE
		replace_fn CUSTOMEDIT 0 1 $LATEFILE

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
	replace_fn CUSTOMPROPS "\"$CURRCUSTPROPS\"" "\"\"" $LATEFILE
	replace_fn CUSTOMEDIT 1 0 $LATEFILE

	if [ "$1" != "file" ]; then
		after_change "$1"
	fi
}

# Reset custom prop value
reset_custprop() {
	CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")

	log_handler "Resetting custom props $1."
	TMPCUSTPROPS=$(echo $CURRCUSTPROPS | sed "s|${1}=${2}||" | tr -s " " | sed 's|^[ \t]*||')

	# Removing all custom props
	replace_fn CUSTOMPROPS "\"$CURRCUSTPROPS\"" "\"$TMPCUSTPROPS\"" $LATEFILE
	CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")
	if [ -z "$CURRCUSTPROPS" ]; then
		replace_fn CUSTOMEDIT 1 0 $LATEFILE
	fi

	after_change "$1"
}