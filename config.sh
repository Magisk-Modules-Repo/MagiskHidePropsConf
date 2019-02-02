##########################################################################################
#
# Magisk Module Template Config Script
# by topjohnwu
#
##########################################################################################
##########################################################################################
# Configs
##########################################################################################

AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=true
LATESTARTSERVICE=true

##########################################################################################
# Installation Message
##########################################################################################

print_modname() {
  MODVERSION=$(echo $(get_file_value $INSTALLER/module.prop "version=") | sed 's|-.*||')
  ui_print "*******************************"
  ui_print "MagiskHide Props Config $MODVERSION"
  ui_print "    By Didgeridoohan @XDA"
  ui_print "*******************************"
}

##########################################################################################
# Replace list
##########################################################################################

REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
  set_perm $MODPATH/system/$BIN/props 0 0 0777
  set_perm $LATEFILE 0 0 0755
}

##########################################################################################
# Installation variables and functions for the Magisk module "MagiskHide Props Config"
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers.
# Licence: MIT
##########################################################################################

# Finding file values
get_file_value() {
	grep $2 $1 | sed "s|.*$2||" | sed 's|\"||g'
}
# Get left side of =
get_eq_left() {
	echo $1 | cut -f 1 -d '='
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

# Variables
if [ "$MAGISK_VER_CODE" -ge 17316 ]; then
	COREPATH=/sbin/.magisk
else
	COREPATH=/sbin/.core
fi
ADBPATH=/data/adb
BIMGPATH=$COREPATH/img
$BOOTMODE && IMGPATH=$BIMGPATH || IMGPATH=$MOUNTPATH
if [ "$MAGISK_VER_CODE" -ge 17316 ]; then
	POSTPATH=$ADBPATH/post-fs-data.d
	SERVICEPATH=$ADBPATH/service.d
	LATEHOLDER=$ADBPATH/service.d/propsconf_late
else
	POSTPATH=$IMGPATH/.core/post-fs-data.d
	SERVICEPATH=$IMGPATH/.core/service.d
	LATEHOLDER=$BIMGPATH/.core/service.d/propsconf_late
fi
POSTFILE=$POSTPATH/propsconf_post
LATEFILE=$SERVICEPATH/propsconf_late
POSTLATEFILE=$POSTPATH/propsconf_late
UPDATELATEFILE=$INSTALLER/common/propsconf_late
MIRRORLOC=/sbin/.magisk/mirror/system
if [ -z $SLOT ]; then
	CACHELOC=/cache
else
	CACHELOC=/data/cache
fi
CONFFILELST="
$CACHELOC/propsconf_conf
/data/propsconf_conf
/sdcard/propsconf_conf
"
INSTLOG=$CACHELOC/propsconf_install.log
UPDATEV=$(get_file_value $UPDATELATEFILE "SCRIPTV=")
UPDATETRANSF=$(get_file_value $UPDATELATEFILE "SETTRANSF=")
NOTTRANSF=$(get_file_value $UPDATELATEFILE "NOTTRANSF=")
SETTINGSLIST="
FINGERPRINTENB
PRINTMODULE
PRINTEDIT
PRINTVEND
DEVSIM
BUILDPROPENB
FILESAFE
BUILDEDIT
DEFAULTEDIT
PROPCOUNT
PROPEDIT
CUSTOMEDIT
DELEDIT
REBOOTCHK
PRINTCHK
OPTIONLATE
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
CUSTOMPROPS
CUSTOMPROPSPOST
CUSTOMPROPSLATE
DELETEPROPS
"
PROPSLIST="
debuggable
secure
type
tags
selinux
fingerprint
"
USNFLIST="xiaomi-safetynet-fix safetynet-fingerprint-fix VendingVisa DeviceSpoofingTool4Magisk universal-safetynet-fix samodx-safetyskipper safetypatcher petnoires-safetyspoofer"

# Log functions
log_handler() {
	echo "" >> $INSTLOG
	echo -e "$(date +"%Y-%m-%d %H:%M:%S:%N") - $1" >> $INSTLOG 2>&1
}
log_start() {
	if [ -f "$INSTLOG" ]; then
		rm -f $INSTLOG
	fi
	touch $INSTLOG
	echo "***************************************************" >> $INSTLOG 2>&1
	echo "******** MagiskHide Props Config $MODVERSION ********" >> $INSTLOG 2>&1
	echo "**************** By Didgeridoohan ***************" >> $INSTLOG 2>&1
	echo "***************************************************" >> $INSTLOG 2>&1
	log_handler "Starting module installation script"
}
log_print() {
	ui_print "$1"
	log_handler "$1"
}

# Places various module scripts in their proper places
script_placement() {
	if [ -f "$LATEFILE" ]; then
		FILEV=$(get_file_value $LATEFILE "SCRIPTV=")
		FILETRANSF=$(get_file_value $LATEFILE "SETTRANSF=")
	else
		FILEV=0
		FILETRANSF=$UPDATETRANSF
	fi
	log_print "- Installing scripts"
	cp -af $INSTALLER/common/util_functions.sh $MODPATH/util_functions.sh >> $INSTLOG 2>&1
	cp -af $INSTALLER/common/prints.sh $MODPATH/prints.sh >> $INSTLOG 2>&1
	cp -af $UPDATELATEFILE $MODPATH/propsconf_late >> $INSTLOG 2>&1
	if [ "$FILEV" ]; then
		# New script
		if [ "$UPDATEV" -gt "$FILEV" ]; then
			# Fresh install
			if [ "$FILEV" == 0 ]; then
				log_print "- Placing settings script"
			# Updated script with a required clearing of settings
			elif [ "$UPDATETRANSF" -gt "$FILETRANSF" ] && [ -z "$NOTTRANSF" ]; then
				log_print "- Settings cleared (script updated)"
			# Updated script
			else
				log_print "- Script updated"
				log_print "- Transferring settings from old script"
				# Prop settings
				for ITEM in $SETTINGSLIST; do
					# Checking if a script update requires some options not to transfer
					case "$NOTTRANSF" in
						*${ITEM}*)						
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
						SOLD=$(get_file_value $LATEFILE "${ITEM}=")
						SNEW=$(get_file_value $UPDATELATEFILE "${ITEM}=")
						if [ "$SOLD" ] && [ "$SOLD" != "$SNEW" ]; then
							log_handler "Setting ${ITEM} from ${SNEW} to ${SOLD}."
							sed -i "s|${ITEM}=${SNEW}|${ITEM}=${SOLD}|" $UPDATELATEFILE
						fi
					fi
				done
				# Prop values
				for ITEM in $PROPSETTINGSLIST; do
					SOLD=$(get_file_value $LATEFILE "${ITEM}=")
					if [ "$SOLD" ]; then
						log_handler "Setting ${ITEM} to ${SOLD}."
						sed -i "s|${ITEM}=\"\"|${ITEM}=\"${SOLD}\"|" $UPDATELATEFILE
					fi
				done
				# Prop and file edits
				for ITEM in $PROPSLIST; do
					REPROP=$(echo "RE${ITEM}" | tr '[:lower:]' '[:upper:]')
					SETPROP=$(echo "SET${ITEM}" | tr '[:lower:]' '[:upper:]')
					REOLD=$(get_file_value $LATEFILE "${REPROP}=")
					SETOLD=$(get_file_value $LATEFILE "${SETPROP}=")
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
			cp -af $UPDATELATEFILE $LATEFILE >> $INSTLOG 2>&1
		# Downgraded script (flashed old module version)
		elif [ "$UPDATEV" -lt "$FILEV" ]; then
			log_print "- Settings cleared (script downgraded)"
			cp -af $UPDATELATEFILE $LATEFILE >> $INSTLOG 2>&1
		# No update of script
		else
			log_print "- Module settings preserved"
		fi
	else
		log_print "- Placing settings script"
		log_handler "Setting up late_start settings script."
		cp -af $UPDATELATEFILE $LATEFILE >> $INSTLOG 2>&1
	fi
}

