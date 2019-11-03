#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

# Finding file values
get_file_value() {
	if [ -f "$1" ]; then
		grep $2 $1 | sed "s|.*${2}||" | sed 's|\"||g'
	fi
}

# ======================== Variables ========================
ADBPATH=/data/adb
MODULESPATH=$ADBPATH/modules
MHPCPATH=$ADBPATH/mhpc
if [ "$INSTFN" ]; then
	# Installation (config.sh)
	MODVERSION=$(echo $(get_file_value $TMPDIR/module.prop "version=") | sed 's|-.*||')	
	POSTPATH=$ADBPATH/post-fs-data.d
	SERVICEPATH=$ADBPATH/service.d
	LATEFILE=$MHPCPATH/propsconf_late
	POSTFILE=$POSTPATH/propsconf_post
	POSTLATEFILE=$POSTPATH/propsconf_late
	UPDATELATEFILE=$TMPDIR/propsconf_late
	MIRRORLOC=/sbin/.magisk/mirror/system
	VENDLOC=/sbin/.magisk/mirror/vendor
	if [ -z $SLOT ]; then
		CACHELOC=/cache
	else
		CACHELOC=/data/cache
	fi
	CACHERM="
	$CACHELOC/propsconf_postfile.log
	$CACHELOC/propsconf.log
	$CACHELOC/propsconf_install.log
	$CACHELOC/propsconf_last.log
	"
	LOGFILE=$MHPCPATH/propsconf_install.log
	SETTINGSLIST="
	FINGERPRINTENB
	PRINTMODULE
	PRINTEDIT
	PRINTVEND
	PRINTCHK
	DEVSIM
	PROPCOUNT
	PROPEDIT
	CUSTOMEDIT
	DELEDIT
	PRINTSTAGE
	PATCHSTAGE
	SIMSTAGE
	OPTIONBOOT
	OPTIONCOLOUR
	OPTIONWEB
	OPTIONUPDATE
	BRANDSET
	NAMESET
	DEVICESET
	RELEASESET
	IDSET
	INCREMENTALSET
	DESCRIPTIONSET
	DISPLAYSET
	SDKSET
	REBOOTCHK
	"
	PROPSETTINGSLIST="
	MODULEDEBUGGABLE
	MODULESECURE
	MODULETYPE
	MODULETAGS
	MODULESELINUX
	MODULEFINGERPRINT
	SIMBRAND
	SIMNAME
	SIMDEVICE
	SIMRELEASE
	SIMID
	SIMINCREMENTAL
	SIMDESCRIPTION
	SIMDISPLAY
	SIMSDK
	CUSTOMPROPS
	CUSTOMPROPSPOST
	CUSTOMPROPSLATE
	CUSTOMPROPSDELAY
	DELETEPROPS
	"
else
	# Placeholder variables
	MODVERSIONPH=VER_PLACEHOLDER
	MHPCPATHPH=MHPCPATH_PLACEHOLDER
	LATEFILEPH=LATE_PLACEHOLDER
	MIRRORLOCPH=MIRROR_PLACEHOLDER
	VENDLOCPH=VEND_PLACEHOLDER
	CACHELOCPH=CACHE_PLACEHOLDER
	BINPH=BIN_PLACEHOLDER

	# Log variables
	LOGFILE=$MHPCPATH/propsconf.log
	LASTLOGFILE=$MHPCPATH/propsconf_last.log
	TMPLOGLOC=$MHPCPATH/propslogs
	TMPLOGLIST="
	$MHPCPATH/defaultprops
	$CACHELOC/magisk.log
	$CACHELOC/magisk.log.bak
	$MHPCPATH/propsconf*
	$MIRRORPATH/system/build.prop
	$MIRRORPATH/vendor/build.prop
	$LATEFILE
	"
fi

COREPATH=/sbin/.magisk
MIRRORPATH=$COREPATH/mirror
SYSTEMFILE=$MODPATH/system.prop
POSTCHKFILE=$MHPCPATH/propsconf_postchk
RUNFILE=$MODPATH/script_check
# Make sure that the terminal app used actually can see resetprop
if [ "$BOOTSTAGE" == "props" ]; then
	alias resetprop="$ADBPATH/magisk/magisk resetprop"
fi
alias reboot="/system/bin/reboot"
# Finding installed Busybox
if [ -d "$MODULESPATH/busybox-ndk" ]; then
	BBPATH=$(find $MODULESPATH/busybox-ndk -name 'busybox')
else
	BBPATH=$(which busybox)
fi
# Fingerprint variables
PRINTSLOC=$MODPATH/prints.sh
PRINTSTMP=$MHPCPATH/prints.sh
PRINTSWWW="https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/prints.sh"
PRINTSDEV="https://raw.githubusercontent.com/Didgeridoohan/Playground/master/prints.sh"
PRINTFILES=$MODPATH/printfiles
CSTMPRINTS=/sdcard/printslist
CSTMFILE=$PRINTFILES/Custom.sh

# Known modules that edit device fingerprint
USNFLIST="
xiaomi-safetynet-fix
safetynet-fingerprint-fix
VendingVisa
DeviceSpoofingTool4Magisk
universal-safetynet-fix
samodx-safetyskipper
safetypatcher
petnoires-safetyspoofer
VR_Patch
"

