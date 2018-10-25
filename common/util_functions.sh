#!/system/bin/sh

# MagiskHide Props Config
# By Didgeridoohan @ XDA Developers

# Variables
MODVERSION=VER_PLACEHOLDER
MIRRORPATH=$COREPATH/mirror
POSTFILE=$IMGPATH/.core/post-fs-data.d/propsconf_post
LATEFILE=$IMGPATH/.core/service.d/propsconf_late
SYSTEMLOC=SYSTEM_PLACEHOLDER
CACHELOC=CACHE_PLACEHOLDER
POSTCHKFILE=$CACHELOC/propsconf_postchk
RUNFILE=$MODPATH/script_check
LOGFILE=$CACHELOC/propsconf.log
LASTLOGFILE=$CACHELOC/propsconf_last.log
TMPLOGLOC=$CACHELOC/propslogs
TMPLOGLIST="
$CACHELOC/magisk.log
$CACHELOC/magisk.log.bak
/data/adb/magisk_debug.log
$CACHELOC/propsconf*
$MIRRORPATH/system/build.prop
$MIRRORPATH/vendor/build.prop
$LATEFILE
"
CONFFILE=$CACHELOC/propsconf_conf
RESETFILE=$CACHELOC/reset_mhpc
MAGISKLOC=/data/adb/magisk
BBPATH=$MAGISKLOC/busybox
if [ -z "$(echo $PATH | grep /sbin:)" ]; then
	alias resetprop="$MAGISKLOC/magisk resetprop"
fi
alias cat="$BBPATH cat"
alias chmod="$BBPATH chmod"
alias cp="$BBPATH cp"
alias grep="$BBPATH grep"
alias id="$BBPATH id"
alias mv="$BBPATH mv"
alias printf="$BBPATH printf"
alias sed="$BBPATH sed"
alias sort="$BBPATH sort"
alias tar="$BBPATH tar"
alias tee="$BBPATH tee"
alias tr="$BBPATH tr"
alias wget="$BBPATH wget"
PRINTSLOC=$MODPATH/prints.sh
PRINTSTMP=$CACHELOC/prints.sh
PRINTSWWW="https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/prints.sh"
PRINTFILES=$MODPATH/printfiles
BIN=BIN_PLACEHOLDER
USNFLIST=USNF_PLACEHOLDER

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
	if [ -f "$1" ]; then
		cat $1 | grep $2 | sed "s|.*${2}||" | sed 's|\"||g'
	fi
}

# Log functions
# Saves the previous log (if available) and creates a new one
log_start() {
	if [ -f "$LOGFILE" ]; then
		mv -f $LOGFILE $LASTLOGFILE
	fi
	touch $LOGFILE
	echo "***************************************************" >> $LOGFILE 2>&1
	echo "********* MagiskHide Props Config $MODVERSION ********" >> $LOGFILE 2>&1
	echo "***************** By Didgeridoohan ***************" >> $LOGFILE 2>&1
	echo "***************************************************" >> $LOGFILE 2>&1
	log_script_chk "Log start."
}
log_handler() {
	if [ "$(id -u)" == 0 ] ; then
		echo "" >> $LOGFILE 2>&1
		echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $LOGFILE 2>&1
	fi
}
log_print() {
	echo "$1"
	log_handler "$1"
}
log_script_chk() {
	log_handler "$1"
	echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $RUNFILE 2>&1
}

#Divider
DIVIDER="${Y}=====================================${N}"

