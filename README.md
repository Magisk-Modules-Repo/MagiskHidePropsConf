# MagiskHide Props Config
## By Didgeridoohan @ XDA Developers


[Support Thread @ XDA](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199)


## Installation
Install through the Magisk Manager Downloads section. Or, download the zip from the Manager or the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199), and install through the Magisk Manager -> Modules, or from recovery.

The current release is always attached to the OP of the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199). Any previous releases can also be found on [GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/releases). If downloading a release from GitHub, make sure to repackage the zip with all the module files and folders in the root of the zip. Otherwise it won't install (error: "not a Magisk zip").


## Usage
After installing the module and rebooting, run the command `props` (as su) in a terminal emulator (you can find a one on [F-Droid](https://f-droid.org/) or in the [Play Store](https://play.google.com/store/apps)), and follow the instructions to set your desired options.
```
su
props
```
You can also run the command with options. Use -h or --help for details.


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

Just run the `props` command and the list will be updated automatically.

**_Current fingerprints list version - v5_**


## Editing build.prop and default.prop
Some apps and services look at the actual files, rather than the set prop values. With this module feature you can make sure that the actual prop in build.prop and default.prop is changed to match whatever value the prop has been set to by either MagiskHide or the module. If there's a prop value set by the module (see below), that value takes precedence.


## Set/reset MagiskHide Sensitive props
By default, if MagiskHide detects certain sensitive prop values they will be changed to known safe values. These are currently:
- ro.debuggable (set to "0" by MagiskHide - sensitive value is "1")
- ro.secure (set to "1" by MagiskHide - sensitive value is "0")
- ro.build.type (set to "user" by MagiskHide - sensitive value is "userdebug")
- ro.build.tags (set to "release-keys" by MagiskHide - sensitive value is "test-keys")
- ro.build.selinux (set to "0" by MagiskHide - sensitive value is "1")

If, for some reason, you need one or more of these to be kept as their original value (one example would be resetting ro.build.type to userdebug since some ROMs need this to work properly), you can reset to the original value with this module. Keep in mind that this might trigger some apps looking for these prop values as a sign of your device being rooted.

You can also use this module to set these props to your preferred value with MagiskHide disabled.


## Miscellaneous MagiskHide issues
If you're having issues passing SafetyNet or otherwise getting MagiskHide to work, take a look in the [Magisk and MagiskHide Installation and Troubleshooting Guide](https://www.didgeridoohan.com/magisk). Lots of good info there (if I may say so myself)...


## Support, etc
If you have questions, suggestions or are experiensing some kind of issue, visit the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199) @XDA.

### Logs, etc
In case of issues, please provide the logs, saved in /cache, "propsconf.log" and "propsconf_last.log", together with a detailed description of your problem. Providing the output from terminal might also be useful.


## Source
[GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config)


## Credits
@topjohnwu @ XDA Developers, for Magisk  
@Zackptg5 and @veez21 @ XDA Developers, for inspiration


## Changelog
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
### List v5  
- Google Nexus 6 (7.1.1)
- Google Pixel 2 (P DP1)
- Google Pixel 2 XL (8.1.0)
- OnePlus 3T (8.0.0)
- OnePlus 5T (7.1.1)
- Samsung Galaxy Grand Prime (5.0.2)
- Samsung Galaxy Note 4 (6.0.1)
- Samsung Galaxy S7 (7.0)
- Samsung Galaxy S8 Plus (8.0.0)
- Sony Xperia XZ1 Compact (8.0.0)
- Sony Xperia Z3 (6.0.1)
- Xiaomi Mi 5 (7.0)
- Xiaomi Mi 5S (7.0)
- Xiaomi Mi 5S Plus (6.0.1)
- Xiaomi Mi6 (7.1.1)
- ZTE Axon 7 (7.1.1)