# Configuration file locations
CONFFILELST="
/data/media/0/propsconf_conf
/data/propsconf_conf
$CACHELOC/propsconf_conf
"

# Reset file locations
RESETFILELST="
/data/media/0/reset_mhpc
/data/reset_mhpc
$CACHELOC/reset_mhpc
"

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

# Additional simulation props
ADNSIMPROPS="
ro.build.display.id
ro.build.version.sdk
"

# Android API level
APILVL="
4.2=17
4.3=18
4.4=19
5.0=21
5.1=22
6.0=23
7.0=24
7.1=25
8.0=26
8.1=27
9=28
"

# Values props list
VALPROPSLIST=$PROPSLIST$PRINTPARTS$SNPROPS$ADNPROPS$ADNSIMPROPS

# Loading module settings
if [ -z "$INSTFN" ]; then
	. $LATEFILE
fi

# ======================== General functions ========================
# Log functions
log_handler() {
	if [ "$(id -u)" == 0 ] ; then
		echo "" >> $LOGFILE 2>&1
		echo -e "$(date +"%Y-%m-%d %H:%M:%S:%N") - $1" >> $LOGFILE 2>&1
	fi
}
# Saves the previous log (if available) and creates a new one
log_start() {
	if [ -f "$LOGFILE" ]; then
		if [ "$INSTFN" ]; then
			rm -f $LOGFILE
		else
			mv -f $LOGFILE $LASTLOGFILE
		fi
	fi
	touch $LOGFILE
	echo "***************************************************" >> $LOGFILE 2>&1
	echo "********* MagiskHide Props Config $MODVERSION ********" >> $LOGFILE 2>&1
	echo "***************** By Didgeridoohan ***************" >> $LOGFILE 2>&1
	echo "***************************************************" >> $LOGFILE 2>&1
	if [ "$INSTFN" ]; then
		log_handler "Starting module installation script"
	else
		log_script_chk "Log start."
	fi
}
log_print() {
	if [ "$INSTFN" ]; then
		ui_print "$1"
	else
		echo "$1"
	fi
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
	if [ -z "$ANDROID_SOCKET_adbd" ] && [ "$DEVTESTING" == "false" ]; then
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
	VERSIONCMP=$(echo $MODVERSION | sed 's|v||g' | sed 's|\.||g')
	VERSIONTMP=$(echo $(get_file_value $MODPATH/module.prop "version="))
}

# Check for Busybox
bb_check() {
	if [ "$BBPATH" ]; then
		log_handler "Using $($BBPATH | head -1)."
		echo "$BBPATH" >> $LOGFILE 2>&1
	else
		log_handler "No Busybox found."
	fi
}

# Find prop type
get_prop_type() {
	if [ "$1" == "ro.vendor.build.fingerprint" ]; then
		echo "vendprint"
	elif [ "$1" == "ro.build.display.id" ]; then
		echo "display"
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

# Get the list of print version
get_print_versions() {
	echo "$1" | sed 's|.*(||' | sed 's|).*||' | sed 's| \& | |g'
}

# Get Android version with 3 digits for input
get_android_version() {
	VERTMP=$(echo $1 | sed 's|\.||g')
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
	if [ "$5" == "placeholder" ]; then
		sed -i "s|${1}PH=${2}|${1}=${3}|" $4
	else
		sed -i "s|${1}=${2}|${1}=${3}|" $4
	fi
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
	echo "${C}Rebooting...${N}"
	log_handler "Rebooting."
	/system/bin/svc power reboot "" >> $LOGFILE 2>&1 || /system/bin/reboot "" >> $LOGFILE 2>&1 || setprop sys.powerctl reboot >> $LOGFILE 2>&1
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
	FILEVALUE=$(get_file_value $1 "${2}PH=")
	log_handler "Checking for ${3} in ${1}."
	if [ "$FILEVALUE" ]; then
		case $FILEVALUE in
			*PLACEHOLDER*)	replace_fn $2 $3 $4 $1 "placeholder"
							log_handler "Placeholder ${3} updated to ${4} in ${1}."
			;;
		esac
	else
		log_handler "No placeholder to update for ${2} in ${1}."
	fi
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

#Save default file values in propsconf_late
default_save(){
	#Format the props file
	log_handler "Formatting prop file."
	sed -i -e "s|\]\:\ \[|=|g;s|^\[||g;s|\]$||g" $MHPCPATH/defaultprops
	#Save the props values to $LATEFILE
	for ITEM in $VALPROPSLIST; do
		TMPPROP=$(get_prop_type $ITEM | tr '[:lower:]' '[:upper:]')
		ORIGPROP="ORIG${TMPPROP}"
		ORIGTMP="$(get_file_value $LATEFILE "${ORIGPROP}=")"
		CURRPROP="CURR${TMPPROP}"
		CURRTMP="$(get_file_value $MHPCPATH/defaultprops "${ITEM}=")"
		replace_fn $ORIGPROP "\"$ORIGTMP\"" "\"$CURRTMP\"" $LATEFILE
	done
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
		# Update the system.prop file
		system_prop
		if [ "$3" != "noreboot" ] && [ -z "$INSTFN" ]; then
			# Ask to reboot
			reboot_fn "$1" "$2"
		fi
	fi
}

# Run after editing prop files
after_change_propfile() {
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

# Reboot function
reboot_fn() {
	INPUT5=""
	while true
	do
		if [ -z "$INPUT5" ]; then
			if [ "$2" == "reboot" ] || [ "$2" == "reset-script" ] || [ "$2" == "update" ]; then
				REBOOTTXT=""
			else
				REBOOTTXT="Reboot - "
			fi
			menu_header "$REBOOTTXT${C}$1${N}"
			echo ""
			if  [ "$2" != "reset-script" ] && [ "$2" != "reboot" ]; then
				if [ "$2" == "update" ]; then
					echo "The device fingerprint has been updated."
					echo ""
				fi
				echo "Reboot for changes to take effect."
				echo ""
			fi
			echo "Do you want to reboot now (y/n)?"
			echo ""
			if [ "$2" == "p" ] || [ "$2" == "r" ] || [ "$2" == "reset-script" ]; then
				echo -n "Enter ${G}y${N}(es) or ${G}n${N}(o): "
				INV1=2
			else
				echo -n "Enter ${G}y${N}(es), ${G}n${N}(o) or ${G}e${N}(xit): "	
				INV1=3
			fi
			read -r INPUT5
		fi
		case "$INPUT5" in
			y|Y)
				force_reboot
			;;
			n|N)
				if [ "$2" == "p" ] || [ "$2" == "r" ] || [ "$2" == "reset-script" ]; then
					exit_fn
				else
					INPUT2=""
					INPUT3=""
					INPUT4=""
					INPUT5=""
					INPUT6=""
					break
				fi
			;;
			e|E)
				if [ "$2" == "p" ] || [ "$2" == "r" ] || [ "$2" == "reset-script" ]; then
					invalid_input $INV1 5
				else
					exit_fn
				fi
			;;
			*)	invalid_input $INV1 5
			;;
		esac
	done
}

