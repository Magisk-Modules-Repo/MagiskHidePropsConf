##########################################################################################
#
# Magisk Module Template Config Script
# by topjohnwu
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure the settings in this file (config.sh)
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Configs
##########################################################################################

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print "*******************************"
  ui_print "    MagiskHide Props Config"
  ui_print "*******************************"
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  # Only some special files require specific permissions
  # The default permissions should be good enough for most cases

  # Here are some examples for the set_perm functions:

  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH/system/lib       0       0       0755            0644

  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0       0644

  # The following is default permissions, DO NOT remove
  set_perm_recursive  $MODPATH  0  0  0755  0644
  
  # Permissions for the props file
  set_perm $MODPATH/system/$BIN/props 0 0 0777
}

##########################################################################################
# Custom Functions
##########################################################################################

# This file (config.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.

# Finding file values
get_file_value() {
	cat $1 | grep $2 | sed 's/.*=//' | sed 's/\"//g'
}

# Variables
$BOOTMODE && IMGPATH=/sbin/.core/img || IMGPATH=$MOUNTPATH
UPDATELATEFILE=$INSTALLER/common/propsconf_late
LATEFILE=$IMGPATH/.core/service.d/propsconf_late
UPDATEV=$(get_file_value $UPDATELATEFILE "SCRIPTV=")
SETTRANSF=$(get_file_value $UPDATELATEFILE "SETTRANSF=")
if [ -f "$LATEFILE" ]; then
	FILEV=$(get_file_value $LATEFILE "SCRIPTV=")
else
	FILEV=0
fi
BBPATH=/data/adb/magisk/busybox
$BOOTMODE && alias grep="$BBPATH grep"
$BOOTMODE && alias sed="$BBPATH sed"
$BOOTMODE && alias tr="$BBPATH tr"
$BOOTMODE && alias ls="$BBPATH ls"
SETTINGSLIST="
FINGERPRINTENB
PRINTEDIT
BUILDPROPENB
FILESAFE
BUILDEDIT
DEFAULTEDIT
PROPCOUNT
PROPEDIT
CUSTOMCHK
REBOOTCHK
OPTIONCOLOUR
OPTIONWEB
"
PROPSETTINGSLIST="
FILEDEBUGGABLE
FILESECURE
FILETYPE
FILETAGS
FILESELINUX
ORIGDEBUGGABLE
ORIGSECURE
ORIGTYPE
ORIGTAGS
ORIGSELINUX
ORIGFINGERPRINT
MODULEDEBUGGABLE
MODULESECURE
MODULETYPE
MODULETAGS
MODULESELINUX
MODULEFINGERPRINT
CUSTOMPROPS
"
PROPSLIST="
debuggable
secure
type
tags
selinux
fingerprint
"
USNFLIST="xiaomi-safetynet-fix safetynet-fingerprint-fix"

# Places various module scripts in their proper places
script_placement() {
	ui_print "- Installing scripts"
	cp -af $INSTALLER/common/util_functions.sh $MODPATH/util_functions.sh
	cp -af $INSTALLER/common/prints.sh $MODPATH/prints.sh
	cp -af $UPDATELATEFILE $MODPATH/propsconf_late
	if [ "$UPDATEV" -gt "$FILEV" ]; then
		if [ "$FILEV" == 0 ]; then
			ui_print "- Placing settings script"
		elif [ "$SETTRANSF" -gt "$FILEV" ]; then
			ui_print "- Settings cleared (script updated)"
		else
			ui_print "- Script updated"
			ui_print "- Transferring settings from old script"
			# Prop settings
			for ITEM in $SETTINGSLIST; do
				SOLD=$(get_file_value $LATEFILE "${ITEM}=")
				SNEW=$(get_file_value $UPDATELATEFILE "${ITEM}=")
				if [ "$SOLD" ]; then
					sed -i "s@${ITEM}=${SNEW}@${ITEM}=${SOLD}@" $UPDATELATEFILE
				fi
			done
			# Prop values
			for ITEM in $PROPSETTINGSLIST; do
				SOLD=$(get_file_value $LATEFILE "${ITEM}=")
				if [ "$SOLD" ]; then
					sed -i "s@${ITEM}=\"\"@${ITEM}=\"${SOLD}\"@" $UPDATELATEFILE
				fi
			done
			# Prop and file edits
			for ITEM in $PROPSLIST; do
				REPROP=$(echo "RE${ITEM}" | tr '[:lower:]' '[:upper:]')
				SETPROP=$(echo "SET${ITEM}" | tr '[:lower:]' '[:upper:]')
				REOLD=$(get_file_value $LATEFILE "${REPROP}=")
				SETOLD=$(get_file_value $LATEFILE "${SETPROP}=")
				if [ "$REOLD" ]; then
					sed -i "s/${REPROP}=false/${REPROP}=${REOLD}/" $UPDATELATEFILE
				fi
				if [ "$SETOLD" ]; then
					sed -i "s/${SETPROP}=false/${SETPROP}=${SETOLD}/" $UPDATELATEFILE
				fi
			done
		fi
		cp -af $UPDATELATEFILE $LATEFILE
		chmod 755 $LATEFILE
	else
		ui_print "- Module settings preserved"
	fi
}

