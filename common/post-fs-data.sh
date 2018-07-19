#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODPATH/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODPATH=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

# MagiskHide Props Config
# By Didgeridoohan @ XDA Developers

# Variables
IMGPATH=$(dirname "$MODPATH")

# Load functions
. $MODPATH/util_functions.sh

if [ ! -f "$POSTCHKFILE" ]; then	
	touch $POSTCHKFILE
fi

# Check for boot scripts and restore backup if deleted, or if the resetfile is present
if [ ! -f "$POSTFILE" ]; then
	# Start logging
	log_start
	log_handler "Post-fs-data boot script not found."
	log_handler "Restoring boot script (${POSTFILE})."
	cp -af $MODPATH/propsconf_post $POSTFILE >> $LOGFILE
	chmod -v 755 $POSTFILE >> $LOGFILE
	placeholder_update $POSTFILE IMGPATH IMG_PLACEHOLDER $IMGPATH
	# Deleting settings script to force a restore
	rm -f $LATEFILE
fi
if [ ! -f "$LATEFILE" ] || [ -f "$RESETFILE" ]; then
	if [ -f "$RESETFILE" ]; then
		RSTTXT="Resetting"
	else
		RSTTXT="Restoring"
		log_handler "Late_start service boot script not found."
	fi	
	log_handler "$RSTTXT boot script (${LATEFILE})."
	cp -af $MODPATH/propsconf_late $LATEFILE >> $LOGFILE
	chmod -v 755 $LATEFILE >> $LOGFILE
	placeholder_update $LATEFILE IMGPATH IMG_PLACEHOLDER $IMGPATH
	placeholder_update $LATEFILE CACHELOC CACHE_PLACEHOLDER $CACHELOC
	
fi

log_handler "post-fs-data.sh finished.\n\n===================="

# Deletes the post-fs-data control file
rm -f $POSTCHKFILE