# Reset module
reset_fn() {
	cp -af $MODPATH/propsconf_late $LATEFILE >> $LOGFILE 2>&1
	if [ "$FINGERPRINTENB" ] && [ "$FINGERPRINTENB" != 1 ]; then
		replace_fn FINGERPRINTENB 1 $FINGERPRINTENB $LATEFILE
	fi

	after_change "$1" "$2"
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

		if [ "$CONFTRANSF" ] && [ $CONFTRANSF -le $VERSIONCMP ]; then
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
					TMPPARTS=$PRINTPARTS$ADNSIMPROPS
					for ITEM in $TMPPARTS; do
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

			# Updates boot options for fingerprint and simulation props
			if [ "$PRINTEDIT" == 1 ]; then
				if [ "$CONFPRINTBOOT" == "default" ]; then
					OPTLCHNG=0
					TMPTXT="default"
				elif [ "$CONFPRINTBOOT" == "post" ]; then
					OPTLCHNG=1
					TMPTXT="post-fs-data"
				elif [ "$CONFPRINTBOOT" == "late" ]; then
					OPTLCHNG=2
					TMPTXT="late_start service"
				fi
				replace_fn PRINTSTAGE $PRINTSTAGE $OPTLCHNG $LATEFILE
				log_handler "Fingerprint boot stage is ${TMPTXT}."
				if [ "$CONFPATCHBOOT" == "default" ]; then
					OPTLCHNG=0
					TMPTXT="default"
				elif [ "$CONFPATCHBOOT" == "post" ]; then
					OPTLCHNG=1
					TMPTXT="post-fs-data"
				elif [ "$CONFPATCHBOOT" == "late" ]; then
					OPTLCHNG=2
					TMPTXT="late_start service"
				fi
				replace_fn PATCHSTAGE $PATCHSTAGE $OPTLCHNG $LATEFILE
				log_handler "Security patch boot stage is ${TMPTXT}."
			fi
			if [ "$DEVSIM" == 1 ]; then
				if [ "$CONFSIMBOOT" == "default" ]; then
					OPTLCHNG=0
					TMPTXT="default"
				elif [ "$CONFSIMBOOT" == "post" ]; then
					OPTLCHNG=1
					TMPTXT="post-fs-data"
				elif [ "$CONFSIMBOOT" == "late" ]; then
					OPTLCHNG=2
					TMPTXT="late_start service"
				fi
				replace_fn SIMSTAGE $SIMSTAGE $OPTLCHNG $LATEFILE
				log_handler "Device simulation boot stage is ${TMPTXT}."
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
			# Boot stage
			if [ "$CONFBOOT" == "default" ]; then
				OPTLCHNG=0
				TMPTXT="default"
			elif [ "$CONFBOOT" == "post" ]; then
				OPTLCHNG=1
				TMPTXT="post-fs-data"
			elif [ "$CONFBOOT" == "late" ]; then
				OPTLCHNG=2
				TMPTXT="late_start service"
			fi
			replace_fn OPTIONBOOT $OPTIONBOOT $OPTLCHNG $LATEFILE
			log_handler "General boot stage is ${TMPTXT}."
			# Script colours
			if [ "$CONFCOLOUR" == "true" ]; then
				OPTCCHNG=1
			else
				OPTCCHNG=0
			fi
			replace_fn OPTIONCOLOUR $OPTIONCOLOUR $OPTCCHNG $LATEFILE
			log_handler "Colour is set to $CONFCOLOUR."
			# Fingerprints list update
			if [ "$CONFWEB" == "true" ]; then
				OPTWCHNG=1
			else
				OPTWCHNG=0
			fi
			replace_fn OPTIONWEB $OPTIONWEB $OPTWCHNG $LATEFILE
			log_handler "Automatic fingerprints list update is set to $CONFWEB."
			# Automatic fingerprints update
			if [ "$CONFUPDATE" == "true" ]; then
				OPTFCHNG=1
			else
				OPTFCHNG=0
			fi
			replace_fn OPTIONUPDATE $OPTIONUPDATE $OPTFCHNG $LATEFILE
			log_handler "Automatic fingerprint update is set to $CONFUPDATE."
		else
			log_handler "The configuration file is not compatible with the current module version ($CONFTRANSF vs $VERSIONCMP)."
		fi

		# Update the system.prop file
		system_prop

		# Deletes the configuration file
		log_handler "Deleting configuration file."
		for ITEM in $CONFFILELST; do
			rm -f $ITEM
		done
		log_handler "Configuration file import complete."
	else
		log_handler "No configuration file."
	fi
}

