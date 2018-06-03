#!/system/bin/sh

# MagiskHide Props Config
# By Didgeridoohan @ XDA Developers

PRINTSV=18
PRINTSTRANSF=1

PRINTSFILE=/sdcard/printslist

# Certified fingerprints
PRINTSLIST="
Asus Zenfone 2 Laser (6.0.1)=asus/WW_Z00L/ASUS_Z00L_63:6.0.1/MMB29P/WW_user_21.40.1220.2179_20170803:user/release-keys
Google Nexus 4 (5.1.1)=google/occam/mako:5.1.1/LMY48T/2237560:user/release-keys
Google Nexus 5 (6.0.1)=google/hammerhead/hammerhead:6.0.1/M4B30Z/3437181:user/release-keys
Google Nexus 6 (7.1.1)=google/shamu/shamu:7.1.1/N6F27M/4299435:user/release-keys
Google Nexus 5X (8.1.0)=google/bullhead/bullhead:8.1.0/OPM2.171019.029/4657601:user/release-keys
Google Nexus 6P (8.1.0)=google/angler/angler:8.1.0/OPM5.171019.019/4619337:user/release-keys
Google Pixel (8.1.0)=google/sailfish/sailfish:8.1.0/OPM2.171019.029/4657601:user/release-keys
Google Pixel (P DP1)=google/sailfish/sailfish:P/PPP1.180208.014/4633861:user/release-keys
Google Pixel XL (8.1.0)=google/marlin/marlin:8.1.0/OPM2.171019.029/4657601:user/release-keys
Google Pixel XL (P DP1)=google/marlin/marlin:P/PPP1.180208.014/4633861:user/release-keys
Google Pixel 2 (8.1.0)=google/walleye/walleye:8.1.0/OPM2.171019.029/4657601:user/release-keys
Google Pixel 2 (P DP1)=google/walleye/walleye:P/PPP1.180208.014/4633861:user/release-keys
Google Pixel 2 XL (8.1.0)=google/taimen/taimen:8.1.0/OPM4.171019.016.B1/4720843:user/release-keys
Google Pixel 2 XL (P DP1)=google/taimen/taimen:P/PPP1.180208.014/4633861:user/release-keys
HTC 10 (6.0.1)=htc/HTCOneM10vzw/htc_pmewl:6.0.1/MMB29M/774095.8:user/release-keys
Huawei Honor 9 (8.0.0)=HONOR/STF-L09/HWSTF:8.0.0/HUAWEISTF-L09/364(C432):user/release-keys
Huawei Mate 10 Pro (8.0.0)=HUAWEI/BLA-L29/HWBLA:8.0.0/HUAWEIBLA-L29S/137(C432):user/release-keys
Motorola Moto E4 (7.1.1)=motorola/sperry_sprint/sperry:7.1.1/NCQ26.69-64/68:user/release-keys
Motorola Moto G4 (7.0)=motorola/athene/athene:7.0/NPJS25.93-14-13/3:user/release-keys
Motorola Moto G5 (7.0)=motorola/cedric/cedric:7.0/NPPS25.137-15-11/11:user/release-keys
Motorola Moto G5 Plus (7.0)=motorola/potter_n/potter_n:7.0/NPNS25.137-33-11/11:user/release-keys
Motorola Moto X4 (8.0.0)=motorola/payton/payton:8.0.0/OPWS27.57-25-6-10/12:user/release-keys
Nvidia Shield K1 (7.0)=nvidia/sb_na_wf/shieldtablet:7.0/NRD90M/1928188_1065.2559:user/release-keys
OnePlus 3T (8.0.0)=OnePlus/OnePlus3/OnePlus3T:8.0.0/OPR6.170623.013/12041042:user/release-keys
OnePlus 5T (8.0.0)=OnePlus/OnePlus5T/OnePlus5T:8.0.0/OPR1.170623.032/02040656:user/release-keys
OnePlus 6 (8.1.0)=OnePlus/OnePlus6/OnePlus6:8.1.0/OPM1.171019.011/05172042:user/release-keys
Samsung Galaxy A8 Plus (7.1.1)=samsung/jackpot2ltexx/jackpot2lte:7.1.1/NMF26X/A730FXXU2ARD1:user/release-keys
Samsung Galaxy Grand Prime (5.0.2)=samsung/fortuna3gdtvvj/fortuna3gdtv:5.0.2/LRX22G/G530BTVJU1BPH4:user/release-keys
Samsung Galaxy J5 (7.1.1)=samsung/j5xnltexx/j5xnlte:7.1.1/NMF26X/J510FNXXS2BRA2:user/release-keys
Samsung Galaxy J5 Prime (7.0)=samsung/on5xeltejv/on5xelte:7.0/NRD90M/G570FXXU1BQI6:user/release-keys
Samsung Galaxy Note 3 (7.1.1)=samsung/greatltexx/greatlte:7.1.1/NMF26X/N950FXXU1AQHA:user/release-keys
Samsung Galaxy Note 4 (6.0.1)=samsung/trltexx/trlte:6.0.1/MMB29M/N910FXXS1DQH9:user/release-keys
Samsung Galaxy Note 5 (7.0)=samsung/nobleltejv/noblelte:7.0/NRD90M/N920CXXU3CQH6:user/release-keys
Samsung Galaxy Note 8 (8.0.0)=samsung/greatltexx/greatlte:8.0.0/R16NW/N950FXXU3CRC1:user/release-keys
Samsung Galaxy S3 Neo (4.4.4)=samsung/s3ve3gdd/s3ve3gdd:4.4.4/KTU84P/I9300IDDUBQE2:user/release-keys
Samsung Galaxy S4 (5.0.1)=samsung/jfltexx/jflte:5.0.1/LRX22C/I9505XXUHPF4:user/release-keys
Samsung Galaxy S6 (7.0)=samsung/zerofltexx/zeroflte:7.0/NRD90M/G920FXXS5EQL1:user/release-keys
Samsung Galaxy S6 Edge (7.0)=samsung/zeroltexx/zerolte:7.0/NRD90M/G925FXXS5EQL1:user/release-keys
Samsung Galaxy S7 (8.0.0)=samsung/heroltexx/herolte:8.0.0/R16NW/G930FXXU2ERD5:user/release-keys
Samsung Galaxy S7 Edge (8.0.0)=samsung/hero2ltexx/hero2lte:8.0.0/R16NW/G935FXXU2ERD5:user/release-keys
Samsung Galaxy S8 Plus (8.0.0)=samsung/dream2ltexx/dream2lte:8.0.0/R16NW/G955FXXU1CRC7:user/release-keys
Samsung Galaxy S9 (8.0.0)=samsung/starltexx/starlte:8.0.0/R16NW/G960FXXU1ARCC:user/release-keys
Samsung Galaxy S9 Plus (8.0.0)=samsung/star2ltexx/star2lte:8.0.0/R16NW/G965FXXU1ARCC:user/release-keys
Sony Xperia X (8.0.0)=Sony/F5121/F5121:8.0.0/34.4.A.2.32/1455699507:user/release-keys
Sony Xperia X Performance (8.0.0)=Sony/F8131/F8131:8.0.0/41.3.A.2.99/1455830589:user/release-keys
Sony Xperia XZ (8.0.0)=Sony/F8331/F8331:8.0.0/41.3.A.2.99/1455830589:user/release-keys
Sony Xperia XZ1 Compact (8.0.0)=Sony/G8441/G8441:8.0.0/47.1.A.12.119/1601781803:user/release-keys
Sony Xperia Z (5.1.1)=Sony/C6603/C6603:5.1.1/10.7.A.0.228/58103698:user/release-keys
Sony Xperia Z1 (5.1.1)=Sony/C6903/C6903:5.1.1/14.6.A.1.236/2031203603:user/release-keys
Sony Xperia Z2 (6.0.1)=Sony/D6503/D6503:6.0.1/23.5.A.1.291/2769308465:user/release-keys
Sony Xperia Z3 (6.0.1)=Sony/D6633/D6633:6.0.1/23.5.A.1.291/2769308465:user/release-keys
Sony Xperia Z3 Compact (6.0.1)=Sony/D5803/D5803:6.0.1/23.5.A.1.291/2769308465:user/release-keys
Sony Xperia Z3 Tablet Compact (6.0.1)=Sony/SGP621/SGP621:6.0.1/23.5.A.1.291/3706784398:user/release-keys
Sony Xperia Z5 (7.1.1)=Sony/E6603/E6603:7.1.1/32.4.A.1.54/3761073091:user/release-keys
Sony Xperia Z5 Compact (7.1.1)=Sony/E5823/E5823:7.1.1/32.4.A.1.54/3761073091:user/release-keys
Sony Xperia Z5 Dual (7.1.1)=Sony/E6633/E6633:7.1.1/32.4.A.1.54/3761073091:user/release-keys
Vodafone Smart Ultra 6 (5.1.1)=Vodafone/P839V55/P839V55:5.1.1/LMY47V/20161227.134319.15534:user/release-keys
Xiaomi Mi 3/4 (6.0.1)=Xiaomi/cancro/cancro:6.0.1/MMB29M/V9.5.2.0.MXDMIFA:user/release-keys
Xiaomi Mi 5/5 Pro (7.0)=Xiaomi/gemini/gemini:7.0/NRD90M/V9.2.1.0.NAAMIEK:user/release-keys
Xiaomi Mi 5S (7.0)=Xiaomi/capricorn/capricorn:7.0/NRD90M/V9.2.1.0.NAGMIEK:user/release-keys
Xiaomi Mi 5S Plus (6.0.1)=Xiaomi/natrium/natrium:6.0.1/MXB48T/V8.5.2.0.MBGMIED:user/release-keys
Xiaomi Mi 6 (7.1.1)=Xiaomi/sagit/sagit:7.1.1/NMF26X/V8.2.17.0.NCACNEC:user/release-keys
Xiaomi Mi 6 (8.0.0)=Xiaomi/sagit/sagit:8.0.0/OPR1.170623.027/V9.2.3.0.OCAMIEK:user/release-keys
Xiaomi Mi A1 (8.0.0)=xiaomi/tissot/tissot_sprout:8.0.0/OPR1.170623.026/V.9.5.10.0.ODHMIFA:user/release-keys
Xiaomi Mi Max 2 (7.1.1)=Xiaomi/oxygen/oxygen:7.1.1/NMF26F/V9.5.4.0.NDDMIFA:user/release-keys
Xiaomi Mi Note 2 (7.0)=Xiaomi/scorpio/scorpio:7.0/NRD90M/V9.2.1.0.NADMIEK:user/release-keys
Xiaomi Redmi 4 Prime (6.0.1)=Xiaomi/markw/markw:6.0.1/MMB29M/V9.5.3.0.MBEMIFA:user/release-keys
Xiaomi Redmi 4X (6.0.1)=Xiaomi/santoni/santoni:6.0.1/MMB29M/V8.5.4.0.MAMCNED:user/release-keys
Xiaomi Redmi Note 3 Pro (6.0.1)=Xiaomi/kenzo/kenzo:6.0.1/MMB29M/V8.2.1.0.MHOCNDL:user/release-keys
Xiaomi Redmi Note 4/4X (7.0)=xiaomi/mido/mido:7.0/NRD90M/V9.2.1.0.NCFMIEK:user/release-keys
Xiaomi Redmi Note 5/5 Plus (7.1.2)=xiaomi/vince/vince:7.1.2/N2G47H/V9.5.4.0.NEGMIFA:user/release-keys
Xiaomi Redmi Note 5 Pro (8.1.0)=xiaomi/whyred/whyred:8.1.0/OPM1.171019.011/V9.5.6.0.OEIMIFA:user/release-keys
ZTE Axon 7 (7.1.1)=ZTE/P996A01_N/ailsa_ii:7.1.1/NMF26V/20171211.005949:user/release-keys
ZTE Nubia Z17 (7.1.1)=nubia/NX563J/NX563J:7.1.1/NMF26X/eng.nubia.20171019.101529:user/release-keys
Zuk Z2 Pro (7.0)=ZUK/z2_row/z2_row:7.0/NRD90M/2.5.435_170525:user/release-keys
"

if [ -f "$PRINTSFILE" ]; then
	FLINE=$(head -1 $PRINTSFILE)
	if [ "$FLINE" ]; then
		sed -i '1s/^/\n/' $PRINTSFILE
	fi
	LISTFILE=$(cat $PRINTSFILE)
	PRINTSLIST=$PRINTSLIST$LISTFILE
fi
