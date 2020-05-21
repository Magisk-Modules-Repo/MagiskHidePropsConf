#!/system/bin/sh

# MagiskHide Props Config
# Copyright (c) 2018-2020 Didgeridoohan @ XDA Developers
# Licence: MIT

{
	if [ "$VLOGFILE" ]; then
		# Save the previous log if it exists
		if [ -f "$VLOGFILE" ]; then
			mv -f $VLOGFILE $VLASTLOGFILE
		fi
		sleep 15 # Pause to make sure props have been reset
		while (true); do
			sleep 1
			logcat -d > $VLOGFILE
			if [ $(getprop sys.boot_completed) == 1 ]; then
				sleep 5 # Wait an additional 5 seconds after boot completed
				logcat -d > $VLOGFILE
				sed -i '1s/^/MagiskHide Props Config Boot Logcat\n========================================\n\n/' $VLOGFILE
				echo -e "\n========================================\n$(date +"%m-%d %H:%M:%S.%3N") Log saved" >> $VLOGFILE
				break
			fi
		done
		exit
	fi
} &