# Connection test
test_connection() {
	ping -c 1 -W 1 google.com >> $LOGFILE 2>&1 && CNTTEST="true" || CNTTEST="false"
}

# system.prop creation
system_prop() {
	rm -f $MODPATH/system.prop
	if [ "$OPTIONBOOT" == 0 ]; then
		log_handler "Creating system.prop file."
		touch $MODPATH/system.prop >> $LOGFILE 2>&1
		echo -e "# This file will be read by resetprop\n\n# MagiskHide Props Config\n# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers\n# Licence: MIT\n" >> $MODPATH/system.prop
		if [ "$PRINTSTAGE" == 0 ]; then
			print_edit "$MODPATH/system.prop"
		fi
		if [ "$PATCHSTAGE" == 0 ]; then
			patch_edit "$MODPATH/system.prop"
		fi
		if [ "$SIMSTAGE" == 0 ]; then
			dev_sim_edit "$MODPATH/system.prop"
		fi
		if [ "$CUSTOMPROPS" ]; then
			custom_edit "CUSTOMPROPS" "$MODPATH/system.prop"
		fi
		# Check system.prop content
		system_prop_cont
	fi
}

# system.prop content
system_prop_cont() {
	if [ -f "$MODPATH/system.prop" ]; then
		log_handler "system.prop contents:"
		echo "----------------------------------------" >> $LOGFILE 2>&1
		cat $MODPATH/system.prop >> $LOGFILE 2>&1
		echo "----------------------------------------" >> $LOGFILE 2>&1
	else
		log_handler "No system.prop file present."
	fi
}

