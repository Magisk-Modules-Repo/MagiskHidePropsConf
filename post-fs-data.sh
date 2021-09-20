#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2021 Didgeridoohan @ XDA Developers
# Licence: MIT

#anch1
	MODPATH=${0%/*}
	BOOTSTAGE="post"

	# Variables
	MODULESPATH=${MODPATH%/*}
	ADBPATH=${MODULESPATH%/*}
	MHPCPATH=$ADBPATH/mhpc
	LOGFILE=$MHPCPATH/propsconf.log
	LASTLOGFILE=$MHPCPATH/propsconf_last.log
	VLOGFILE=$MHPCPATH/propsconf_boot_verbose.log
	VLASTLOGFILE=$MHPCPATH/propsconf_boot_verbose_last.log
	RUNFILE=$MHPCPATH/script_check

	# Placeholder variables
	MODVERSIONPH=VER_PLACEHOLDER
	LATEFILEPH=LATE_PLACEHOLDER

	# Sensitive props
	TRIGGERLIST="
	ro.bootmode=recovery
	ro.boot.mode=recovery
	vendor.boot.mode=recovery
	ro.boot.hwc=CN
	ro.boot.hwcountry=China
	"

	# Saves the previous log (if available) and creates a new one
	if [ -f "$LOGFILE" ]; then
		mv -f $LOGFILE $LASTLOGFILE
	fi

	# Run the boot logcat script
	. $MODPATH/common/bootlog.sh

	#Start logging
	echo "***************************************************" > $LOGFILE 2>&1
	echo "********* MagiskHide Props Config $MODVERSION ********" >> $LOGFILE 2>&1
	echo "***************** By Didgeridoohan ***************" >> $LOGFILE 2>&1
	echo "***************************************************" >> $LOGFILE 2>&1
	echo ""
	STRST="$(date +"%m-%d-%Y %H:%M:%S.%3N") - Log start (regular execution)."
	echo -e $STRST >> $LOGFILE 2>&1
	echo -e $STRST > $RUNFILE 2>&1

	# Save default prop values
	getprop > $MHPCPATH/defaultprops
	echo "" >> $LOGFILE 2>&1
	echo -e "$(date +"%Y-%m-%d %H:%M:%S.%3N") - Saved default values" >> $LOGFILE 2>&1

{
	# Creates/updates the script control file
	touch $MHPCPATH/propsconf_postchk >> $LOGFILE 2>&1

	# Logging
	log_handler() {
		echo "" >> $LOGFILE 2>&1
		echo -e "$(date +"%Y-%m-%d %H:%M:%S.%3N") - $1" >> $LOGFILE 2>&1
	}

	# Get left side of =, $1=string to check
	get_eq_left() {
		echo $1 | cut -f 1 -d '='
	}

	# Get right side of =, $1=string to check
	get_eq_right() {
		echo $1 | cut -f 2- -d '='
	}

	# Finding file values, $1=file (with path), $2=string to look for
	get_file_value() {
		if [ -f "$1" ]; then
			echo $(grep $2 $1) | sed "s|.*${2}||" | sed 's|\"||g'
		fi
	}

	# Find prop type, $1=prop name
	get_prop_type() {
		if [ "$1" == "vendor.boot.mode" ]; then
			echo "vendormode"
		else
			echo $1 | sed 's|.*\.||' | sed 's|.*\_||'
		fi
	}

	# Reset/disable file locations
	FILELOCLST="
	/data/media/0
	/data
	$CACHELOC
	"

	# Check if disable file is present
	DISABLEFILE=""
	for ITEM in $FILELOCLST; do
		if [ -f "$ITEM/disable_mhpc" ]; then
			DISABLEFILE="$ITEM/disable_mhpc"
			break
		fi
	done
	if [ -f "$DISABLEFILE" ]; then
		log_handler "Disable file found. Disabling module..."
		touch $MODPATH/disable
		for ITEM in $FILELOCLST; do
			rm -f $ITEM/disable_mhpc
		done
		# Deletes the post-fs-data control file
		rm -f $MHPCPATH/propsconf_postchk >> $LOGFILE 2>&1
		# Reboot
		log_handler "Setting reboot flag."
		touch $MHPCPATH/reboot >> $LOGFILE 2>&1
	fi

	# Check for the boot script and restore backup if deleted, or if the reset file is present
	RESETFILE=""
	for ITEM in $FILELOCLST; do
		if [ -f "$ITEM/reset_mhpc" ]; then
			RESETFILE="$ITEM/reset_mhpc"
			break
		fi
	done
	if [ ! -s "$LATEFILE" ] || [ -f "$RESETFILE" ]; then
		if [ -f "$RESETFILE" ]; then
			log_handler "Reset file found."
			RSTTXT="Resetting"
			for ITEM in $FILELOCLST; do
				rm -f $ITEM/reset_mhpc
			done
		else
			RSTTXT="Restoring"
			if [ -f "$LATEFILE" ]; then
				log_handler "The module settings file was empty."
			else
				log_handler "The module settings file could not be found."
			fi
		fi
		log_handler "$RSTTXT module settings file (${LATEFILE})."
		cp -af $MODPATH/common/propsconf_late $LATEFILE >> $LOGFILE 2>&1
		rm -f $MODPATH/system.prop >> $LOGFILE 2>&1
	fi

	# Loading module settings
	log_handler "Loading module settings"
	. $LATEFILE

	# Edits prop values if set for post-fs-data
	if [ "$OPTIONBOOT" == 1 ] || [ "$OPTIONBOOT" != 1 -a "$PRINTSTAGE" == 1 ] || [ "$OPTIONBOOT" != 1 -a "$PATCHSTAGE" == 1 ] || [ "$OPTIONBOOT" != 1 -a "$SIMSTAGE" == 1 ] || [ "$CUSTOMPROPSPOST" ] || [ "$DELETEPROPS" ] || [ "$PROPBOOT" == 1 ]; then
		# Load functions
		. $MODPATH/common/util_functions.sh
		echo -e "\n----------------------------------------" >> $LOGFILE 2>&1
		log_handler "Editing prop values in post-fs-data mode."
		if [ "$OPTIONBOOT" == 1 ]; then
			# Setting/Changing fingerprint
			if [ "$PRINTSTAGE" == 0 ]; then
				print_edit "none"
			fi
			# Setting/Changing security patch date
			if [ "$PATCHSTAGE" == 0 ]; then
				patch_edit "none"
			fi
			# Forced basic attestation
			if [ "$BASICATTEST" == 1 ]; then
				forced_basic "none"
			fi
			# Setting device simulation props
			if [ "$SIMSTAGE" == 0 ]; then
				dev_sim_edit "none"
			fi
			# Setting custom props
			custom_edit "CUSTOMPROPS"
		else
			# Edit fingerprint if set for post-fs-data
			if [ "$PRINTSTAGE" == 1 ]; then
				print_edit "none"
			fi
			# Edit security patch date if set for post-fs-data
			if [ "$PATCHSTAGE" == 1 ]; then
				patch_edit "none"
			fi
			# Edit simulation props if set for post-fs-data
			if [ "$SIMSTAGE" == 1 ]; then
				dev_sim_edit "none"
			fi
		fi
		# Edit MagiskHide sensitive props if set for post-fs-data
		if [ "$PROPEDIT" == 1 ] && [ "$PROPBOOT" == 1]; then
			sensitive_props "$PROPSLIST$TRIGGERLIST"
		fi
		# Edit custom props set for post-fs-data
		custom_edit "CUSTOMPROPSPOST"
		# Deleting props
		prop_del
		echo -e "\n----------------------------------------" >> $LOGFILE 2>&1
	fi

	log_handler "post-fs-data.sh module script finished."
	echo -e "\n$(date +"%Y-%m-%d %H:%M:%S:%N") - post-fs-data.sh module script finished." >> $RUNFILE 2>&1

	# Deletes the post-fs-data control file
	rm -f $MHPCPATH/propsconf_postchk >> $LOGFILE 2>&1
} &
