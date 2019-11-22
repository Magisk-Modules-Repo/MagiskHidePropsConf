#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2019 Didgeridoohan @ XDA Developers
# Licence: MIT

# Uninstalls the module settings file and directory in Magisk's secure directory
# together with a few module files in /cache.

MODPATH=${0%/*}
BOOTSTAGE="post"

# Load functions
. $MODPATH/util_functions.sh

rm -rf "$MHPCPATH"

for ITEM in $CACHEFILES; do
	rm -f $CACHELOC/$ITEM
done