# ======================== Installation functions ========================
# Places various module scripts in their proper places
script_placement() {
	UPDATEV=$(get_file_value $UPDATELATEFILE "SCRIPTV=")
	UPDATETRANSF=$(get_file_value $UPDATELATEFILE "SETTRANSF=")
	NOTTRANSF=$(get_file_value $UPDATELATEFILE "NOTTRANSF=")
	if [ -f "$LATEFILE" ] && [ -d "$MODULESPATH/MagiskHidePropsConf" ]; then
		FILEV=$(get_file_value $LATEFILE "SCRIPTV=")
		FILETRANSF=$(get_file_value $LATEFILE "SETTRANSF=")
		LATEFILETMP="$LATEFILE"
	elif [ -f "$SERVICEPATH/propsconf_late" ]; then
		FILEV=$(get_file_value $SERVICEPATH/propsconf_late "SCRIPTV=")
		FILETRANSF=$(get_file_value $SERVICEPATH/propsconf_late "SETTRANSF=")
		LATEFILETMP="$SERVICEPATH/propsconf_late"
	else
		rm -f $LATEFILE
		FILEV=0
		FILETRANSF=$UPDATETRANSF
		LATEFILETMP="$LATEFILE"
	fi
	log_print "- Installing scripts"
	cp -af $TMPDIR/util_functions.sh $MODPATH/util_functions.sh >> $LOGFILE 2>&1
	cp -af $TMPDIR/prints.sh $MODPATH/prints.sh >> $LOGFILE 2>&1
	cp -af $UPDATELATEFILE $MODPATH/propsconf_late >> $LOGFILE 2>&1
	if [ "$FILEV" ]; then
		# New script
		if [ "$UPDATEV" -gt "$FILEV" ]; then
			# Fresh install
			if [ "$FILEV" == 0 ]; then
				log_print "- Placing settings script"
			# Updated script with a required clearing of settings
			elif [ "$UPDATETRANSF" -gt "$FILETRANSF" ] && [ ! "$NOTTRANSF" ]; then
				log_handler "Current transfer version - ${FILETRANSF}"
				log_handler "Update transfer version - ${UPDATETRANSF}"
				log_handler "No settings set to not transfer"
				log_print "- Script updated and settings cleared"
			# Updated script
			else
				log_print "- Script updated"
				log_print "- Transferring settings from old script"
				# Prop settings
				for ITEM in $SETTINGSLIST; do
					# Checking if a script update requires some options not to transfer
					case "$NOTTRANSF" in
						*$ITEM*)
							if [ "$UPDATETRANSF" -gt "$FILETRANSF" ]; then
								TRANSFOPT=1
							else
								TRANSFOPT=0
							fi
						;;
						*)
							TRANSFOPT=0
						;;
					esac
					if [ "$TRANSFOPT" == 1 ]; then
						log_handler "Not transfering settings for ${ITEM}."
					else
						SOLD=$(get_file_value $LATEFILETMP "${ITEM}=")
						SNEW=$(get_file_value $UPDATELATEFILE "${ITEM}=")
						if [ "$SOLD" ] && [ "$SOLD" != "$SNEW" ]; then
							log_handler "Setting ${ITEM} from ${SNEW} to ${SOLD}."
							sed -i "s|${ITEM}=${SNEW}|${ITEM}=${SOLD}|" $UPDATELATEFILE
						fi
					fi
				done
				# Prop values
				for ITEM in $PROPSETTINGSLIST; do
					SOLD=$(get_file_value $LATEFILETMP "${ITEM}=")
					if [ "$SOLD" ]; then
						log_handler "Setting ${ITEM} to ${SOLD}."
						sed -i "s|${ITEM}=\"\"|${ITEM}=\"${SOLD}\"|" $UPDATELATEFILE
					fi
				done
				# Prop and file edits
				for ITEM in $PROPSLIST; do
					ITEM="$(get_prop_type $ITEM)"
					REPROP=$(echo "RE${ITEM}" | tr '[:lower:]' '[:upper:]')
					SETPROP=$(echo "SET${ITEM}" | tr '[:lower:]' '[:upper:]')
					REOLD=$(get_file_value $LATEFILETMP "${REPROP}=")
					SETOLD=$(get_file_value $LATEFILETMP "${SETPROP}=")
					if [ "$REOLD" ] && [ "$REOLD" != "false" ]; then
						log_handler "Setting sensitive prop ${ITEM} to ${REOLD}."
						sed -i "s/${REPROP}=false/${REPROP}=${REOLD}/" $UPDATELATEFILE
					fi
					if [ "$SETOLD" ] && [ "$SETOLD" != "false" ]; then
						log_handler "Setting file edit ${ITEM} to ${SETOLD}."
						sed -i "s/${SETPROP}=false/${SETPROP}=${SETOLD}/" $UPDATELATEFILE
					fi
				done
			fi
			log_handler "Setting up late_start settings script."
			if [ ! -d "$MHPCPATH" ]; then
				mkdir -pv $MHPCPATH >> $LOGFILE 2>&1
			fi
			cp -af $UPDATELATEFILE $LATEFILE >> $LOGFILE 2>&1
		# Downgraded script (flashed old module version)
		elif [ "$UPDATEV" -lt "$FILEV" ]; then
			log_print "- Settings cleared (script downgraded)"
			if [ ! -d "$MHPCPATH" ]; then
				mkdir -pv $MHPCPATH >> $LOGFILE 2>&1
			fi
			cp -af $UPDATELATEFILE $LATEFILE >> $LOGFILE 2>&1
		# No update of script
		else
			log_print "- Module settings preserved"
		fi
	else
		log_print "- Placing settings script"
		log_handler "Setting up late_start settings script."
		if [ ! -d "$MHPCPATH" ]; then
			mkdir -pv $MHPCPATH >> $LOGFILE 2>&1
		fi
		cp -af $UPDATELATEFILE $LATEFILE >> $LOGFILE 2>&1
	fi
	if [ -f "$SERVICEPATH/propsconf_late" ]; then
		log_handler "Old settings file found in $SERVICEPATH."
		rm -f $SERVICEPATH/propsconf_late >> $LOGFILE 2>&1
	fi
}

# Checks for the Universal SafetyNet Fix module and similar modules editing device fingerprint
usnf_check() {
	log_print "- Checking for fingerprint conflicts"
	for USNF in $USNFLIST; do
		if [ -d "$MODULESPATH/$USNF" ]; then
			if [ ! -f "$MODULESPATH/$USNF/disable" ]; then
				NAME=$(get_file_value $MODULESPATH/$USNF/module.prop "name=")
				ui_print "!"
				log_print "! Module editing fingerprint detected!"
				log_print "! Module - '$NAME'!"
				log_print "! Fingerprint modification disabled!"
				ui_print "!"
				sed -i 's/FINGERPRINTENB=1/FINGERPRINTENB=0/' $UPDATELATEFILE
			fi
		fi
	done
}

# Check for bin/xbin
bin_check() {
	$BOOTMODE && BINCHECK=$COREPATH/mirror/system/xbin || BINCHECK=/system/xbin
	if [ -d "$BINCHECK" ]; then
		BIN=xbin
	else
		BIN=bin
	fi
	log_handler "Using /system/$BIN."
	mv -f $MODPATH/system/binpath $MODPATH/system/$BIN >> $LOGFILE 2>&1
}

