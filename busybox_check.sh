# Busybox Check
# ----------------------------------------
MAGIMG=/sbin/.magisk/img
alias wget="/sbin/.core/busybox/wget"
alias grep="/sbin/.core/busybox/grep"
BBPATH=$MAGIMG/busybox-ndk
BBMAG=$MAGIMG/busybox-ndk/system/xbin/busybox

if [[ -d "$BBPATH" && -e "$BBMAG" ]]; then
    echo Busybox is installed
	touch /sbin/.magisk/img/energizedprotection/busybox_install
	chmod 777 /sbin/.magisk/img/energizedprotection/busybox_install
else
	echo - Processing Busybox setup
	echo -e "\n\n=====================================\n\nBusybox Installer Script\nPorted to works with Energized by Rom\nAll credits to osm0sis @ xda-developers\n\n=====================================\n\n"
	mkdir -p /dev/tmp/Busybox-dl
	test -d /dev/tmp/Busybox-dl && INSTALLER=/dev/tmp/Busybox-dl
	echo - Downloading...
	wget --no-check-certificate -q -O $INSTALLER/busybox-ndk.zip https://codeload.github.com/Magisk-Modules-Repo/busybox-ndk/zip/master
	
	ZIPFILE=$INSTALLER/busybox-ndk.zip
	
	test -e /data/adb/magisk && adb=adb
	
	dev=/dev
	devtmp=/dev/tmp
	if [ ! -f /data/$adb/magisk_merge.img ]; then
		(/system/bin/make_ext4fs -b 4096 -l 64M /data/$adb/magisk_merge.img || /system/bin/mke2fs -b 4096 -t ext4 /data/$adb/magisk_merge.img 64M) >/dev/null;
	fi
	test -e /magisk/.core/busybox && magiskbb=/magisk/.core/busybox
	test -e /sbin/.core/busybox && magiskbb=/sbin/.core/busybox
	test "$magiskbb" && export PATH="$magiskbb:$PATH"
	
	zipextract=busybox-ndk
	
	test -f /system/build.prop && root=/system
	
	choice=$(basename "$ZIPFILE")
	
	action=installation
	nolinks=1
	
	echo - Extracting files...
	
	mkdir -p $dev/tmp/$zipextract
	
	unzip -o "$ZIPFILE" module.prop 'busybox*' -d $dev/tmp/$zipextract >&2
	mv -f $dev/tmp/$zipextract/busybox-ndk-master/* $dev/tmp/$zipextract/
	chmod 0777 $dev/tmp/$zipextract/*
	
	echo Installing...
	
	abi=`getprop ro.product.cpu.abi`;
	case $abi in
		arm*|x86*|mips*) ;;
		*) abi=`getprop ro.product.cpu.abi`;;
	esac
	case $abi in
		arm*|x86*|mips*) ;;
		*) abi=`getprop ro.product.cpu.abi $root/default.prop`;;
	esac
	case $abi in
		arm64*) arch=arm64;;
		arm*) arch=arm;;
		x86_64*) arch=x86_64;;
		x86*) arch=x86;;
		mips64*) arch=mips64;;
		mips*) arch=mips;;
		*) echo "Unknown architecture: $abi"; abort; exit 2;;
	esac
	
	echo "Using architecture: $arch"
	
	if [ -e /data/$adb/magisk -a ! -e /data/$adb/magisk.img ]; then
	make_ext4fs -b 4096 -l 64M /data/$adb/magisk.img || mke2fs -b 4096 -t ext4 /data/$adb/magisk.img 64M
	fi
	
	suimg=$(ls /data/$adb/magisk_merge.img || ls /data/$adb/magisk.img || ls /cache/magisk.img) 2>/dev/null;
	mnt=$devtmp/magisk_merge
	
	test ! -e $mnt && mkdir -p $mnt
	mount -t ext4 -o rw,noatime $suimg $mnt
	
	modname=busybox-ndk
	
	magisk=/$modname/system
	
	target=$mnt$magisk/xbin
		
	echo "Using path: $target"
	
	mkdir -p $target
	
	TMPBUSYBOXDIR=$dev/tmp/busybox-ndk
	
	cp -f $TMPBUSYBOXDIR/busybox-$arch $target/busybox
	chown 0:0 "$target/busybox"
	chmod 755 "$target/busybox"
	cp -f $TMPBUSYBOXDIR/module.prop $mnt/$modname/
	touch $mnt/$modname/auto_mount
	imgmnt=/sbin/.magisk/img
	mkdir -p "$imgmnt/$modname"
	touch "$imgmnt/$modname/update"
	cp -f $TMPBUSYBOXDIR/module.prop "$imgmnt/busybox-ndk/"
	
	
	echo -e "\nCleaning...\n"
	
	cleanup="$mnt$magisk/xbin $target"
	
	for dir in $cleanup; do
		cd $dir
		for i in $(ls -al `find -type l` | $target/busybox awk '{ print $(NF-2) ":" $NF }'); do
			case $(echo $i | $target/busybox cut -d: -f2) in
				*busybox) list="$list $dir/$(echo $i | $target/busybox cut -d: -f1)";;
			esac
		done
	done
	
	echo "Creating symlinks..."
	sysbin="$(ls $root/bin)"
	existbin="$(ls $imgmnt/busybox-ndk/system/bin 2>/dev/null)"
	for applet in `$target/busybox --list`; do
		case $target in
			*/bin)
				if [ "$(echo "$sysbin" | $target/busybox grep "^$applet$")" ]; then
					if [ "$(echo "$existbin" | $target/busybox grep "^$applet$")" ]; then
						$target/busybox ln -sf busybox $applet
					fi
				else
					$target/busybox ln -sf busybox $applet
				fi
				;;
				*) $target/busybox ln -sf busybox $applet;;
		esac
	done
		
	test "$magisk" && chcon -hR 'u:object_r:system_file:s0' "$mnt/$modname"
	# rm -rf /dev/tmp
		
	echo -e "\n- Done!\n- Reboot to apply changes\n\n"
	touch $mnt/$modname/busybox_install
	chmod 777 $mnt/$modname/busybox_install
	exit 1
fi
