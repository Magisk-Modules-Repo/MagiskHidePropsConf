#!/system/bin/sh

# MagiskHide Props Config
# By Didgeridoohan @ XDA-Developers

# Variables
LATEFILE=$IMGPATH/.core/service.d/propsconf_late
LOGFILE=/cache/propsconf.log
MAGISKLOC=/data/adb/magisk
BBPATH=$MAGISKLOC/busybox
PRINTSLOC=$MODPATH/prints.sh
PRINTSTMP=/cache/prints.sh
PRINTSWWW="https://raw.githubusercontent.com/Didgeridoohan/MagiskHide-Props-Config/master/common/prints.sh"
alias cat="$BBPATH cat"
alias grep="$BBPATH grep"
alias reboot="/system/bin/reboot"
alias resetprop="$MAGISKLOC/magisk resetprop"
alias sed="$BBPATH sed"
alias tr="$BBPATH tr"
alias wget="$BBPATH wget"

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

# Logs
log_handler() {
	echo "" >> $LOGFILE
	echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $LOGFILE
}

# Finding file values
get_file_value() {
	cat $1 | grep $2 | sed 's/.*=//'
}

# Find prop type
get_prop_type() {
	echo $1 | sed 's/.*\.//'
}

# Separate prop from value
safe_prop_name() {
	echo $1 | sed 's/=.*//'
}
safe_prop_value() {
	echo $1 | sed 's/.*=//'
}

# Check safe values
safe_props() {
	SAFE=""
	if [ "$2" ]; then
		for P in $SAFELIST; do
			if [ "$(safe_prop_name $P)" == "$1" ]; then
				if [ "$2" == "$(safe_prop_value $P)" ]; then
					SAFE=1
				else
					SAFE=0
				fi
				break
			fi
		done
	fi
}

# Updates placeholders
placeholder_update() {
	FILEVALUE=$(get_file_value $1 "$2=")
	log_handler "Checking for '$3' in '$1'. Current value is '$FILEVALUE'."
	case $FILEVALUE in
		*PLACEHOLDER*)	sed -i "s@$2\=$3@$2\=$4@g" $1
						log_handler "Placeholder '$3' updated to '$4' in '$1'."
		;;
	esac
}

download_prints() {
	wget -O $PRINTSTMP $PRINTSWWW 2>> $LOGFILE
	if [ "$(get_file_value $PRINTSTMP "PRINTSV=")" -gt "$(get_file_value $PRINTSLOC "PRINTSV=")" ]; then
		if [ "$(get_file_value $PRINTSTMP "PRINTSTRANSF=")" -ge "$(get_file_value $PRINTSLOC "PRINTSTRANSF=")" ]; then
			mv -f $PRINTSTMP $PRINTSLOC
			log_handler "Updated prints.sh to v$(get_file_value $PRINTSLOC "PRINTSV=")."
		fi
	else
		rm -f $PRINTSTMP
	fi
}