# Function for removing screwed up and old files.
files_check() {
	if [ -f "$POSTLATEFILE" ]; then
		log_handler "Removing late_start service boot script from post-fs-data.d."
		rm -f $POSTLATEFILE
	fi
	if [ -f "$POSTFILE" ]; then
		log_handler "Removing old post-fs-data boot script from post-fs-data.d"
		rm -f $POSTFILE
	fi
	for ITEM in $CACHERM; do
		if [ -f "$ITEM" ]; then
			log_handler "Removing old log files ($ITEM)."
			rm -f $ITEM
		fi
	done
	if [ -f "" ]; then
		log_handler "Removing broken custom.sh file."
		$PRINTFILES/custom.sh
	fi
}

# Update the device simulation variables if a fingerprint is set
devsim_update() {
	if [ "$MODULEFINGERPRINT" ]; then
		log_handler "Updating device simulation variables."
		print_parts "$MODULEFINGERPRINT" "var"
		for ITEM in $PROPSETTINGSLIST; do
			case $ITEM in
				SIM*)
					SUBA="$(get_file_value $LATEFILE "${ITEM}=")"
					TMPVAR="$(echo $ITEM | sed 's|SIM|VAR|')"
					TMPPROP="$(eval "echo \$$TMPVAR")"
					sed -i "s|${ITEM}=\"${SUBA}\"|${ITEM}=\"${TMPPROP}\"|" $LATEFILE
				;;
			esac
		done
		# Reload module settings
		load_settings
	fi
}

# Load module settings and reapply the MODPATH variable
load_settings() {
	log_handler "Loading/reloading module settings."
	if [ -f "$LATEFILE" ]; then
		. $LATEFILE
	fi
}

# Installs everything
script_install() {
	load_settings
	usnf_check
	bin_check
	files_check
	script_placement
	log_print "- Updating placeholders"
	placeholder_update $MODPATH/util_functions.sh MODVERSION VER_PLACEHOLDER "$MODVERSION"
	placeholder_update $MODPATH/util_functions.sh LATEFILE LATE_PLACEHOLDER "$LATEFILE"
	placeholder_update $MODPATH/util_functions.sh MIRRORLOC MIRROR_PLACEHOLDER "$MIRRORLOC"
	placeholder_update $MODPATH/util_functions.sh VENDLOC VEND_PLACEHOLDER "$VENDLOC"
	placeholder_update $MODPATH/util_functions.sh CACHELOC CACHE_PLACEHOLDER "$CACHELOC"
	placeholder_update $MODPATH/util_functions.sh BIN BIN_PLACEHOLDER "$BIN"
	placeholder_update $MODPATH/system/$BIN/props ADBPATH ADB_PLACEHOLDER "$ADBPATH"
	placeholder_update $MODPATH/system/$BIN/props LATEFILE LATE_PLACEHOLDER "$LATEFILE"
	load_settings
	devsim_update
	print_files
	ui_print ""
	ui_print "- Make sure to have Busybox installed."
	ui_print "- osm0sis' Busybox is recommended."
	ui_print ""
	# Checks for configuration file
	CONFFILE=""
	for ITEM in $CONFFILELST; do
		if [ -s "$ITEM" ]; then
			CONFFILE="$ITEM"
			break
		fi
	done
	if [ "$CONFFILE" ]; then
		load_settings
		ui_print "- Configuration file found."
		ui_print "- Installing..."
		ui_print ""
		config_file
	else
		load_settings
		# Create system.prop in case of no configuration file
		system_prop
	fi
	log_handler "Module installation complete."
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
			if [ "$(resetprop $ITEM)" ]; then
				log_handler "Changing/writing $ITEM."
				if [ "$1" ]; then
					echo "${ITEM}=${PRINTCHNG}" >> $1
				else
					resetprop -nv $ITEM $PRINTCHNG >> $LOGFILE 2>&1
				fi
			else
				log_handler "$ITEM not currently set on device. Skipping."
			fi
		done
		# Edit device description
		if [ "$DESCRIPTIONSET" == 1 ]; then
			if [ "$SIMDESCRIPTION" ]; then
				log_handler "Changing/writing ro.build.description."
				if [ "$1" ]; then
					echo "ro.build.description=${SIMDESCRIPTION}" >> $1
				else
					resetprop -nv ro.build.description "$SIMDESCRIPTION" >> $LOGFILE 2>&1
				fi
			fi
		else
			log_handler "Changing/writing ro.build.description is disabled."
		fi
	fi
}

# Edit security patch date if included
patch_edit() {
	if [ "$PRINTVEND" != 1 ]; then
		case "$MODULEFINGERPRINT" in
			*__*)
				SECPATCH="$(get_sec_patch $MODULEFINGERPRINT)"
				if [ "$SECPATCH" ]; then
					log_handler "Updating security patch date to match fingerprint used."
					if [ "$1" ]; then
						echo "ro.build.version.security_patch=${SECPATCH}" >> $1
					else
						resetprop -nv ro.build.version.security_patch $SECPATCH >> $LOGFILE 2>&1
					fi
				fi
			;;
		esac
	fi
}