# Header
menu_header() {
	if [ -z "$LOGNAME" ] && [ "$DEVTESTING" == "false" ]; then
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

# Get Android version for current fingerprint
get_android_version() {
	VERTMP="$(echo $1 | sed 's|:user.*||' | sed 's|.*:||' | sed 's|/.*||' | sed 's|\.||g')"
	if [ "${#VERTMP}" -lt 3 ]; then
		until [ "${#VERTMP}" == 3 ]
		do
			VERTMP="$(echo ${VERTMP}0)"
		done
	fi
	echo $VERTMP
}

# Get security patch date for current fingerprint
get_sec_patch() {
	echo $1 | sed 's|.*\_\_||'
}

# Get the fingerprint for displaying in the ui
get_print_display() {
	echo $1 | sed 's|\_\_.*||'
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

# Check for original prop values
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

# Check if boot scripts ran during boot
script_ran_check() {
	POSTCHECK=0
	if [ -f "$RUNFILE" ] && [ "$(cat $RUNFILE | grep "post-fs-data.d finished")" ]; then
		POSTCHECK=1
	fi
	LATECHECK=0
	if [ -f "$RUNFILE" ] && [ "$(cat $RUNFILE | grep "Boot script finished")" ]; then
		LATECHECK=1
	fi
}

# Load currently set values
curr_values() {
	CURRDEBUGGABLE=$(resetprop -v ro.debuggable) >> $LOGFILE 2>&1
	CURRSECURE=$(resetprop -v ro.secure) >> $LOGFILE 2>&1
	CURRTYPE=$(resetprop -v ro.build.type) >> $LOGFILE 2>&1
	CURRTAGS=$(resetprop -v ro.build.tags) >> $LOGFILE 2>&1
	CURRSELINUX=$(resetprop -v ro.build.selinux) >> $LOGFILE 2>&1
	CURRFINGERPRINT=$(resetprop -v ro.build.fingerprint) >> $LOGFILE 2>&1
	if [ -z "$CURRFINGERPRINT" ]; then
		CURRFINGERPRINT=$(resetprop -v ro.bootimage.build.fingerprint) >> $LOGFILE 2>&1
		if [ -z "$CURRFINGERPRINT" ]; then
			CURRFINGERPRINT=$(resetprop -v ro.vendor.build.fingerprint) >> $LOGFILE 2>&1
		fi
	fi
}

# Load original values
orig_values() {
	ORIGDEBUGGABLE=$(get_file_value $LATEFILE "ORIGDEBUGGABLE=")
	ORIGSECURE=$(get_file_value $LATEFILE "ORIGSECURE=")
	ORIGTYPE=$(get_file_value $LATEFILE "ORIGTYPE=")
	ORIGTAGS=$(get_file_value $LATEFILE "ORIGTAGS=")
	ORIGSELINUX=$(get_file_value $LATEFILE "ORIGSELINUX=")
	ORIGFINGERPRINT=$(get_file_value $LATEFILE "ORIGFINGERPRINT=")
}

# Load module values
module_values() {
	MODULEDEBUGGABLE=$(get_file_value $LATEFILE "MODULEDEBUGGABLE=")
	MODULESECURE=$(get_file_value $LATEFILE "MODULESECURE=")
	MODULETYPE=$(get_file_value $LATEFILE "MODULETYPE=")
	MODULETAGS=$(get_file_value $LATEFILE "MODULETAGS=")
	MODULESELINUX=$(get_file_value $LATEFILE "MODULESELINUX=")
	MODULEFINGERPRINT=$(get_file_value $LATEFILE "MODULEFINGERPRINT=")
	CUSTOMPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")
	CUSTOMPROPSPOST=$(get_file_value $LATEFILE "CUSTOMPROPSPOST=")
	CUSTOMPROPSLATE=$(get_file_value $LATEFILE "CUSTOMPROPSLATE=")
	CUSTOMPROPSLIST="$CUSTOMPROPS $CUSTOMPROPSPOST $CUSTOMPROPSLATE"
	DELETEPROPS=$(get_file_value $LATEFILE "DELETEPROPS=")
}

# Run all value loading functions
all_values() {
	log_handler "Loading values."
	# Currently set values
	curr_values
	# Original values
	orig_values
	# Module values
	module_values
}

# Run after updated props/settings
after_change() {
	# Update the reboot variable
	reboot_chk
	# Load all values
	all_values
	# Ask to reboot
	reboot_fn "$1"
}

# Run after changing props/settings with configuration file
after_change_file() {
	# Update the reboot variable
	reboot_chk
	# Load all values
	INPUT=""
	all_values
	# Ask to reboot
	reboot_fn "$1" "$2"
}

# Check if module needs a reboot
reboot_chk() {
	replace_fn REBOOTCHK 0 1 $LATEFILE
}

# Reset module
reset_fn() {
	BUILDPROPENB=$(get_file_value $LATEFILE "BUILDPROPENB=")
	FINGERPRINTENB=$(get_file_value $LATEFILE "FINGERPRINTENB=")
	cp -af $MODPATH/propsconf_late $LATEFILE >> $LOGFILE 2>&1
	if [ "$BUILDPROPENB" ] && [ "$BUILDPROPENB" != 1 ]; then
		replace_fn BUILDPROPENB 1 $BUILDPROPENB $LATEFILE
	fi
	if [ "$FINGERPRINTENB" ] && [ "$FINGERPRINTENB" != 1 ]; then
		replace_fn FINGERPRINTENB 1 $FINGERPRINTENB $LATEFILE
	fi
	chmod -v 755 $LATEFILE >> $LOGFILE 2>&1
	placeholder_update $LATEFILE IMGPATH IMG_PLACEHOLDER $IMGPATH
	placeholder_update $LATEFILE CACHELOC CACHE_PLACEHOLDER $CACHELOC

	if [ "$1" != "post" ]; then
		# Update the reboot variable
		reboot_chk

		# Update all prop value variables
		all_values
	fi
}

# Check if original file values are safe
orig_safe() {
	replace_fn FILESAFE 0 1 $LATEFILE
	for V in $PROPSLIST; do
		PROP=$(get_prop_type $V)
		FILEPROP=$(echo "CURR${PROP}" | tr '[:lower:]' '[:upper:]')
		FILEVALUE=$(eval "echo \$$FILEPROP")
		log_handler "Checking ${FILEPROP}=${FILEVALUE}"
		safe_props $V $FILEVALUE
		if [ "$SAFE" == 0 ]; then
			log_handler "Prop $V set to triggering value in prop file."
			replace_fn FILESAFE 1 0 $LATEFILE
		else
			if [ -z "$FILEVALUE" ]; then
				log_handler "Could not retrieve value for prop $V."
			elif [ "$SAFE" == 1 ]; then
				log_handler "Prop $V set to \"safe\" value in prop file."
			fi
		fi
	done
}

# Checks for configuration file
config_file() {
	log_handler "Checking for configuration file."
	if [ -f "$CONFFILE" ]; then
		log_handler "Configuration file detected (${CONFFILE})."
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
			if [ "$CONFPROPS" ] || [ "$CONFPROPSPOST" ] || [ "$CONFPROPSLATE" ]; then
				if [ "$PROPOPTION" == "add" ] || [ "$PROPOPTION" == "replace" ]; then
					if [ "$PROPOPTION" == "replace" ]; then
						reset_all_custprop "file"
					fi
					if [ "$CONFPROPS" ]; then
						for ITEM in $CONFPROPS; do
							set_custprop "$(get_eq_left "$ITEM")" "$(get_eq_right "$ITEM")" "default" "file"
						done
					fi
					if [ "$CONFPROPSPOST" ]; then
						for ITEM in $CONFPROPSPOST; do
							set_custprop "$(get_eq_left "$ITEM")" "$(get_eq_right "$ITEM")" "post" "file"
						done
					fi
					if [ "$CONFPROPSLATE" ]; then
						for ITEM in $CONFPROPSLATE; do
							set_custprop "$(get_eq_left "$ITEM")" "$(get_eq_right "$ITEM")" "late" "file"
						done
					fi
				fi
			else
				reset_all_custprop "file"
			fi
		fi

		# Updates props to delete
		if [ "$DELPROPOPTION" != "preserve" ]; then
			if [ "$CONFDELPROPS" ]; then
				if [ "$DELPROPOPTION" == "add" ] || [ "$DELPROPOPTION" == "replace" ]; then
					if [ "$DELPROPOPTION" == "replace" ]; then
						reset_all_delprop "file"
					fi
					for ITEM in $CONFDELPROPS; do
						set_delprop "$ITEM" "file"
					done
				fi
			else
				reset_all_delprop "file"
			fi
		fi

		# Updates options
		OPTLCURR=$(get_file_value $LATEFILE "OPTIONLATE=")
		OPTCCURR=$(get_file_value $LATEFILE "OPTIONCOLOUR=")
		OPTWCURR=$(get_file_value $LATEFILE "OPTIONWEB=")
		if [ "$CONFLATE" == "true" ]; then
			OPTLCHNG=1
			TMPTXT="late_start service"
		else
			OPTLCHNG=0
			TMPTXT="post-fs-data"
		fi
		replace_fn OPTIONLATE $OPTLCURR $OPTLCHNG $LATEFILE
		log_handler "Boot stage is ${TMPTXT}."
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

# Connection test
test_connection() {
	ping -c 1 -W 1 google.com >> $LOGFILE 2>&1 && CNTTEST="true" || CNTTEST="false"
}

# ======================== Fingerprint functions ========================
# Set new fingerprint
print_edit() {
	if [ "$(get_file_value $LATEFILE "FINGERPRINTENB=")" == 1 -o "$(get_file_value $LATEFILE "PRINTMODULE=")" == "false" ] && [ "$(get_file_value $LATEFILE "PRINTEDIT=")" == 1 ]; then
		log_handler "Changing fingerprint."
		PRINTCHNG="$(get_file_value $LATEFILE "MODULEFINGERPRINT=" | sed 's|\_\_.*||')"
		for ITEM in $PRINTPROPS; do
			log_handler "Changing/writing $ITEM."
			resetprop -v $ITEM >> $LOGFILE 2>&1
			resetprop -nv $ITEM $PRINTCHNG >> $LOGFILE 2>&1
		done
		# Edit security patch date if included
		SECPATCH="$(get_sec_patch $(get_file_value $LATEFILE "MODULEFINGERPRINT="))"
		case "$(get_file_value $LATEFILE "MODULEFINGERPRINT=")" in
			*__*)
				if [ "$SECPATCH" ]; then
					log_handler "Update security patch date to match fingerprint used."
					resetprop -v ro.build.version.security_patch >> $LOGFILE 2>&1
					resetprop -v ro.build.version.security_patch $SECPATCH >> $LOGFILE 2>&1
				fi
			;;
		esac
	fi
}

# Create fingerprint files
print_files() {
	log_print "Creating fingerprint files."
	rm -rf $PRINTFILES >> $LOGFILE 2>&1
	mkdir -pv $PRINTFILES >> $LOGFILE 2>&1
	# Loading prints
	. $PRINTSLOC
	# Saving manufacturers
	log_handler "Saving manufacturers."
	SAVEIFS=$IFS
	IFS=$(echo -en "\n\b")
	for ITEM in $PRINTSLIST; do
		TMPOEMLIST=$(echo "$OEMLIST $(get_first $ITEM)" | sed 's|^[ \t]*||')
		OEMLIST="$TMPOEMLIST"
	done
	IFS=$SAVEIFS
	TMPOEMLIST=$(echo $(printf '%s\n' $OEMLIST | sort -u))
	OEMLIST="$TMPOEMLIST"
	log_handler "Creating files."
	for OEM in $OEMLIST; do
		echo -e "PRINTSLIST=\"" >> $PRINTFILES/${OEM}\.sh
		cat $PRINTSLOC | grep $OEM >> $PRINTFILES/${OEM}\.sh
		echo -e "\"" >> $PRINTFILES/${OEM}\.sh
	done
}

# Checks and updates the prints list
download_prints() {
	if [ -z "$LOGNAME" ] && [ "$DEVTESTING" == "false" ]; then
		clear
	fi
	if [ "$1" == "Dev" ]; then
		PRINTSWWW="https://raw.githubusercontent.com/Didgeridoohan/Playground/master/prints.sh"
	fi
	menu_header "Updating fingerprints list"
	echo ""
	# Testing connection
	log_print "Checking connection."
	test_connection
	# Checking and downloading fingerprints list
	if [ "$CNTTEST" == "true" ]; then
		log_print "Checking list version."
		wget -T 5 -q -O $PRINTSTMP $PRINTSWWW >> $LOGFILE 2>&1
		if [ -s "$PRINTSTMP" ]; then
			LISTVERSION=$(get_file_value $PRINTSTMP "PRINTSV=")
			if [ "$LISTVERSION" ]; then
				if [ "$LISTVERSION" == "Dev" ] || [ "$LISTVERSION" -gt "$(get_file_value $PRINTSLOC "PRINTSV=")" ]; then
					VERSIONTMP=$(get_file_value $MODPATH/module.prop "version=")
					VERSIONCMP=$(echo $VERSIONTMP | sed 's|v||g' | sed 's|-.*||' | sed 's|\.||g')
					if [ "$(get_file_value $PRINTSTMP "PRINTSTRANSF=")" -le $VERSIONCMP ]; then
						mv -f $PRINTSTMP $PRINTSLOC >> $LOGFILE 2>&1
						# Updates list version in module.prop
						replace_fn version $VERSIONTMP "${MODVERSION}-v${LISTVERSION}" $MODPATH/module.prop
						log_print "Updated list to v${LISTVERSION}."
						print_files
					else
						rm -f $PRINTSTMP
						log_print "New fingerprints list requires module update."
					fi
				else
					rm -f $PRINTSTMP
					log_print "Fingerprints list up-to-date."
				fi
			else
				rm -f $PRINTSTMP
				log_print "! File not downloaded!"
				log_handler "Couldn't extract list version."
			fi
		elif [ -f "$PRINTSTMP" ]; then
			rm -f $PRINTSTMP
			log_print "! File not downloaded!"
			log_handler "File is empty."
		else
			log_print "! File not downloaded!"
		fi
	else
		log_print "No connection."
	fi
	if [ "$1" == "manual" ]; then
		sleep 2
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

# Editing prop files settings
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
			if [ "$(cat $SYSTEMLOC/build.prop | grep "$ORIGFINGERPRINT")" ]; then
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
				PROPVALUE=$(get_file_value $SYSTEMLOC/build.prop "${PROPTYPE}=")
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

# Edit the prop files
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
		FILEPROP=$(echo "ORIG${PROP}" | tr '[:lower:]' '[:upper:]')
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
	fi
	if [ "$(get_file_value $LATEFILE "PROPCOUNT=")" == 0 ]; then
		replace_fn PROPEDIT 1 0 $LATEFILE
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
# Set custom props
custom_edit() {
	if [ "$1" ] && [ "$(get_file_value $LATEFILE "CUSTOMEDIT=")" == 1 ]; then
		TMPLST="$(get_file_value $LATEFILE "${1}=")"
		if [ "$TMPLST" ]; then
			log_handler "Writing custom props."
			for ITEM in $TMPLST; do			
				log_handler "Changing/writing $(get_eq_left "$ITEM")."
				TMPITEM=$( echo $(get_eq_right "$ITEM") | sed 's|_sp_| |g')
				resetprop -v $(get_eq_left "$ITEM") >> $LOGFILE 2>&1
				resetprop -nv $(get_eq_left "$ITEM") "$TMPITEM" >> $LOGFILE 2>&1
			done
		fi
	fi
}

# Set custom prop value
set_custprop() {
	if [ "$2" ]; then
		PROPSBOOTSTAGE="CUSTOMPROPS"
		if [ "$3" == "post" ]; then
			PROPSBOOTSTAGE="CUSTOMPROPSPOST"
		elif [ "$3" == "late" ]; then
			PROPSBOOTSTAGE="CUSTOMPROPSLATE"
		fi
		TMPVALUE=$(echo "$2" | sed 's| |_sp_|g')
		CURRCUSTPROPS=$(get_file_value $LATEFILE "${PROPSBOOTSTAGE}=")
		case "$CURRCUSTPROPS" in
			*$1*)
				TMPORIG=$(echo "$4" | sed 's| |_sp_|g')
				TMPCUSTPROPS=$(echo "$CURRCUSTPROPS" | sed "s|${1}=${TMPORIG}|${1}=${TMPVALUE}|")
			;;
			*)
				TMPCUSTPROPS=$(echo "$CURRCUSTPROPS  ${1}=${TMPVALUE}" | sed 's|^[ \t]*||')
			;;
		esac
		SORTCUSTPROPS=$(echo $(printf '%s\n' $TMPCUSTPROPS | sort -u))

		log_handler "Setting custom prop $1."
		replace_fn $PROPSBOOTSTAGE "\"$CURRCUSTPROPS\"" "\"$SORTCUSTPROPS\"" $LATEFILE
		replace_fn CUSTOMEDIT 0 1 $LATEFILE

		if [ "$4" != "file" ]; then
			after_change "$1"
		fi
	fi
}

# Reset all custom prop values
reset_all_custprop() {
	CURRCUSTPROPS=$(get_file_value $LATEFILE "CUSTOMPROPS=")
	CURRCUSTPROPSPOST=$(get_file_value $LATEFILE "CUSTOMPROPSPOST=")
	CURRCUSTPROPSLATE=$(get_file_value $LATEFILE "CUSTOMPROPSLATE=")

	log_handler "Resetting all custom props."
	# Removing all custom props
	replace_fn CUSTOMPROPS "\"$CURRCUSTPROPS\"" "\"\"" $LATEFILE
	replace_fn CUSTOMPROPSPOST "\"$CURRCUSTPROPSPOST\"" "\"\"" $LATEFILE
	replace_fn CUSTOMPROPSLATE "\"$CURRCUSTPROPSLATE\"" "\"\"" $LATEFILE
	replace_fn CUSTOMEDIT 1 0 $LATEFILE

	if [ "$1" != "file" ]; then
		after_change "$1"
	fi
}

# Reset custom prop value
reset_custprop() {
	if [ "$(echo $CUSTOMPROPS | grep $1)" ]; then
		PROPSBOOTSTAGE="CUSTOMPROPS"
	elif [ "$(echo $CUSTOMPROPSPOST | grep $1)" ]; then
		PROPSBOOTSTAGE="CUSTOMPROPSPOST"
	elif [ "$(echo $CUSTOMPROPSLATE | grep $1)" ]; then
		PROPSBOOTSTAGE="CUSTOMPROPSLATE"
	fi
	TMPVALUE=$(echo "$2" | sed 's| |_sp_|g')
	CURRCUSTPROPS=$(get_file_value $LATEFILE "${PROPSBOOTSTAGE}=")

	log_handler "Resetting custom prop $1."
	TMPCUSTPROPS=$(echo $CURRCUSTPROPS | sed "s|${1}=${TMPVALUE}||" | tr -s " " | sed 's|^[ \t]*||')

	# Updating custom props string
	replace_fn $PROPSBOOTSTAGE "\"$CURRCUSTPROPS\"" "\"$TMPCUSTPROPS\"" $LATEFILE
	if [ -z "$(get_file_value $LATEFILE "CUSTOMPROPS=")" ] && [ -z "$(get_file_value $LATEFILE "CUSTOMPROPSPOST=")" ] && [ -z "$(get_file_value $LATEFILE "CUSTOMPROPSLATE=")" ]; then
		replace_fn CUSTOMEDIT 1 0 $LATEFILE
	fi

	if [ "$3" != "bootstage" ]; then
		after_change "$1"
	fi
}

# Change what boot stage is used for custom prop
change_bootstage_custprop() {
	reset_custprop "$1" "$(resetprop $1)" "bootstage"
	set_custprop "$1" "$(resetprop $1)" "$2"
}

# ======================== Delete Props functions ========================
# Delete props
prop_del() {
	if [ "$(get_file_value $LATEFILE "DELEDIT=")" == 1 ]; then
		log_handler "Deleting props."
		TMPLST="$(get_file_value $LATEFILE "DELETEPROPS=")"
		for ITEM in $TMPLST; do			
			log_handler "Deleting $ITEM."
			TMPITEM=$( echo $(get_eq_right "$ITEM") | sed 's|_sp_| |g')
			resetprop -v $ITEM >> $LOGFILE 2>&1
			resetprop -v --delete $ITEM >> $LOGFILE 2>&1
		done
	fi
}

# Set prop to delete
set_delprop() {
	if [ "$1" ]; then
		CURRDELPROPS=$(get_file_value $LATEFILE "DELETEPROPS=")
		TMPDELPROPS=$(echo "$CURRDELPROPS  ${1}" | sed 's|^[ \t]*||')
		SORTDELPROPS=$(echo $(printf '%s\n' $TMPDELPROPS | sort -u))

		log_handler "Setting prop to delete, $1."
		replace_fn DELETEPROPS "\"$CURRDELPROPS\"" "\"$SORTDELPROPS\"" $LATEFILE
		replace_fn DELEDIT 0 1 $LATEFILE

		if [ "$2" != "file" ]; then
			after_change "Delete $1"
		fi
	fi
}

# Reset all props to delete
reset_all_delprop() {
	CURRDELPROPS=$(get_file_value $LATEFILE "DELETEPROPS=")

	log_handler "Resetting list of props to delete."
	# Removing all props to delete
	replace_fn DELETEPROPS "\"$CURRDELPROPS\"" "\"\"" $LATEFILE
	replace_fn DELEDIT 1 0 $LATEFILE

	if [ "$1" != "file" ]; then
		after_change "Delete $1"
	fi
}

# Reset prop to delete
reset_delprop() {
	CURRDELPROPS=$(get_file_value $LATEFILE "DELETEPROPS=")

	log_handler "Resetting prop to delete, $1."
	TMPDELPROPS=$(echo $CURRDELPROPS | sed "s|${1}||" | tr -s " " | sed 's|^[ \t]*||')

	# Resetting prop to delete
	replace_fn DELETEPROPS "\"$CURRDELPROPS\"" "\"$TMPDELPROPS\"" $LATEFILE
	CURRDELPROPS=$(get_file_value $LATEFILE "DELETEPROPS=")
	if [ -z "$CURRDELPROPS" ]; then
		replace_fn DELEDIT 1 0 $LATEFILE
	fi

	after_change "Delete $1"
}

# ======================== Log collecting functions ========================
# Collects useful logs and info for troubleshooting
collect_logs() {
	log_handler "Collecting logs and information."
	# Create temporary directory
	mkdir -pv $TMPLOGLOC >> $LOGFILE 2>&1

	# Saving Magisk and module log files and device original build.prop
	for ITEM in $TMPLOGLIST; do
		if [ -f "$ITEM" ]; then
			case "$ITEM" in
				*build.prop*)	BPNAME="build_$(echo $ITEM | sed 's|\/build.prop||' | sed 's|.*\/||g').prop"
				;;
				*)	BPNAME=""
				;;
			esac
			cp -af $ITEM ${TMPLOGLOC}/${BPNAME} >> $LOGFILE 2>&1
		else
			case "$ITEM" in
				*/cache)
					if [ "$CACHELOC" == "/cache" ]; then
						CACHELOCTMP=/data/cache
					else
						CACHELOCTMP=/cache
					fi
					ITEMTPM=$(echo $ITEM | sed 's|$CACHELOC|$CACHELOCTMP|')
					if [ -f "$ITEMTPM" ]; then
						cp -af $ITEMTPM $TMPLOGLOC >> $LOGFILE 2>&1
					else
						log_handler "$ITEM not available."
					fi
				;;
				*)	log_handler "$ITEM not available."
				;;
			esac
		fi
	done

	# Saving the current prop values
	resetprop > $TMPLOGLOC/props.txt

	# Package the files
	cd $CACHELOC
	tar -zcvf propslogs.tar.gz propslogs >> $LOGFILE 2>&1

	# Copy package to internal storage
	mv -f $CACHELOC/propslogs.tar.gz /storage/emulated/0 >> $LOGFILE 2>&1
	
	# Remove temporary directory
	rm -rf $TMPLOGLOC >> $LOGFILE 2>&1

	log_handler "Logs and information collected."

	if [ "$1" != "issue" ]; then
		INPUTTMP=""
		menu_header "${C}$1${N}"
		echo ""
		echo "Logs and information collected."
		echo ""
		echo "The packaged file has been saved to the"
		echo "root of your device's internal storage."
		echo ""
		echo "Attach the file to a post in the support"
		echo "thread @ XDA, with a detailed description"
		echo "of your issue."
		echo ""
		echo -n "Press enter to continue..."
		read -r INPUTTMP
		case "$INPUTTMP" in
			*)
				if [ "$2" == "l" ]; then
					exit_fn
				fi
			;;
		esac
	fi
}

# Log print
log_handler "Functions loaded."
