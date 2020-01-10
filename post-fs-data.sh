#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2020 Didgeridoohan @ XDA Developers
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
	RUNFILE=$MHPCPATH/script_check

	# Placeholder variables
	MODVERSIONPH=VER_PLACEHOLDER
	LATEFILEPH=LATE_PLACEHOLDER

	# Saves the previous log (if available) and creates a new one
	if [ -f "$LOGFILE" ]; then
		mv -f $LOGFILE $LASTLOGFILE
	fi
	echo "***************************************************" > $LOGFILE 2>&1
	echo "********* MagiskHide Props Config $MODVERSION ********" >> $LOGFILE 2>&1
	echo "***************** By Didgeridoohan ***************" >> $LOGFILE 2>&1
	echo "***************************************************" >> $LOGFILE 2>&1
	echo ""
	STRST="$(date +"%m-%d-%Y %H:%M:%S:%N") - Log start (regular execution)."
	echo -e $STRST >> $LOGFILE 2>&1
	echo -e $STRST > $RUNFILE 2>&1

	# Save default prop values
	resetprop > $MHPCPATH/defaultprops
	echo "" >> $LOGFILE 2>&1
	echo -e "$(date +"%Y-%m-%d %H:%M:%S:%N") - Saved default values" >> $LOGFILE 2>&1

{
	# Creates/updates the script control file
	touch $MHPCPATH/propsconf_postchk

	# Logging
	log_handler() {
		echo "" >> $LOGFILE 2>&1
		echo -e "$(date +"%Y-%m-%d %H:%M:%S:%N") - $1" >> $LOGFILE 2>&1
	}

	# Reset file locations
	RESETFILELST="
	/data/media/0/reset_mhpc
	/data/reset_mhpc
	$CACHELOC/reset_mhpc
	"

	# Check for the boot script and restore backup if deleted, or if the resetfile is present
	RESETFILE=""
	for ITEM in $RESETFILELST; do
		if [ -f "$ITEM" ]; then
			RESETFILE="$ITEM"
			break
		fi
	done
	if [ ! -s "$LATEFILE" ] || [ -f "$RESETFILE" ]; then
		if [ -f "$RESETFILE" ]; then
			RSTTXT="Resetting"
			for ITEM in $RESETFILELST; do
				rm -f $ITEM
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
	. $LATEFILE

	# Edits prop values if set for post-fs-data
	if [ "$OPTIONBOOT" == 1 ] || [ "$OPTIONBOOT" != 1 -a "$PRINTSTAGE" == 1 ] || [ "$OPTIONBOOT" != 1 -a "$PATCHSTAGE" == 1 ] || [ "$OPTIONBOOT" != 1 -a "$SIMSTAGE" == 1 ] || [ "$CUSTOMPROPSPOST" ] || [ "$DELETEPROPS" ]; then
		# Load functions
		. $MODPATH/common/util_functions.sh
		echo -e "\n----------------------------------------" >> $LOGFILE 2>&1
		log_handler "Editing prop values in post-fs-data mode."
		if [ "$OPTIONBOOT" == 1 ]; then
			# Setting/Changing fingerprint
			if [ "$PRINTSTAGE" == 0 ]; then
				print_edit
			fi
			# Setting/Changing security patch date
			if [ "$PATCHSTAGE" == 0 ]; then
				patch_edit
			fi
			# Setting device simulation props
			if [ "$SIMSTAGE" == 0 ]; then
				dev_sim_edit
			fi
			# Setting custom props
			custom_edit "CUSTOMPROPS"
		fi
		# Edit fingerprint if set for post-fs-data
		if [ "$OPTIONBOOT" != 1 ] && [ "$PRINTSTAGE" == 1 ]; then
			print_edit
		fi
		# Edit security patch date if set for post-fs-data
		if [ "$OPTIONBOOT" != 1 ] && [ "$PATCHSTAGE" == 1 ]; then
			patch_edit
		fi
		# Edit simulation props if set for post-fs-data
		if [ "$OPTIONBOOT" != 1 ] && [ "$SIMSTAGE" == 1 ]; then
			dev_sim_edit
		fi
		# Edit custom props set for post-fs-data
		custom_edit "CUSTOMPROPSPOST"
		# Deleting props
		prop_del
		echo -e "\n----------------------------------------" >> $LOGFILE 2>&1
	fi

	FNSH="\n$(date +"%Y-%m-%d %H:%M:%S:%N") - post-fs-data.sh module script finished."
	echo -e $FNSH >> $LOGFILE 2>&1
	echo -e $FNSH >> $RUNFILE 2>&1

	# Deletes the post-fs-data control file
	rm -f $MHPCPATH/propsconf_postchk
} &