# Create fingerprint files
print_files() {
	if [ "$INSTFN" ]; then
		log_print "- Creating fingerprint files."
	else
		log_print "Creating fingerprint files."
	fi
	rm -rf $MODPATH/printfiles >> $LOGFILE 2>&1
	mkdir -pv $MODPATH/printfiles >> $LOGFILE 2>&1
	# Loading prints
	. $MODPATH/prints.sh
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
		echo -e "PRINTSLIST=\"" >> $MODPATH/printfiles/${OEM}\.sh
		grep $OEM >> $MODPATH/printfiles/${OEM}\.sh $MODPATH/prints.sh
		echo -e "\"" >> $MODPATH/printfiles/${OEM}\.sh
	done
	# Check for updated fingerprint
	device_print_update "Updating module fingerprint."
}

device_print_update() {
	log_handler "$1"
	if [ "$OPTIONUPDATE" == 1 ]; then
		if [ "$FINGERPRINTENB" == 1 -o "$PRINTMODULE" == 0 ] && [ "$PRINTEDIT" == 1 ] && [ "$MODULEFINGERPRINT" ]; then
			TMPDEV="${SIMBRAND}/${SIMNAME}/${SIMDEVICE}"
			SAVEIFS=$IFS
			IFS=$(echo -en "\n\b")
			for ITEM in $PRINTSLIST; do
				case $ITEM in
					*$TMPDEV*)
						IFS=$SAVEIFS
						case $ITEM in
							*\;*)
								ITEMCOUNT=1
								ITEMFOUND=0
								TMPVPRINT="$(get_print_versions "$(get_eq_left "$ITEM")")"
								TMPVCURR="$(get_android_version $SIMRELEASE)"
								for V in $TMPVPRINT; do
									if [ "$(get_android_version $V)" == "$TMPVCURR" ]; then
										ITEMFOUND=1
										break
									fi
									ITEMCOUNT=$(($ITEMCOUNT+1))
								done
								if [ "$ITEMFOUND" == 1 ]; then
									TMPPRINT="$(get_eq_right "$ITEM" | cut -f $ITEMCOUNT -d ';')"
								else
									TMPPRINT=""
								fi
							;;
							*) TMPPRINT="$(get_eq_right "$ITEM")"
							;;
						esac
						break
					;;
				esac
			done
			IFS=$SAVEIFS
			if [ "$TMPDEV" ] && [ "$TMPPRINT" ]; then
				log_handler "Checking for updated fingerprint ($TMPDEV).\nCurrent - $MODULEFINGERPRINT\nUpdate - $TMPPRINT"
				if [ "$MODULEFINGERPRINT" != "$TMPPRINT" ]; then
					change_print "$1" "$TMPPRINT" "update"
					replace_fn PRINTCHK 0 1 $LATEFILE
					# Load module values
					. $LATEFILE
				else
					log_handler "No update available."
				fi
			else
				log_handler "Can't check for update."
			fi
		fi
	fi
}

# Checks and updates the prints list
download_prints() {
	if [ -z "$ANDROID_SOCKET_adbd" ] && [ "$DEVTESTING" == "false" ]; then
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

	# Set device simulation variables
	print_parts "$2"

	NEWFINGERPRINT=""

	after_change "$1" "$3"
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
	# Updates simulation setting
	replace_fn DEVSIM $TMPVAL $2 $LATEFILE

	# Set device simulation variables
	print_parts "$ORIGVENDPRINT"

	after_change "$1" "$3"
}

# Save props values from fingerprint parts
print_parts() {
	DLIM1=1
	DLIM2=1
	for ITEM in $PRINTPARTS; do
		TMPVALUE=""
		TMPPROP=$(get_prop_type $ITEM | tr '[:lower:]' '[:upper:]')
		if [ $1 != "none" ]; then
			TMPVALUE=$(echo $1 | sed 's|\:user\/release-keys.*||' | cut -f $DLIM1 -d ':' | cut -f $DLIM2 -d '/')
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
	VARSDK=""
	if [ $1 != "none" ]; then
		VARDESCRIPTION="${VARNAME}-user $VARRELEASE $VARID $VARINCREMENTAL release-keys"
		for ITEM in $APILVL; do
			case $VARRELEASE in
				*$(get_eq_left $ITEM)*)
					VARSDK="$(get_eq_right $ITEM)"
					break
				;;
			esac
		done
	fi
	if [ "$2" != "var" ]; then
		replace_fn SIMDESCRIPTION "\"$SIMDESCRIPTION\"" "\"$VARDESCRIPTION\"" $LATEFILE
		replace_fn SIMDISPLAY "\"$SIMDISPLAY\"" "\"$VARDESCRIPTION\"" $LATEFILE
		replace_fn SIMSDK "\"$SIMSDK\"" "\"$VARSDK\"" $LATEFILE
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
			TMPPARTS=$PRINTPARTS$ADNSIMPROPS
			for ITEM in $TMPPARTS; do
				TMPPROP=$(get_prop_type $ITEM | tr '[:lower:]' '[:upper:]')
				TMPENB=$(get_file_value $LATEFILE "${TMPPROP}SET=")
				TMPVALUE=$(get_file_value $LATEFILE "SIM${TMPPROP}=")
				if [ "$TMPENB" == 1 ] && [ "$TMPVALUE" ]; then
					log_handler "Changing/writing $ITEM."
					if [ "$1" ]; then
						echo "${ITEM}=${TMPVALUE}" >> $1
					else
						resetprop -nv $ITEM $TMPVALUE >> $LOGFILE 2>&1
					fi
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
				TMPITEM=$(echo $(get_eq_right "$ITEM") | sed 's|_sp_| |g')
				if [ "$2" ]; then
					echo "$(get_eq_left "$ITEM")=${TMPITEM}" >> $2
				else
					resetprop -nv $(get_eq_left "$ITEM") "$TMPITEM" >> $LOGFILE 2>&1
				fi
			done
		fi
	fi
}

