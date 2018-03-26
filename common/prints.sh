#!/system/bin/sh

# MagiskHide Props Config
# By Didgeridoohan @ XDA-Developers

PRINTSV=3
PRINTSTRANSF=1

PRINTSFILE=/sdcard/printslist

# Certified fingerprints
PRINTSLIST="
Google Nexus 6 (7.1.1)=google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
Google Pixel 2 (P DP1)=google/walleye/walleye:P/PPP1.180208.014/4633861:user/release-keys
Google Pixel 2 XL (8.1.0)=google/taimen/taimen:8.1.0/OPM1.171019.013/4474084:user/release-keys
OnePlus 3T (8.0.0)=OnePlus/OnePlus3/OnePlus3T:8.0.0/OPR6.170623.013/12041042:user/release-keys
OnePlus 5T (7.1.1)=OnePlus/OnePlus5T/OnePlus5T:7.1.1/NMF26X/12152312:user/release-keys
Samsung Galaxy Grand Prime (5.0.2)=samsung/fortuna3gdtvvj/fortuna3gdtv:5.0.2/LRX22G/G530BTVJU1BPH4:user/release-keys
Samsung Galaxy S8 Plus (7.0)=samsung/dream2ltexx/dream2lte:7.0/NRD90M/G955FXXU1AQGB:user/release-keys
Sony Xperia Z3 (6.0.1)=Sony/D6633/D6633:6.0.1/23.5.A.1.291/2769308465:user/release-keys
Xiaomi Mi6 (7.1.1)=Xiaomi/sagit/sagit:7.1.1/NMF26X/V8.2.17.0.NCACNEC:user/release-keys
"

if [ -f "$PRINTSFILE" ]; then
	FLINE=$(head -1 $PRINTSFILE)
	if [ "$FLINE" ]; then
		sed -i '1s/^/\n/' $PRINTSFILE
	fi
	LISTFILE=$(cat $PRINTSFILE)
	PRINTSLIST=$PRINTSLIST$LISTFILE
fi
