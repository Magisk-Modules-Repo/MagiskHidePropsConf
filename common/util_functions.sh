#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

# ======================== Variables ========================
MODVERSION=VER_PLACEHOLDER
MIRRORPATH=$COREPATH/mirror
LATEFILE=LATE_PLACEHOLDER
MIRRORLOC=MIRROR_PLACEHOLDER
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
CONFFILELST="
/sdcard/propsconf_conf
/data/propsconf_conf
$CACHELOC/propsconf_conf
"
RESETFILE=$CACHELOC/reset_mhpc
MAGISKLOC=/data/adb/magisk
# Make sure that the terminal app used actually can see resetprop
alias resetprop="$MAGISKLOC/magisk resetprop"
# Finding installed Busybox
if [ -d "$IMGPATH/busybox-ndk" ]; then
		BBPATH=$(find $IMGPATH/busybox-ndk -name 'busybox')
else
	BBPATH=$(which busybox)
fi
PRINTSLOC=$MODPATH/prints.sh
PRINTSTMP=$CACHELOC/prints.sh
PRINTSWWW="https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/prints.sh"
PRINTSDEV="https://raw.githubusercontent.com/Didgeridoohan/Playground/master/prints.sh"
PRINTFILES=$MODPATH/printfiles
CSTMPRINTS=/sdcard/printslist
CSTMFILE=$PRINTFILES/Custom.sh
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

# Fingerprint props to change
PRINTPROPS="
ro.build.fingerprint
ro.bootimage.build.fingerprint
ro.vendor.build.fingerprint
"

# Print parts
PRINTPARTS="
ro.product.brand
ro.product.name
ro.product.device
ro.build.version.release
ro.build.id
ro.build.version.incremental
"

# Additional SafetyNet props
SNPROPS="
ro.build.version.security_patch
"

# Additional props
ADNPROPS="
ro.build.fingerprint
ro.vendor.build.fingerprint
ro.build.description
"

# Values props list
VALPROPSLIST=$PROPSLIST$PRINTPARTS$SNPROPS$ADNPROPS

# Loading module settings
. $LATEFILE