# Find custom props module set value
custprop_value() {
	TMPLST="$CUSTOMPROPSLIST"
	if [ "$TMPLST" ]; then
		for ITEM in $TMPLST; do
			case "$ITEM" in
				*$1*)
					echo $(get_eq_right "$ITEM" | sed 's|_sp_| |g')
				;;
			esac
		done
	fi
}

# Set custom prop value
set_custprop() {
	if [ "$2" ]; then
		# Reset the prop
		reset_custprop "$1" "$2" "bootstage"
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
					if [ "$(echo $CUSTOMPROPSLIST | grep -Eo "(^| )$1($| )")" ]; then
						TMPCUSTPROPS=$(echo "$CURRCUSTPROPS" | sed "s|${1}=${TMPORIG}|${1}=${TMPVALUE}|")
					else
						TMPCUSTPROPS=$(echo "$CURRCUSTPROPS ${1}=${TMPVALUE}" | sed 's|^[ \t]*||')
					fi
				;;
				*) TMPCUSTPROPS=$(echo "$CURRCUSTPROPS ${1}=${TMPVALUE}" | sed 's|^[ \t]*||')
				;;
			esac
			SORTCUSTPROPS=$(echo $(printf '%s\n' $TMPCUSTPROPS | sort -u))

			log_handler "Setting custom prop $1 in $(echo $PROPSTXT | cut -f $DLIMTMP -d '/') stage."
			replace_fn $ITEM "\"$CURRCUSTPROPS\"" "\"$SORTCUSTPROPS\"" $LATEFILE
			replace_fn CUSTOMEDIT 0 1 $LATEFILE
			DLIMTMP=$(($DLIMTMP + 1))

#			if [ "$ITEM" == "CUSTOMPROPSLATE" ] && [ "$(get_file_value $LATEFILE "CUSTOMEDIT=")" == 1 ]; then
#				case "$CURRCUSTPROPS" in
#					*$1*) #Do nothing when the prop already exists
#					;;
#					*)
#						CUSTOMPROPSLATE=$(get_file_value $LATEFILE "${ITEM}=")
#						CNTLITEM=1
#						FNDLITEM=0
#						for LITEM in $CUSTOMPROPSLATE
#							case "$CUSTOMPROPSLATE" in
#								*$1*)
#									$FNDLITEM=1
#									break
#								;;
#							esac
#							CNTLITEM=$(($CNTLITEM + 1))
#						done
#						if [ "$FNDLITEM" == 1 ]; then
#							CUSTOMPROPSDELAY=$(get_file_value $LATEFILE "CUSTOMPROPSDELAY=")
#							replace_fn CUSTOMPROPSDELAY "$CUSTOMPROPSDELAY" "$(echo "$CUSTOMPROPSDELAY" | cut -f 1-$CNTLITEM -d ';');0;$(echo "$CUSTOMPROPSDELAY" | cut -f $(($CNTLITEM + 1))- -d ';')" $LATEFILE
#						fi
#					;;
#				esac
#			fi
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
		TMPCUSTPROPS=$(echo $CURRCUSTPROPS | sed "s|${1}=${TMPVALUE}||" | tr -s " " | sed 's|^[ \t]*||;s|[ \t]*$||')
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

	after_change "Reset all props to delete." "$1"
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

	after_change "Reset prop to delete - $1"
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
			if [ "$ITEM" != "$MHPCPATH/propsconf.log" ]; then
				cp -af $ITEM ${TMPLOGLOC}/${BPNAME} >> $LOGFILE 2>&1
			fi
		else
			log_handler "$ITEM not available."
		fi
	done

	# Saving the current prop values
	resetprop > $TMPLOGLOC/props.txt

	# Saving the log file
	cp -af $MHPCPATH/propsconf.log $TMPLOGLOC >> $LOGFILE 2>&1

	# Package the files
	cd $MHPCPATH
	tar -zcvf propslogs.tar.gz propslogs >> $LOGFILE 2>&1

	# Copy package to internal storage
	mv -f $MHPCPATH/propslogs.tar.gz /storage/emulated/0 >> $LOGFILE 2>&1
	
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
if [ "$BOOTSTAGE" != "post" ]; then
	log_handler "Functions loaded."
	bb_check
fi
