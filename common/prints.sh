#!/system/bin/sh

# MagiskHide Props Config
# By Didgeridoohan @ XDA-Developers

PRINTSV=1
PRINTSTRANSF=1

PRINTSFILE=/sdcard/printslist

# Certified fingerprints
PRINTSLIST="
Google Nexus 6=google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
Google Pixel 2 XL=google/taimen/taimen:8.1.0/OPM1.171019.013/4474084:user/release-keys
OnePlus 3T=OnePlus/OnePlus3/OnePlus3T:8.0.0/OPR6.170623.013/12041042:user/release-keys
OnePlus 5T=OnePlus/OnePlus5T/OnePlus5T:7.1.1/NMF26X/12152312:user/release-keys
Samsung S8 Plus=samsung/dream2ltexx/dream2lte:7.0/NRD90M/G955FXXU1AQGB:user/release-keys
Sony Xperia Z3=Sony/D6633/D6633:6.0.1/23.5.A.1.291/2769308465:user/release-keys
Xiaomi Mi6=Xiaomi/sagit/sagit:7.1.1/NMF26X/V8.2.17.0.NCACNEC:user/release-keys
"

if [ -f "$PRINTSFILE" ]; then
	FLINE=$(head -1 $PRINTSFILE)
	if [ "$FLINE" ]; then
		sed -i '1s/^/\n/' $PRINTSFILE
	fi
	LISTFILE=$(cat $PRINTSFILE)
	PRINTSLIST=$PRINTSLIST$LISTFILE
fi