# ======================== General functions ========================
# Finding file values
get_file_value() {
	if [ -f "$1" ]; then
		grep $2 $1 | sed "s|.*${2}||" | sed 's|\"||g'
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
		echo -e "$(date +"%Y-%m-%d %H:%M:%S:%N") - $1" >> $LOGFILE 2>&1
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

# Get module version
module_v_ctrl() {
	VERSIONTMP=$(get_file_value $MODPATH/module.prop "version=")
	VERSIONCMP=$(echo $VERSIONTMP | sed 's|v||g' | sed 's|-.*||' | sed 's|\.||g')
}

# Find prop type
get_prop_type() {
	if [ "$1" == "ro.vendor.build.fingerprint" ]; then
		echo "vendprint"
	else
		echo $1 | sed 's|.*\.||' | sed 's|.*\_||'
	fi
}

# Get left side of =
get_eq_left() {
	echo $1 | cut -f 1 -d '='
}

# Get right side of =
get_eq_right() {
	echo $1 | cut -f 2 -d '='
}

# Get first word in fingerprint string
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
	elif [ -s "$CSTMPRINTS" ]; then
		PRINTTMP=$(cat $CSTMPRINTS | grep "$1")
		if [ "$PRINTTMP" ]; then
			echo "${C}$(get_eq_left "$PRINTTMP" | sed "s| (.*||")${N} (from custom list)"
			echo ""
		fi
	fi
}

# Get Android version with 3 digits for current fingerprint
get_android_version() {
	print_parts $1 "var"
	VERTMP=$VARRELEASE
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

# Format user files to remove Windows file endings
format_file() {
	log_handler "Formating file (${1})."
	# Remove Windows line endings
	sed -i 's/\r$//' $1
	# Check for newline at EOF
	if [ ! -z "$(tail -c 1 "$1")" ]; then
		echo "" >> $1
	fi
}

# Reboot the device
force_reboot() {
	echo ""
	log_print "${C}Rebooting...${N}"
	setprop sys.powerctl reboot
	sleep 15
	log_handler "Rebooting failed."
	echo ""
	echo "That doesn't seem like it worked..."
	echo "Please reboot manually."
	echo ""
	exit 0
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

# Check if boot scripts ran during boot
script_ran_check() {
	POSTCHECK=0
	if [ -f "$RUNFILE" ] && [ "$(grep "post-fs-data.sh module script finished" $RUNFILE)" ]; then
		POSTCHECK=1
	fi
	LATECHECK=0
	if [ -f "$RUNFILE" ] && [ "$(grep "service.sh module script finished" $RUNFILE)" ]; then
		LATECHECK=1
	fi
}

# Check for original prop values
orig_check() {
	PROPSTMPLIST=$VALPROPSLIST
	ORIGLOAD=0
	for PROPTYPE in $PROPSTMPLIST; do
		PROP=$(get_prop_type $PROPTYPE)
		ORIGPROP=$(echo "ORIG${PROP}" | tr '[:lower:]' '[:upper:]')
		ORIGVALUE="$(echo ${ORIGPROP})"
		if [ "$ORIGVALUE" ]; then
			ORIGLOAD=1
		fi
	done
}

# Load currently set values
curr_values() {
	for ITEM in $VALPROPSLIST; do
		CURRTMP=$(resetprop -v $ITEM) >> $LOGFILE 2>&1
		TMPPROP=$(get_prop_type $ITEM | tr '[:lower:]' '[:upper:]')
		eval "CURR${TMPPROP}='$CURRTMP'"
	done
	if [ -z "$CURRFINGERPRINT" ]; then
		CURRFINGERPRINT=$(resetprop -v ro.bootimage.build.fingerprint) >> $LOGFILE 2>&1
		if [ -z "$CURRFINGERPRINT" ]; then
			CURRFINGERPRINT=$(resetprop -v ro.vendor.build.fingerprint) >> $LOGFILE 2>&1
		fi
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

# Run all value loading functions
all_values() {
	log_handler "Loading values."
	# Currently set values
	curr_values
	# Module saved values
	. $LATEFILE
}

# Run after updated props/settings
after_change() {
	if [ "$2" == "file" ]; then
		# Load module settings
		. $LATEFILE
	else
		# Update the reboot variable
		reboot_chk
		# Load all values
		all_values
		# Ask to reboot
		reboot_fn "$1" "$2"
	fi
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
	cp -af $MODPATH/propsconf_late $LATEFILE >> $LOGFILE 2>&1
	if [ "$BUILDPROPENB" ] && [ "$BUILDPROPENB" != 1 ]; then
		replace_fn BUILDPROPENB 1 $BUILDPROPENB $LATEFILE
	fi
	if [ "$FINGERPRINTENB" ] && [ "$FINGERPRINTENB" != 1 ]; then
		replace_fn FINGERPRINTENB 1 $FINGERPRINTENB $LATEFILE
	fi
	chmod -v 755 $LATEFILE >> $LOGFILE 2>&1
	placeholder_update $LATEFILE CACHELOC CACHE_PLACEHOLDER "$CACHELOC"
	placeholder_update $LATEFILE COREPATH CORE_PLACEHOLDER "$COREPATH"

	if [ "$1" != "post" ]; then
		# Update the reboot variable
		reboot_chk
		# Update all prop value variables
		all_values
	fi
}

# Checks for configuration file
config_file() {
	log_handler "Checking for configuration file."
	CONFFILE=""
	for ITEM in $CONFFILELST; do
		if [ -s "$ITEM" ]; then
			CONFFILE="$ITEM"
			break
		fi
	done
	if [ "$CONFFILE" ]; then
		log_handler "Configuration file detected (${CONFFILE})."
		format_file $CONFFILE
		# Loads custom variables
		. $CONFFILE
		module_v_ctrl
		if [ "$CONFTRANSF" -le $VERSIONCMP ]; then
			# Check if vendor fingerprint is set
			if [ "$CONFVENDPRINT" == "true" ]; then
				log_handler "Using vendor fingerprint"
				CONFFINGERPRINT=$(resetprop -v ro.vendor.build.fingerprint) >> $LOGFILE 2>&1
			fi
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
							if [ "$FINGERPRINTENB" == 1 ]; then
								change_print "$PROPTYPE" "$TMPPROP" "file"
							fi
						else
							change_prop "$PROPTYPE" "$TMPPROP" "file"
						fi
					fi
				else
					if [ "$PROPTYPE" == "ro.build.fingerprint" ]; then
						if [ "$FINGERPRINTENB" == 1 ]; then
							reset_print "$PROPTYPE" "file"
						fi
					else
						reset_prop "$PROPTYPE" "file"
					fi
				fi
			done

			# Updates device simulation options, only if fingerprint editing is enabled
			if [ "$PRINTEDIT" == 1 ]; then
				# Fingerprint parts
				if [ "$CONFDEVSIM" == "true" ]; then
					change_dev_sim "Device simulation" "file"
					for ITEM in $PRINTPARTS; do
						TMPVAR="CONF$(get_prop_type $ITEM | tr '[:lower:]' '[:upper:]')"
						if [ $(eval "echo \$$TMPVAR") == "true" ]; then
							TMPVAL=1
						else
							TMPVAL=0
						fi
						change_sim_prop "Device simulation" "$ITEM" "$TMPVAL" "file"
					done
				fi
				# Device description
				if [ "$CONFDESCRIPTION" == "true" ]; then
					change_sim_descr "Device simulation" 1 "file"
				else
					change_sim_descr "Device simulation" 0 "file"
				fi
			fi

			# Updates prop file editing
			if [ "$FILESAFE" == 0 ]; then
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
			if [ "$CONFLATE" == "true" ]; then
				OPTLCHNG=1
				TMPTXT="late_start service"
			else
				OPTLCHNG=0
				TMPTXT="post-fs-data"
			fi
			replace_fn OPTIONLATE $OPTIONLATE $OPTLCHNG $LATEFILE
			log_handler "Boot stage is ${TMPTXT}."
			if [ "$CONFCOLOUR" == "true" ]; then
				OPTCCHNG=1
			else
				OPTCCHNG=0
			fi
			replace_fn OPTIONCOLOUR $OPTIONCOLOUR $OPTCCHNG $LATEFILE
			log_handler "Colour $CONFCOLOUR."
			if [ "$CONFWEB" == "true" ]; then
				OPTWCHNG=1
			else
				OPTWCHNG=0
			fi
			replace_fn OPTIONWEB $OPTIONWEB $OPTWCHNG $LATEFILE
			log_handler "Automatic fingerprints list update $CONFWEB."
		else
			log_handler "The configuration file is not compatible with the current module version."
		fi

		# Deletes the configuration file
		log_handler "Deleting configuration file."
		rm -f $CONFFILE
		log_handler "Configuration file import complete."
		
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
	if [ "$FINGERPRINTENB" == 1 -o "$PRINTMODULE" == 0 ] && [ "$PRINTEDIT" == 1 ]; then
		log_handler "Changing fingerprint."
		if [ "$PRINTVEND" == 1 ]; then
			log_handler "Using vendor fingerprint (for Treble GSI ROMs)."
			PRINTCHNG="$(resetprop ro.vendor.build.fingerprint)"
			# Set device simulation variables
			print_parts "$PRINTCHNG"
		else
			PRINTCHNG="$(echo $MODULEFINGERPRINT | sed 's|\_\_.*||')"
		fi
		for ITEM in $PRINTPROPS; do
			log_handler "Changing/writing $ITEM."
			resetprop -v $ITEM >> $LOGFILE 2>&1
			resetprop -nv $ITEM $PRINTCHNG >> $LOGFILE 2>&1
		done
		# Edit security patch date if included
		if [ "$PRINTVEND" != 1 ]; then
			SECPATCH="$(get_sec_patch $MODULEFINGERPRINT)"
			case "$MODULEFINGERPRINT" in
				*__*)
					if [ "$SECPATCH" ]; then
						log_handler "Updating security patch date to match fingerprint used."
						resetprop -v ro.build.version.security_patch >> $LOGFILE 2>&1
						resetprop -nv ro.build.version.security_patch $SECPATCH >> $LOGFILE 2>&1
					fi
				;;
			esac
		fi
		# Edit device description
		if [ "$DESCRIPTIONSET" == 1 ]; then
			if [ "$SIMDESCRIPTION" ]; then
				log_handler "Changing/writing ro.build.description."
				resetprop -v ro.build.description >> $LOGFILE 2>&1
				resetprop -nv ro.build.description "$SIMDESCRIPTION" >> $LOGFILE 2>&1
			fi
		else
			log_handler "Changing/writing ro.build.description is disabled."
		fi
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
		grep $OEM >> $PRINTFILES/${OEM}\.sh $PRINTSLOC
		echo -e "\"" >> $PRINTFILES/${OEM}\.sh
	done
	# Check for updated fingerprint
	device_print_update "Updating module fingerprint."
}

device_print_update() {
	if [ "$OPTIONUPDATE" == 1 ]; then
		if [ "$FINGERPRINTENB" == 1 -o "$PRINTMODULE" == 0 ] && [ "$PRINTEDIT" == 1 ] && [ "$MODULEFINGERPRINT" ]; then
			TMPDEV="${SIMBRAND}/${SIMNAME}/${SIMDEVICE}"
			for ITEM in $PRINTSLIST; do
				case $ITEM in
					*$TMPDEV*)
						TMPPRINT=$ITEM
						break
					;;
				esac
			done
			log_handler "Checking for updated fingerprint ($TMPDEV)."
			if [ "$TMPDEV" ] && [ "$TMPPRINT" ]; then
				if [ "$MODULEFINGERPRINT" != "$(get_eq_right $TMPPRINT))" ]; then
					log_handler "$1"
					change_print "$1" $(get_eq_right $TMPPRINT) "update"
					replace_fn PRINTCHK 0 1 $LATEFILE
					# Load module values
					. $LATEFILE
				else
					log_handler "No update available."
				fi
			fi
		fi
	fi
}

# Checks and updates the prints list
download_prints() {
	if [ -z "$LOGNAME" ] && [ "$DEVTESTING" == "false" ]; then
		clear
	fi
	if [ "$1" == "Dev" ]; then
		PRINTSWWW=$PRINTSDEV
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
					module_v_ctrl
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

	# Saves new module valueS
	replace_fn MODULEFINGERPRINT "\"$MODULEFINGERPRINT\"" "\"\"" $LATEFILE
	# Updates vendor print setting
	replace_fn PRINTVEND 1 0 $LATEFILE
	# Updates prop change variables in propsconf_late
	replace_fn PRINTEDIT 1 0 $LATEFILE
	# Updates improved hiding setting
	replace_fn SETFINGERPRINT "true" "false" $LATEFILE
	# Updates simulation setting
	replace_fn DEVSIM 1 0 $LATEFILE

	# Clear out device simulation variables
	print_parts "none"

	after_change "$1" "$2"
}

# Use fingerprint
change_print() {
	log_handler "Changing device fingerprint to $2."

	# Saves new module values
	replace_fn MODULEFINGERPRINT "\"$MODULEFINGERPRINT\"" "\"$2\"" $LATEFILE
	
	# Updates prop change variables in propsconf_late
	replace_fn PRINTEDIT 0 1 $LATEFILE
	# Updates improved hiding setting
	replace_fn SETFINGERPRINT "false" "true" $LATEFILE

	# Set device simulation variables
	print_parts "$2"

	NEWFINGERPRINT=""

	if [ "$DEVSIM" == 1 ]; then
		after_change "$1" "$3"
	fi
}

# Use vendor fingerprint
change_print_vendor() {
	if [ $2 == 1 ]; then
		STATETXT="Enabling"
		TMPVAL=0
		BUILD1="false"
		BUILD2="true"
	else
		STATETXT="Disabling"
		TMPVAL=1
		BUILD1="true"
		BUILD2="false"
	fi

	log_handler "$STATETXT using the stock vendor fingerprint (for Treble GSI ROMs)."

	# Enables or disables the setting
	replace_fn PRINTVEND $TMPVAL $2 $LATEFILE
	# Updates prop change variables in propsconf_late
	replace_fn PRINTEDIT $TMPVAL $2 $LATEFILE
	# Clearing out module value
	replace_fn MODULEFINGERPRINT "\"$MODULEFINGERPRINT\"" "\"\"" $LATEFILE
	# Updates improved hiding setting
	replace_fn SETFINGERPRINT $BUILD1 $BUILD2 $LATEFILE
	# Updates simulation setting
	replace_fn DEVSIM $TMPVAL $2 $LATEFILE

	# Set device simulation variables
	print_parts "$ORIGVENDPRINT"

	if [ "$DEVSIM" == 1 ]; then
		after_change "$1" "$3"
	fi
}

# Save props values from fingerprint parts
print_parts() {
	DLIM1=1
	DLIM2=1
	for ITEM in $PRINTPARTS; do
		TMPVALUE=""
		TMPPROP=$(get_prop_type $ITEM | tr '[:lower:]' '[:upper:]')
		if [ $1 != "none" ]; then
			TMPVALUE=$(echo $1 | sed 's|\:user\/release-keys||' | cut -f $DLIM1 -d ':' | cut -f $DLIM2 -d '/')
			eval "VAR${TMPPROP}='$TMPVALUE'"
		fi
		DLIM2=$(($DLIM2 + 1))
		if [ "$DLIM2" == 4 ]; then
			DLIM1=2
			DLIM2=1
		fi
		if [ "$2" != "var" ]; then
			SUBA=$(get_file_value $LATEFILE "SIM${TMPPROP}=")
			replace_fn "SIM${TMPPROP}" "\"$SUBA\"" "\"$TMPVALUE\"" $LATEFILE
		fi
	done

	VARDESCRIPTION=""
	if [ $1 != "none" ]; then
		VARDESCRIPTION="${VARNAME}-user $VARRELEASE $VARID $VARINCREMENTAL release-keys"
	fi
	if [ "$2" != "var" ]; then
		replace_fn SIMDESCRIPTION "\"$SIMDESCRIPTION\"" "\"$VARDESCRIPTION\"" $LATEFILE
	fi
	# Load module values
	. $LATEFILE
}

# ======================== Device simulation functions ========================
# Edit the simulation props
dev_sim_edit() {
	if [ "$FINGERPRINTENB" == 1 -o "$PRINTMODULE" == 0 ] && [ "$PRINTEDIT" == 1 ]; then
		if [ "$DEVSIM" == 1 ]; then
			log_handler "Editing device simulation props."
			for ITEM in $PRINTPARTS; do
				TMPPROP=$(get_prop_type $ITEM | tr '[:lower:]' '[:upper:]')
				TMPENB=$(get_file_value $LATEFILE "${TMPPROP}SET=")
				TMPVALUE=$(get_file_value $LATEFILE "SIM${TMPPROP}=")
				if [ "$TMPENB" == 1 ] && [ "$TMPVALUE" ]; then
					log_handler "Changing/writing $ITEM."
					resetprop -v $ITEM >> $LOGFILE 2>&1
					resetprop -nv $ITEM $TMPVALUE >> $LOGFILE 2>&1
				else
					log_handler "Changing/writing $ITEM is disabled."
				fi
			done
		fi
	fi
	
}

# Enable/disable the option
change_dev_sim() {
	if [ $DEVSIM == 0 ]; then
		STATETXT="Enabling"
		TMPVAL=1
	else
		STATETXT="Disabling"
		TMPVAL=0
	fi

	log_handler "$STATETXT basic device simulation."

	# Enables or disables the setting
	replace_fn "DEVSIM" $DEVSIM $TMPVAL $LATEFILE

	after_change "$1" "$2"
}

# Change if prop should be simulated or not
change_sim_prop() {
	if [ $3 == 1 ]; then
		STATETXT="enabled"
	else
		STATETXT="disabled"
	fi
	log_handler "Changing device simulation prop $2 to $STATETXT."

	TMPPROP=$(get_prop_type $2 | tr '[:lower:]' '[:upper:]')
	SUBA=$(get_file_value $LATEFILE "${TMPPROP}SET=")

	# Saves new value
	replace_fn "${TMPPROP}SET" $SUBA $3 $LATEFILE

	after_change "$1" "$4"
}

# Change if description should be simulated or not
change_sim_descr() {
	if [ $2 == 1 ]; then
		STATETXT="enabled"
	else
		STATETXT="disabled"
	fi
	log_handler "Changing device description editing to $STATETXT."

	# Saves new value
	replace_fn DESCRIPTIONSET $DESCRIPTIONSET $2 $LATEFILE

	after_change "$1" "$3"
}

# ======================== Props files functions ========================
# Reset prop files
reset_prop_files() {
	log_handler "Resetting prop files$3."

	# Changes files
	for PROPTYPE in $PROPSLIST; do
		log_handler "Disabling prop file editing for '$PROPTYPE'."
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
	if [ "$BUILDPROPENB" == 0 ]; then
		log_handler "Editing build.prop is disabled. Only editing default.prop."		
		PROPSLIST="
		ro.debuggable
		ro.secure
		"
	else
		# Checking if the device fingerprint is set by the module
		if [ "$FINGERPRINTENB" == 1 ] && [ "$PRINTEDIT" == 1 ]; then
			if [ "$(grep "$ORIGFINGERPRINT" $MIRRORLOC/build.prop)" ]; then
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
				PROPVALUE=$(get_file_value $MIRRORLOC/build.prop "${PROPTYPE}=")
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
	if [ "$SUBA" ]; then
		if [ "$PROPCOUNT" -gt 0 ]; then
			PROPCOUNTP=$(($PROPCOUNT-1))
			replace_fn PROPCOUNT $PROPCOUNT $PROPCOUNTP $LATEFILE
		fi
	fi
	if [ "$PROPCOUNT" == 0 ]; then
		replace_fn PROPEDIT 1 0 $LATEFILE
	fi

	after_change "$1" "$2"
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
		PROPCOUNTP=$(($PROPCOUNT+1))
		replace_fn PROPCOUNT $PROPCOUNT $PROPCOUNTP $LATEFILE
	fi
	replace_fn PROPEDIT 0 1 $LATEFILE

	after_change "$1" "$3"
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
	replace_fn PROPCOUNT $PROPCOUNT 0 $LATEFILE
	replace_fn PROPEDIT 1 0 $LATEFILE

	after_change "$1"
}

# ======================== Custom Props functions ========================
# Set custom props
custom_edit() {
	if [ "$1" ] && [ "$CUSTOMEDIT" == 1 ]; then
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
		# Reset the prop
		reset_custprop "$1" "$(resetprop $1)" "bootstage"
		# Set the prop
		PROPSBOOTSTAGE="CUSTOMPROPS"
		PROPSTXT="default"
		if [ "$3" == "post" ]; then
			PROPSBOOTSTAGE="CUSTOMPROPSPOST"
			PROPSTXT="post-fs-data"
		elif [ "$3" == "late" ]; then
			PROPSBOOTSTAGE="CUSTOMPROPSLATE"
			PROPSTXT="late_start service"
		elif [ "$3" == "both" ]; then
			PROPSBOOTSTAGE="CUSTOMPROPSPOST CUSTOMPROPSLATE"
			PROPSTXT="post-fs-data/late_start service"
		fi
		TMPVALUE=$(echo "$2" | sed 's| |_sp_|g')
		TMPORIG=$(echo "$4" | sed 's| |_sp_|g')
		DLIMTMP=1
		for ITEM in $PROPSBOOTSTAGE; do
			CURRCUSTPROPS=$(get_file_value $LATEFILE "${ITEM}=")
			case "$CURRCUSTPROPS" in
				*$1*)
					TMPCUSTPROPS=$(echo "$CURRCUSTPROPS" | sed "s|${1}=${TMPORIG}|${1}=${TMPVALUE}|")
				;;
				*)
					TMPCUSTPROPS=$(echo "$CURRCUSTPROPS  ${1}=${TMPVALUE}" | sed 's|^[ \t]*||')
				;;
			esac
			SORTCUSTPROPS=$(echo $(printf '%s\n' $TMPCUSTPROPS | sort -u))

			log_handler "Setting custom prop $1 in $(echo $PROPSTXT | cut -f $DLIMTMP -d '/') stage."
			replace_fn $ITEM "\"$CURRCUSTPROPS\"" "\"$SORTCUSTPROPS\"" $LATEFILE
			replace_fn CUSTOMEDIT 0 1 $LATEFILE
			DLIMTMP=$(($DLIMTMP + 1))
		done

		after_change "$1" "$4"
	fi
}

