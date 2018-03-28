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
PRINTSWWW="https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/prints.sh"
alias cat="$BBPATH cat"
alias grep="$BBPATH grep"
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
log_print() {
	echo "$1"
	log_handler "$1"
}


#Divider
DIVIDER="${Y}=====================================${N}"

# Header
menu_header() {
	if [ "$MODVERSION" == "VER_PLACEHOLDER" ]; then
		VERSIONTXT=""
	else
		VERSIONTXT=$MODVERSION
	fi
	echo ""
	echo "${W}MagiskHide Props Config $VERSIONTXT${N}"
	echo "${W}by Didgeridoohan @ XDA Developers${N}"
	echo ""
	echo $DIVIDER
	echo -e " $1"
	echo $DIVIDER
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
	clear
	menu_header "Updating fingerprints list"
	echo ""
	log_print "Checking list version."
	wget -T 10 -O $PRINTSTMP $PRINTSWWW 2>> $LOGFILE	
	if [ -f "$PRINTSTMP" ]; then
		LISTVERSION=$(get_file_value $PRINTSTMP "PRINTSV=")
		if [ "$LISTVERSION" -gt "$(get_file_value $PRINTSLOC "PRINTSV=")" ]; then
			if [ "$(get_file_value $PRINTSTMP "PRINTSTRANSF=")" -le "$(get_file_value $PRINTSLOC "PRINTSTRANSF=")" ]; then
				mv -f $PRINTSTMP $PRINTSLOC
				# Updates list version in module.prop
				VERSIONTMP=$(get_file_value $MODPATH/module.prop "version=")
				sed -i "s/version=$VERSIONTMP/version=$MODVERSION-v$LISTVERSION/g" $MODPATH/module.prop
				log_print "Updated list to v$LISTVERSION."
			else
				rm -f $PRINTSTMP
				log_print "New fingerprints list requires module update."
			fi
		else
			rm -f $PRINTSTMP
			log_print "Fingerprints list up-to-date."
		fi
	else
		log_print "No connection."
	fi
}

orig_check() {
	PROPSTMPLIST=$PROPSLIST"
	ro.build.fingerprint
	"
	ORIGLOAD=0
	for PROPTYPE in $PROPSTMPLIST; do
		PROP=$(get_prop_type $PROPTYPE)
		ORIGPROP=$(echo "ORIG$PROP" | tr '[:lower:]' '[:upper:]')
		ORIGVALUE=$(get_file_value $LATEFILE "$ORIGPROP=")
		if [ "$ORIGVALUE" ]; then
			ORIGLOAD=1
		fi
	done
}
