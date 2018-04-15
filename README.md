# MagiskHide Props Config
## By Didgeridoohan @ XDA Developers


[Support Thread @ XDA](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199)


## Installation
Install through the Magisk Manager Downloads section. Or, download the zip from the Manager or the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199), and install through the Magisk Manager -> Modules, or from recovery.

The current release is always attached to the OP of the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199). Any previous releases can be found on [GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/releases).


## Usage
After installing the module and rebooting, run the command `props` (as su) in a terminal emulator (you can find a one on [F-Droid](https://f-droid.org/) or in the [Play Store](https://play.google.com/store/apps)), and follow the instructions to set your desired options.
```
su
props
```
You can also run the command with options. Use -h for details.


## Spoofing device's fingerprint
If your device can't pass SafetyNet fully, the CTS profile check fails while basic integrity passes, that means MagiskHide is working on your device but Google doesn't recognise your device as being certified.

This might be because your device simply hasn't been certified or that the ROM you are using on your device isn't recognised by Google (because it's a custom ROM). 

To fix this, you can use a known working fingerprint (one that has been certified by Google), usually from a stock ROM/firmware/factory image, and replace your device's current fingerprint with this. You can also use a fingerprint from another device, but this will change how your device is perceived.

There are a few pre-configured certified fingerprints available in the module, just in case you can't get a hold of one for your device. If you have a working fingerprint that could be added to the list, or an updated one for one already on there, please post that in the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199) toghether with device details.

### Finding a certified fingerprint
The easies way to find a certified fingerprint for your device is to run the getprop command below on a stock ROM/firmware/factory image that fully passes SafetyNet.
```
getprop ro.build.fingerprint
```
If you're already on a custom ROM that can't pass the CTS profile check, this might not be an option... Head over to your device's forum and ask for help. If someone can run the getprop command on their device for you, you're good to go.

### Custom fingerprints list
You can add your own fingerprint to the list by placing a file, named `printslist`, in the root of your internal storage with the fingerprint. It needs to be formated as follows:`device name=fingerprint`.
Here's an example:
```
Google Nexus 6=google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
```


## Current fingerprints list version
The fingerprints list will update without the need to update the entire module. Keep an eye on the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199) for info.

Just run the `props` command and the list will be updated automatically. Use the -nw option to disable.

**_Current fingerprints list version - v6_**


## Improved root hiding - Editing build.prop and default.prop
Some apps and services look at the actual files, rather than the set prop values. With this module feature you can make sure that the actual prop in build.prop and default.prop is changed to match whatever value the prop has been set to by either MagiskHide or the module. If there's a prop value set by the module (see below), that value takes precedence.


## Set/reset MagiskHide Sensitive props
By default, if MagiskHide detects certain sensitive prop values they will be changed to known safe values. These are currently:
- ro.debuggable (set to "0" by MagiskHide - sensitive value is "1")
- ro.secure (set to "1" by MagiskHide - sensitive value is "0")
- ro.build.type (set to "user" by MagiskHide - sensitive value is "userdebug")
- ro.build.tags (set to "release-keys" by MagiskHide - sensitive value is "test-keys" or "dev-keys")
- ro.build.selinux (set to "0" by MagiskHide - sensitive value is "1")

If, for some reason, you need one or more of these to be kept as their original value (one example would be resetting ro.build.type to userdebug since some ROMs need this to work properly), you can reset to the original value with this module. Keep in mind that this might trigger some apps looking for these prop values as a sign of your device being rooted.


## Change/set custom prop values
It's quite easy to change prop values with Magisk. With this module it's even easier. Just enter the prop you want to change and the new value and the module does the rest, nice and systemless. Any changes that you've previously done directly to build.prop you can now do with this module instead.


## Prop script options
There are a couple of persistent options that you can set for the `props` script. These are currently "Colour" and "Fingerprints list check". The colour option disables or enables colours for the script, and the fingerprints list check option disables or enables automatic updating of the fingerprints list when the script starts. If the fingerprints list check is disabled, the list can be manually updated from within the script, under the "Device fingerprint" menu.


## Configuration file
You can use a configuration file to set your desired options, rather than running the `props` command. Download the [settings file](https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/propsconf_conf) or extract it from the module zip (in the common folder), fill in the desired options (follow the instructions in the file), place it in /cache (or /data/cache if you're using an A/B device) and reboot. This can also be done directly at the first install (through Manager or recovery), before even rebooting your device. Instant settings.


## Device issues because of the module
In case of issues, if you've set a prop value that doesn't work on your device causing it not to boot, etc, don't worry. There are options. You can follow the advice in the [troubleshooting guide](https://www.didgeridoohan.com/magisk/Magisk#hn_Module_causing_issues_Magisk_functionality_bootloop_loss_of_root_etc) to remove or disable the module, or you can use the module's built-in options to reset all module settings to the defaults.

Place a file named `reset_mhpc` in /cache (or /data/cache on A/B devices) and reboot.

It is possible to use this in combination with the configuration file described above to keep device fingerprint or any other settings intact past the reset. Just make sure to remove any custom props that might have been causing issues from the configuration file.


## Certifying your device
If you're using a custom ROM, the chances of it being [perceived as uncertified by Google](https://www.xda-developers.com/google-blocks-gapps-uncertified-devices-custom-rom-whitelist/) are pretty high. If your ROM has a build date later than March 16 2018, this might mean that you can't even log into your Google account or use Gapps without [whitelisting your device with Google](https://www.google.com/android/uncertified/) first.

Magisk, and this module, can help with that.

Before setting up your device, install Magisk, this module and use the configuration file described above to pass the ctsProfile check. This should make your device be perceived as certified by Google and you can log into your Google account and use your device without having to whitelist it. Check [here](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/common/prints.sh) for usable fingerprints (only use the part to the right of the equal sign).

If you're having issues getting your device certified, take a look in the troubleshooting guide linked below.


## Miscellaneous MagiskHide issues
If you're having issues passing SafetyNet, getting your device certified, or otherwise getting MagiskHide to work, take a look in the [Magisk and MagiskHide Installation and Troubleshooting Guide](https://www.didgeridoohan.com/magisk). Lots of good info there (if I may say so myself)...

But first: have you tried turning it off and on again? Toggling MagiskHide off and on usually works if MagiskHide has stopped working after an update of Magisk or your ROM.


## Support, etc
If you have questions, suggestions or are experiencing some kind of issue, visit the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199) @ XDA.

### Logs, etc
In case of issues, please provide the logs, saved in /cache, "propsconf.log" and "propsconf_last.log", together with a detailed description of your problem. Providing the output from terminal might also be useful.


## Source
[GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config)


## Credits
@topjohnwu @ XDA Developers, for Magisk  
@Zackptg5, @veez21 and @jenslody @ XDA Developers, for inspiration


## Changelog
### v2.0.0  
- Added a function for setting your own custom prop values.
- Added a function for setting values by configuration file. Useful if you want to make a ROM pass the ctsProfile check out of the box.
- Added a function for resetting the module by placing a specific file in /cache. Useful if a custom prop is causing issues.
- Added a function to set options for the props script. See the documentation for details.
- Added command option to not check online for new fingerprints list at start. Run `props` with the -h option for details.
- Restructured the fingerprints list menu. Sorted by manufacturer for easier access.
- New and updated fingerprints (lots), list v6.
- Minor fixes and improvements.

### v1.2.1  
- Fixed logic for checking the original prop values.
- New fingerprints (Xiaomi Mi 5, ZTE Axon 7), list v4.
- Minor fixes.

### v1.2.0  
- Now in the Magisk repo. Updated to match.
- New fingerprint (Pixel 2), list v3.
- Show info when checking for fingerprint updates.
- Minor changes and improvements.

### v1.1.0  
- New fingerprint added (Sony Xperia Z3).
- Added the ability to update the fingerprints list automatically

### v1.0.0  
- Initial release. Compatible with Magisk v15+.


## Current fingerprints list
### List v6  
- Google Nexus 6 (7.1.1)
- Google Pixel (8.1.0)
- Google Pixel 2 (P DP1)
- Google Pixel 2 XL (8.1.0)
- HTC 10 (6.0.1)
- Huawei Mate 10 Pro (8.0.0)
- Motorola Moto G4 (7.0)
- Motorola Moto G5 (7.0)
- Motorola Moto G5 Plus (7.0)
- Nvidia Shield K1 (7.0)
- OnePlus 3T (8.0.0)
- OnePlus 5T (7.1.1)
- OnePlus 5T (8.0.0)
- Samsung Galaxy Grand Prime (5.0.2)
- Samsung Galaxy Note 3 (7.1.1)
- Samsung Galaxy Note 4 (6.0.1)
- Samsung Galaxy Note 5 (7.0)
- Samsung Galaxy S6 (5.0.2)
- Samsung Galaxy S7 (7.0)
- Samsung Galaxy S7 Edge (7.0)
- Samsung Galaxy S8 Plus (7.0)
- Samsung Galaxy S8 Plus (8.0.0)
- Sony Xperia X Performance (8.0.0)
- Sony Xperia XZ (8.0.0)
- Sony Xperia XZ1 Compact (8.0.0)
- Sony Xperia Z3 (6.0.1)
- Vodafone Smart Ultra 6 (5.1.1)
- Xiaomi Mi 5 (7.0)
- Xiaomi Mi 5S (7.0)
- Xiaomi Mi 5S Plus (6.0.1)
- Xiaomi Mi6 (7.1.1)
- Xiaomi Redmi 4X (6.0.1)
- Xiaomi Redmi Note 3 Pro (6.0.1)
- Xiaomi Redmi Note 4/4X (7.0)
- ZTE Axon 7 (7.1.1)
- Zuk Z2 Pro (7.0)