# Create fingerprint files
print_files() {
	log_print "- Creating fingerprint files."
	rm -rf $MODPATH/printfiles >> $INSTLOG 2>&1
	mkdir -pv $MODPATH/printfiles >> $INSTLOG 2>&1
	# Loading prints
	. $MODPATH/prints.sh
	# Saving manufacturers
	log_handler "Saving manufacturers"
	SAVEIFS=$IFS
	IFS=$(echo -en "\n\b")
	for ITEM in $PRINTSLIST; do
		TMPOEMLIST=$(echo "$OEMLIST $(get_first $ITEM)" | sed 's|^[ \t]*||')
		OEMLIST="$TMPOEMLIST"
	done
	IFS=$SAVEIFS
	TMPOEMLIST=$(echo $(printf '%s\n' $OEMLIST | sort -u))
	OEMLIST="$TMPOEMLIST"
	log_handler "Creating files"
	for OEM in $OEMLIST; do
		echo -e "PRINTSLIST=\"" >> $MODPATH/printfiles/${OEM}\.sh
		grep $OEM >> $MODPATH/printfiles/${OEM}\.sh $MODPATH/prints.sh
		echo -e "\"" >> $MODPATH/printfiles/${OEM}\.sh
	done
	# Check for updated fingerprint
	device_print_update
}

