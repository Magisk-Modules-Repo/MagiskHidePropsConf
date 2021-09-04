#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2021 Didgeridoohan @ XDA Developers
# Licence: MIT

{
	if [ "$VLOGFILE" ]; then
		# Save the previous log if it exists
		if [ -f "$VLOGFILE" ]; then
			mv -f $VLOGFILE $VLASTLOGFILE
		fi
		logcat -f $VLOGFILE &
		sleep 5
		until [ $(getprop sys.boot_completed) == 1 ]; do
			sleep 1
		done
		sleep 5
		kill %1
		sed -i '1s/^/MagiskHide Props Config Boot Logcat\n========================================\n\n/' $VLOGFILE
		echo -e "\n========================================\n$(date +"%m-%d %H:%M:%S.%3N") Log saved" >> $VLOGFILE
		exit
	fi
} &