# Reset all custom prop values
reset_all_custprop() {
	log_handler "Resetting all custom props."
	# Removing all custom props
	replace_fn CUSTOMPROPS "\"$CUSTOMPROPS\"" "\"\"" $LATEFILE
	replace_fn CUSTOMPROPSPOST "\"$CUSTOMPROPSPOST\"" "\"\"" $LATEFILE
	replace_fn CUSTOMPROPSLATE "\"$CUSTOMPROPSLATE\"" "\"\"" $LATEFILE
	replace_fn CUSTOMEDIT 1 0 $LATEFILE

	after_change "Resetting all custom props" "$1"
}

# Reset custom prop value
reset_custprop() {
	log_handler "Resetting custom prop $1."
	PROPSBOOTSTAGE="CUSTOMPROPS CUSTOMPROPSPOST CUSTOMPROPSLATE"
	TMPVALUE=$(echo "$2" | sed 's| |_sp_|g')

	for ITEM in $PROPSBOOTSTAGE; do
		CURRCUSTPROPS=$(get_file_value $LATEFILE "${ITEM}=")
		TMPCUSTPROPS=$(echo $CURRCUSTPROPS | sed "s|${1}=${TMPVALUE}||" | tr -s " " | sed 's|^[ \t]*||')
		# Updating custom props string
		replace_fn $ITEM "\"$CURRCUSTPROPS\"" "\"$TMPCUSTPROPS\"" $LATEFILE
	done

	if [ -z "$CUSTOMPROPS" ] && [ -z "$CUSTOMPROPSPOST" ] && [ -z "$CUSTOMPROPSLATE" ]; then
		replace_fn CUSTOMEDIT 1 0 $LATEFILE
	fi

	if [ "$3" != "bootstage" ]; then
		after_change "$1"
	fi
}