# Updates placeholder
placeholder_update() {
	FILEVALUE=$(get_file_value $1 "$2=")
	case $FILEVALUE in
		*PLACEHOLDER*)	sed -i "s@${2}=${3}@${2}=\"${4}\"@g" $1
		;;
	esac
}

# Checks if any other module is using a local copy of build.prop
build_prop_check() {
	ui_print "- Checking for build.prop conflicts"
	for D in $(ls $IMGPATH); do
		if [ "$D" != "$MODID" ]; then
			if [ -f "$IMGPATH/$D/system/build.prop" ]; then
				NAME=$(get_file_value $IMGPATH/$D/module.prop "name=")
				ui_print ""
				ui_print "! Another module editing build.prop detected!"
				ui_print "! Module - '$NAME'!"
				ui_print "! Modification of build.prop disabled!"
				ui_print ""
				sed -i 's/BUILDPROPENB=1/BUILDPROPENB=0/' $UPDATELATEFILE			
				break
			fi
		fi
	done
}

# Checks for the Universal SafetyNet Fix module and similar modules editing device fingerprint
usnf_check() {
	ui_print "- Checking for fingerprint conflicts"
	for USNF in $USNFLIST; do
		if [ -d "$IMGPATH/$USNF" ]; then
			NAME=$(get_file_value $IMGPATH/$USNF/module.prop "name=")
			ui_print ""
			ui_print "! Module editing fingerprint detected!"
			ui_print "! Module - '$NAME'!"
			ui_print "! Fingerprint modification disabled!"
			ui_print ""
			sed -i 's/FINGERPRINTENB=1/FINGERPRINTENB=0/' $UPDATELATEFILE
			break
		fi
	done
}

# Check for bin/xbin
bin_check() {
	if [ -d "/system/xbin" ]; then
		BIN=xbin
	else
		BIN=bin
	fi
	mv -f $MODPATH/system/binpath $MODPATH/system/$BIN
}

# Check for A/B devices
ab_check() {
	if [ -z $SLOT ]; then
		CACHELOC=/cache
	else
		CACHELOC=/data/cache
	fi
}

# Installs everything
script_install() {
	build_prop_check
	usnf_check
	bin_check
	ab_check
	script_placement
	ui_print "- Updating placeholders"
	placeholder_update $LATEFILE CACHELOC CACHE_PLACEHOLDER "$CACHELOC"
	placeholder_update $MODPATH/util_functions.sh BIN BIN_PLACEHOLDER "$BIN"
	placeholder_update $MODPATH/util_functions.sh USNFLIST USNF_PLACEHOLDER "$USNFLIST"
	placeholder_update $MODPATH/util_functions.sh CACHELOC CACHE_PLACEHOLDER "$CACHELOC"
	MODVERSION=$(echo $(get_file_value $MODPATH/module.prop "version=") | sed 's/-.*//')
	placeholder_update $MODPATH/util_functions.sh MODVERSION VER_PLACEHOLDER $MODVERSION
	# Load module functions
	. $MODPATH/util_functions.sh
	# Checks original file values
	file_values
	orig_safe
	# Checks for configuration file	
	config_file
}