device_print_update() {
	if [ "$OPTIONUPDATE" == 1 ]; then
		if [ "$FINGERPRINTENB" == 1 -o "$PRINTMODULE" == 0 ] && [ "$PRINTEDIT" == 1 ] && [ "$MODULEFINGERPRINT" ]; then
			TMPDEV="${VARBRAND}\.${VARNAME}\.${VARDEVICE}"
			TMPPRINT=$(echo $PRINTSLIST | grep $TMPDEV )
			if [ "$TMPDEV" ] && [ "$TMPPRINT" ]; then
				if [ "$(echo $MODULEFINGERPRINT | sed 's|\_\_.*||')" != "$(echo $TMPPRINT | cut -f 2 -d '=' | sed 's|\_\_.*||')" ]; then
					log_handler "Updating module fingerprint."
					sed -i "s|MODULEFINGERPRINT=$MODULEFINGERPRINT|MODULEFINGERPRINT=$(echo $TMPPRINT | cut -f 2 -d '=')|" $LATEFILE
					log_handler "Changing device fingerprint to $(echo $TMPPRINT | cut -f 2 -d '=' | sed 's|\_\_.*||')."
					# Reloading module settings
					load_settings
				fi
			fi
		fi
	fi
}

# Updates placeholders
placeholder_update() {
	FILEVALUE=$(get_file_value $1 "$2=")
	log_handler "Checking for ${3} in ${1}. Current value is ${FILEVALUE}."
	case $FILEVALUE in
		*PLACEHOLDER*)	sed -i "s|${2}=${3}|${2}=\"${4}\"|g" $1
						log_handler "Placeholder ${3} updated to ${4} in ${1}."
		;;
	esac
}

# Checks if any other module is using a local copy of build.prop
build_prop_check() {
	log_print "- Checking for build.prop conflicts"
	for D in $(ls $IMGPATH); do
		if [ "$D" != "$MODID" ]; then
			if [ -f "$IMGPATH/$D/system/build.prop" ] || [ "$D" == "safetypatcher" ]; then
				NAME=$(get_file_value $IMGPATH/$D/module.prop "name=")
				ui_print "!"
				log_print "! Another module editing build.prop detected!"
				log_print "! Module - '$NAME'!"
				log_print "! Modification of build.prop disabled!"
				ui_print "!"
				sed -i 's/BUILDPROPENB=1/BUILDPROPENB=0/' $UPDATELATEFILE
			fi
		fi
	done
}

# Checks for the Universal SafetyNet Fix module and similar modules editing device fingerprint
usnf_check() {
	log_print "- Checking for fingerprint conflicts"
	for USNF in $USNFLIST; do
		if [ -d "$IMGPATH/$USNF" ]; then
			NAME=$(get_file_value $IMGPATH/$USNF/module.prop "name=")
			ui_print "!"
			log_print "! Module editing fingerprint detected!"
			log_print "! Module - '$NAME'!"
			log_print "! Fingerprint modification disabled!"
			ui_print "!"
			sed -i 's/FINGERPRINTENB=1/FINGERPRINTENB=0/' $UPDATELATEFILE
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
	mv -f $MODPATH/system/binpath $MODPATH/system/$BIN >> $INSTLOG 2>&1
}