# ======================== Delete Props functions ========================
# Delete props
prop_del() {
	if [ "$DELEDIT" == 1 ]; then
		log_handler "Deleting props."
		for ITEM in $DELETEPROPS; do			
			log_handler "Deleting $ITEM."
			TMPITEM=$( echo $(get_eq_right "$ITEM") | sed 's|_sp_| |g')
			resetprop -v $ITEM >> $LOGFILE 2>&1
			case "$ITEM" in
				persist*)
					resetprop -pv --delete $ITEM >> $LOGFILE 2>&1
				;;
				*)
					resetprop -v --delete $ITEM >> $LOGFILE 2>&1
				;;
			esac
		done
	fi
}

# Set prop to delete
set_delprop() {
	if [ "$1" ]; then
		TMPDELPROPS=$(echo "$DELETEPROPS  ${1}" | sed 's|^[ \t]*||')
		SORTDELPROPS=$(echo $(printf '%s\n' $TMPDELPROPS | sort -u))

		log_handler "Setting prop to delete, $1."
		replace_fn DELETEPROPS "\"$DELETEPROPS\"" "\"$SORTDELPROPS\"" $LATEFILE
		replace_fn DELEDIT 0 1 $LATEFILE

		after_change "Delete $1" "$2"
	fi
}

# Reset all props to delete
reset_all_delprop() {
	log_handler "Resetting list of props to delete."
	# Removing all props to delete
	replace_fn DELETEPROPS "\"$DELETEPROPS\"" "\"\"" $LATEFILE
	replace_fn DELEDIT 1 0 $LATEFILE

	after_change "Delete $1" "$2"
}

# Reset prop to delete
reset_delprop() {
	log_handler "Resetting prop to delete, $1."
	TMPDELPROPS=$(echo $DELETEPROPS | sed "s|${1}||" | tr -s " " | sed 's|^[ \t]*||')

	# Resetting prop to delete
	replace_fn DELETEPROPS "\"$DELETEPROPS\"" "\"$TMPDELPROPS\"" $LATEFILE
	# Loading new value
	. $LATEFILE
	if [ -z "$DELETEPROPS" ]; then
		replace_fn DELEDIT 1 0 $LATEFILE
	fi

	after_change "Delete $1" "$2"
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
				*build.prop*) BPNAME="build_$(echo $ITEM | sed 's|\/build.prop||' | sed 's|.*\/||g').prop"
				;;
				*) BPNAME=""
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
				*) log_handler "$ITEM not available."
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
