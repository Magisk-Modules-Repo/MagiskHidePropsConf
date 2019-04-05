#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

# Uninstalls the module settings file and directory in Magisk's secure directory
# together with a few module files in /cache.

MODPATH=${0%/*}

# Load functions
. $MODPATH/util_functions.sh

# Variables
DIR=/data/adb/mhpc

# Start logging
log_start

log_handler "Cleaning up module files during uninstall."

if [ -d "$DIR" ]; then
	log_handler "Removing settings file(s)."
	echo "Deleting $DIR" >> $LOGFILE 2>&1
	rm -rf "$DIR" >> $LOGFILE 2>&1
fi

log_handler "Checking for files to remove in $CACHELOC."
for ITEM in $CACHEFILES; do
	if [ -f "$CACHELOC/$ITEM" ]; then
		echo "Deleting ${ITEM}." >> $LOGFILE 2>&1
		rm -f $CACHELOC/$ITEM >> $LOGFILE 2>&1
	fi
done