# Magisk installation check
install_check() {
	if [ ! -d "$SERVICEPATH" ] || [ ! -d "$POSTPATH" ]; then
		log_print "- Fresh Magisk installation detected."
		log_handler "Creating path for boot script."
		mkdir -pv $POSTPATH >> $INSTLOG 2>&1
		mkdir -pv $SERVICEPATH >> $INSTLOG 2>&1
	fi
}

# Check for late_start service boot script in post-fs-data.d, in case someone's moved it and also delete the old propsconf_post boot script if present
post_check() {
	if [ -f "$POSTLATEFILE" ]; then
		log_handler "Removing late_start service boot script from post-fs-data.d."
		rm -f $POSTLATEFILE
	fi
	if [ -f "$POSTFILE" ]; then
		log_handler "Removing old post-fs-data boot script from post-fs-data.d"
		rm -f $POSTFILE
	fi
	if [ -f "$CACHELOC/propsconf_postfile.log" ]; then
		log_handler "Removing old post-fs-data log from /cache."
		rm -f $CACHELOC/propsconf_postfile.log
	fi
}

# Save props values from fingerprint parts
print_parts() {
	DLIM1=1
	DLIM2=1
	for ITEM in $PROPSETTINGSLIST; do
		case $ITEM in
			SIMDESCRIPTION) # Do nothing with the description variable
			;;
			SIM*)
				TMPVAR="$(echo $ITEM | sed 's|SIM||')"
				TMPVALUE=$(echo $1 | sed 's|\:user/release-keys.*||' | cut -f $DLIM1 -d ':' | cut -f $DLIM2 -d '/')
				eval "VAR${TMPVAR}='$TMPVALUE'"
				DLIM2=$(($DLIM2 + 1))
				if [ "$DLIM2" == 4 ]; then
					DLIM1=2
					DLIM2=1
				fi
			;;
		esac
	done
	VARDESCRIPTION="${VARNAME}-user $VARRELEASE $VARID $VARINCREMENTAL release-keys"
}

# Update the device simulation variables if a fingerprint is set
devsim_update() {
	if [ "$MODULEFINGERPRINT" ]; then
		log_handler "Updating device simulation variables."
		print_parts $MODULEFINGERPRINT
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
	. $LATEFILE
	MODPATH=$MOUNTPATH/$MODID
}

# Installs everything
script_install() {
	build_prop_check
	usnf_check
	bin_check
	post_check
	script_placement
	log_print "- Updating placeholders"
	placeholder_update $LATEFILE CACHELOC CACHE_PLACEHOLDER "$CACHELOC"
	placeholder_update $LATEFILE COREPATH CORE_PLACEHOLDER "$COREPATH"
	placeholder_update $MODPATH/util_functions.sh BIN BIN_PLACEHOLDER "$BIN"
	placeholder_update $MODPATH/util_functions.sh USNFLIST USNF_PLACEHOLDER "$USNFLIST"
	placeholder_update $MODPATH/util_functions.sh MIRRORLOC MIRROR_PLACEHOLDER "$MIRRORLOC"
	placeholder_update $MODPATH/util_functions.sh CACHELOC CACHE_PLACEHOLDER "$CACHELOC"
	placeholder_update $MODPATH/util_functions.sh LATEFILE LATE_PLACEHOLDER "$LATEHOLDER"
	placeholder_update $MODPATH/util_functions.sh MODVERSION VER_PLACEHOLDER "$MODVERSION"
	placeholder_update $MODPATH/system/$BIN/props LATEFILE LATE_PLACEHOLDER "$LATEHOLDER"
	placeholder_update $MODPATH/system/$BIN/props COREPATH CORE_PLACEHOLDER "$COREPATH"
	load_settings
	devsim_update
	print_files
	ui_print ""
	ui_print "- Make sure to have Busybox installed."
	ui_print "- osm0sis' Busybox is recommended."
	ui_print ""
	log_handler "Installation complete."
	# Checks for configuration file
	CONFFILE=""
	for ITEM in $CONFFILELST; do
		if [ -s "$ITEM" ]; then
			CONFFILE="$ITEM"
			break
		fi
	done
	if [ "$CONFFILE" ]; then
		. $MODPATH/util_functions.sh
		LOGFILE=$INSTLOG
		MODPATH=$MOUNTPATH/$MODID
		ui_print "- Configuration file found."
		ui_print "- Installing..."
		ui_print ""
		config_file
	fi
}
