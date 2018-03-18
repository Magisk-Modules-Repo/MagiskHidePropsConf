# MagiskHide Props Config
## By Didgeridoohan @ XDA Developers


## Installation
Download the zip from the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199), and install through the Magisk Manager -> Modules, or from recovery.
Any previous versions are kept in the first post of the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199).


## Use
Run the command `props` (as su) in a terminal emulator (you can find a one on [F-Droid](https://f-droid.org/) or in the [Play Store](https://play.google.com/store/apps)).
```
su
props
```
You can also run the command with options. Use -h or --help for details.


## Spoofing device's fingerprint
If your device can't pass SafetyNet fully, the CTS profile check fails while basic integrity passes, that means MagiskHide is working on your device but Google doesn't recognise your device as being certified.

This might be because your device simply hasn't been certified or that the ROM you are using on your device isn't recognised by Google (because it's a custom ROM). 

To fix this, you can use a known working fingerprint (one that has been certified by Google), usually from a stock ROM/firmware/factory image, and replace your device's current fingerprint with this.

Keep in mind that changing the fingerprint of your device might have some side-effects, since you are changing how your device is percieved. Most of the times it works fine though. IMO it is preferable to use a fingerprint from a stock ROM for your specific device.

There are a few pre-configured certified fingerprints available in the module, just in case you can't get a hold of one for your device. If you have a working fingerprint that could be added to the list, or an updated one for one already on there, please post that in the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199) toghether with device details.

### Finding a certified fingerprint
The easies way to find a certified fingerprint for your device is to run the getprop command below on a stock ROM/firmware/factory image that fully passes SafetyNet.
```
getprop ro.build.fingerprint
```
If you're already on a custom ROM that can't pass the CTS profile check, this might not be an option... Head over to your device's forum and ask for help. If someone can run the getprop command on their device for you, you're good to go.

### Custom fingerprints list
You can add your own fingerprint to the list by placing a file in the root of your internal storage with the fingerprint. It needs to be formated as follows:`<device name>=<fingerprint>`.
Here's an example:
```
Google Nexus 6=google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
```


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


## Miscellaneous
If you're having issues passing SafetyNet or otherwise getting MagiskHide to work, take a look in the [Magisk and MagiskHide Installation and Troubleshooting Guide](https://www.didgeridoohan.com/magisk). Lots of good info there (if I may say so myself)...


## Support, etc
If you're having issues, questions or suggestions, visit the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-simple-t3765199) @XDA.


## Source
[GitHub](https://github.com/Didgeridoohan/MagiskHide-Props-Config)


## Credits
@topjohnwu @ XDA Developers, for Magisk  
@Zackptg5 and @veez21 @ XDA Developers, for inspiration


## Changelog
### v1.0.0  
- Initial release. Compatible with Magisk v15+.
