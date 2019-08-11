# MagiskHide Props Config
## By Didgeridoohan @ XDA Developers


<a href="https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228"><img src="https://img.shields.io/badge/-XDA-orange.svg"></a> [Support Thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228)

<a href="https://www.paypal.me/didgeridoohan"><img src="https://img.shields.io/badge/-PayPal-blue.svg"></a> If you find the module useful, please don't hesitate to [support the work involved](https://www.paypal.me/didgeridoohan).

## What's this?
This module is a very complicated way of doing something very simple. Complicated for me, that is... The aim is to make it easy for you, the user. The module changes prop values using the [Magisk resetprop tool](https://github.com/topjohnwu/Magisk/blob/master/docs/tools.md#resetprop), something that is very easy to do with a [Magisk boot script](https://github.com/topjohnwu/Magisk/blob/master/docs/details.md#magisk-booting-process) and some simple commands. This is very useful for a lot of things, among others to help pass the SafetyNet CTS Profile check on custom and uncertified ROMs. And of course for any normal modification of your device that is done by altering build.prop or similar files.

What this module does is that it adds a terminal based UI for those that don't want (or can't) create a boot script for themselves, making the process of creating such a boot script very simple. With this module I'm also maintaining a list of certified build fingerprints for a number of devices, so that it's easy to pick one you want to use.

Keep reading below to find out more details about the different parts of the module


## Documentation index
##### Installation and usage
- [Prerequisites](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#prerequisites)
- [Installation](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#installation)
- [Usage](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#usage)
##### Passing SafetyNet's CTS Profile
- [Spoofing device's fingerprint to pass the ctsProfile check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#spoofing-devices-fingerprint-to-pass-the-ctsprofile-check)
  - [Use vendor fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#use-vendor-fingerprint-for-treble-gsi-roms)
  - [Matching the Android security patch date](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#matching-the-android-security-patch-date)
  - [Can I use any fingerprint?](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#can-i-use-any-fingerprint)
  - [Finding a certified fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#finding-a-certified-fingerprint)
    - [The getprop method](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#the-getprop-method)
    - [The stock ROM/firmware/factory image method](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#the-stock-romfirmwarefactory-image-method)
    - [The firmware.mobi method](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-firmwaremobi-method)
  - [Custom fingerprints list](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#custom-fingerprints-list)
  - [I still can't pass the ctsProfile check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-still-cant-pass-the-ctsprofile-check)
- [Keeping your device "certified"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#keeping-your-device-certified)
- [Current fingerprints list version](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#current-fingerprints-list-version)
- [Please add support for device X](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#please-add-support-for-device-x)
- [Please update fingerprint X](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#please-update-fingerprint-x)
##### Device simulation
- [Device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation)
##### Improved root hiding
- [Improved root hiding - Editing build.prop and default.prop](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#improved-root-hiding---editing-buildprop-and-defaultprop)
##### MagiskHide props
- [Set/reset MagiskHide Sensitive props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#setreset-magiskhide-sensitive-props)
##### Custom props
- [Change/set custom prop values](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values)
- [Removing prop values](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#removing-prop-values)
##### Settings, etc
- [Prop script settings](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#prop-script-settings)
  - [Boot stage](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#boot-stage)
  - [Script colours](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#script-colours)
  - [Fingerprints list check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#fingerprints-list-check)
  - [Automatic fingerprint update](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#automatic-fingerprint-update)
- [Configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file)
  - [Setting up the module on a clean Magisk/ROM flash](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#setting-up-the-module-on-a-clean-magiskrom-flash)
##### Issues and logs
- [Miscellaneous MagiskHide issues](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#miscellaneous-magiskhide-issues)
- [Issues, support,etc](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#issues-support-etc)
  - [Known issues](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#known-issues)
  - [Requires Magisk v19+](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#requires-magisk-v19)
  - [An option is marked as "disabled"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#an-option-is-marked-as-disabled)
  - [I can't pass the ctsProfile check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-cant-pass-the-ctsprofile-check)
  - [I can't pass the basicIntegrity check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-cant-pass-the-basicintegrity-check)
  - [Props don't seem to set properly](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#props-dont-seem-to-set-properly)
  - [My device's Android security patch date changed](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#my-devices-android-security-patch-date-changed)
  - [Device issues because of the module](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#device-issues-because-of-the-module)
  - [The Play Store is "uncertified"](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#the-play-store-is-uncertified)
- [Logs](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#logs)
  - [Collecting logs manually](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#collecting-logs-manually)
##### Miscellaneous
- [Donations](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#donations)
- [Source](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#source)
- [Credits](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#credits)
- [Changelog](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changelog)
- [Current fingerprints list](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#current-fingerprints-list)
- [Licence](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#mit-licence)


## Prerequisites
- Magisk v19+.
- Busybox, preferably @osm0sis' (installable from the Magisk Manager Downloads).


## Installation
Install through the Magisk Manager Downloads section. Or, download the zip from the Manager or the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228), and install through the Magisk Manager -> Modules, or from recovery.

The current release is always attached to the OP of the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228). Any previous releases can be found on [GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/releases).


## Usage
After installing the module and rebooting, run the command `props` in a terminal emulator (you can find a one on [F-Droid](https://f-droid.org/) or in the [Play Store](https://play.google.com/store/apps)), and follow the instructions to set your desired options. If you use Termux, you'll have to call su before running the command.

You can also run the command with options. Use -h for details.

If you want further details as to what this module does and can do, keep reading. To get an overview of what is available, take a look at the index above. If experiencing issues, take a look at the part about [Issues, support,etc](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#issues-support-etc), and don't forget to provide [logs](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#logs) when asking for help.


## Spoofing device's fingerprint to pass the ctsProfile check
If your device can't pass SafetyNet fully, the CTS profile check fails while basic integrity passes, that means MagiskHide is working on your device but Google doesn't recognise your device as being certified (if basic integrity fails there is nothing this module can do, please check [I can't pass the basicIntegrity check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-cant-pass-the-basicintegrity-check)).

This might be because your device simply hasn't been certified or that the ROM you are using on your device isn't recognised by Google (because it's a custom ROM). 

To fix this, you can use a known working device fingerprint (`ro.build.fingerprint`), one that has been certified by Google, usually from a stock ROM/firmware/factory image, and replace your device's current fingerprint with this. You can also use a fingerprint from another device, but this will change how your device is perceived.

NOTE: If you're using a fingerprint for an Android build after March 16th 2018 you might have to change the security patch date to one that matches the fingerprint used. You can use the [Custom prop](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) function of this module to change `ro.build.version.security_patch` to the desired date. If you don't know the security patch date you can try finding it with trial and error (although it's a much better option to find the actual date from the ROM/firmware/factory image in question). The dates are always either the 1st or the 5th of the month, so try different months one after the other until the CTS profile passes.

There are a bunch of tested certified fingerprints available in the module, just in case you can't get a hold of one for your device. For some devices there are several fingerprints available, for different Android versions. When picking a fingerprint you will also have to pick which version you need. If you have a working fingerprint that could be added to the list, or an updated one for one already on there, please post that in the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228) toghether with device details. Please also include the Android security patch date for the factory image/firmware/ROM that the fingerprint comes from.

After having applied a device fingerprint from the module, whenever that particular print is updated in the included prints list, the chosen fingerprint will be automatically updated when the fingerprints list is. Just reboot to apply the new fingerprint. If there are several fingerprints available for the same device, this option only applies for fingerprints of the same Android version. In that case, if you want to update to a newer version you will have to update the fingerprint manually.

If you are using a Treble GSI ROM you can enable the [Use vendor fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#use-vendor-fingerprint-for-treble-gsi-roms) option (for more details, see below) in the `Edit device fingerprint` menu.

### Use vendor fingerprint (for Treble GSI ROMs)
When using a Treble GSI ROM with a stock vendor partition, it is possible to use the vendor fingerprint to make the device pass the CTS profile check. Enabling this option will make the module scripts pull the vendor fingerprint on each boot and use this to spoof the device fingerprint. This in turn means you will only have to enable this option once and even if you update your vendor partition the fingerprint used will always be the latest one.

### Matching the Android security patch date
For some devices, if the fingerprint is for an Android build after March 16th 2018, it is necessary to use a security patch date that matches the fingerprint used. For the module provided fingerprints this is done automatically, but if you enter a fingerprint manually you will have to update the security patch date yourself (if they don't already match). Use the [Custom props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) function of this module to change `ro.build.version.security_patch` to the desired date.

### Can I use any fingerprint?
It's usually possible to use any fingerprint that's certified for your device. It doesn't have to match, either device or Android version. If you don't use a fingerprint for your device, the device might be percieved as the device that the fingerprint belongs to, in certain situations (Play Store, etc). The Android version doesn't matter much, and if you're using a ROM with an Android version much newer than what is officially available for your device, you are going to have to use an older fingerprint if you want to use the one for your device. But, like already stated, that doesn't really matter (most of the time, there might of course be exceptions).

### Finding a certified fingerprint
If you need a certain fingerprint from a device, here are a few tips on how to find it. Also remember that you might need to get the security patch date that corresponds to the fingerprint you find (see [Matching the Android security patch date](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#matching-the-android-security-patch-date) above).

Also make sure that you get the actual device fingerprint, since there might be props that look similar to what you need. Here's an example, taken from a Google Nexus 6 (named Shamu):
```
google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
```

#### The getprop method
You can get a certified fingerprint for your device by running the getprop command below on a stock ROM/firmware/factory image that fully passes SafetyNet.
```
getprop ro.build.fingerprint
```
If you're already on a custom ROM that can't pass the CTS profile check, this might not be an option... Head over to your device's forum and ask for help. If someone can run the getprop command on their device for you, you're good to go. Or, you can try the other method described below.

*Note that this is the only surefire way of getting the proper fingerprint.*

#### The stock ROM/firmware/factory image method
Another way to find a certified fingerprint is to download a stock ROM/firmware/factory image for your device and extract the fingerprint from there.

*Note that this is possibly not the best way of finding the fingerprint. Using getprop is always preferred.*
The main problem is that it might be hard to find the actual, certified fingerprint since there might also be other similar props that aren't certified. The above mentioned getprop method is always preferred...

You can find the file to download in your device's forum on XDA Developers (either as a firmware file, a proper stock ROM, or in the development section as a debloated stock ROM), from the manufacturer's website, or elsewhere on the great interweb (just remember to be careful when downloading unknown files, it's dangerous to go alone!).

Once you have the file downloaded, there are several different ways that the fingerprint can be found. In all cases you'll have to access the file somehow, and in most cases it's just a matter of unpackaging it. After that it depends on how the package is constructed.

- Sometimes there'll be a build.prop file directly in the zip/package. You might find the fingerprint in there.
- For some devices you'll have to unpack the system.img to get to the build.prop or default.prop file, where you might find the info you want.This can sometimes be done with a simple archive app/program, but sometimes more advanced utilities are needed. On Windows, you can use something like [this tool](https://forum.xda-developers.com/showpost.php?p=57742855&postcount=42). You'll also find more info in the [main thread for that post](https://forum.xda-developers.com/android/software-hacking/how-to-conver-lollipop-dat-files-to-t2978952).
- Other times you'll find the fingerprint in META-INF\com\google\android\updater-script. Look for "Target:" and you'll likely find the fingerprint there.
- Etc... Experiment, the fingerprint will be in there somewhere. 

#### The firmware.mobi method
Sometimes you can also find up to date and certified fingerprints at [firmware.mobi](https://desktop.firmware.mobi/).

### Custom fingerprints list
You can add your own fingerprint to the list by placing a file, named `printslist` (no file extension), in the root of your internal storage with the fingerprints. It needs to be formated as follows: `device name=fingerprint`. The fingerprints added to this list will be found under the `Custom` category in the fingerprints menu. If you create the printslist file in Windows, make sure that you use a text editor that can handle [Unix file endings](https://en.m.wikipedia.org/wiki/Newline), such as Notepad++ and similar editors (not regular Notepad).
Here's an example:
```
Google Nexus 6=google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
```
NOTE: If you're using a fingerprint for an Android build after March 16th 2018 you might have to change the security patch date to one that matches the fingerprint used. This can be done directly in the fingerprints list, by adding two underscores directly followd by the date at the end of the fingerprint (`__2018-09-05`). You can also use the [Custom props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) function of this module to change `ro.build.version.security_patch` to the desired date. If you don't know the security patch date you can try finding it with trial and error. The dates are always either the 1st or the 5th of the month, so try different months one after the other until the CTS profile passes.


### I still can't pass the ctsProfile check
If you've picked a certified fingerprint from the provided list, or you're using a fingerprint that you know is certified but still can't pass the ctsProfile check, try one or more of the following:
- First, do you pass basicIntegrity? If you don't, there's something else going on that this module can't help you with. Take a look under ["Miscellaneous MagiskHide issues"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#miscellaneous-magiskhide-issues) below.
- Go to the "Edit fingerprints menu", select "Boot stages", and start by changing the security patch date boot stage to either default or post-fs-data. If that doesn't work, also try changing the fingerprint boot stage to post-fs-data. The default boot stage can also be changed if you go into the script options and change the boot stage to post-fs-data. See ["Boot stage"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#boot-stage) below.
- Try a different fingerprint (pick one from the provided list).
- If you're not using one of the fingerprints provided in the module, make sure you have a matching security patch date set in [Custom props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values). See ["Matching the Android security patch date"](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#matching-the-android-security-patch-date) above.
- Some ROMs will just not be able to pass the ctsProfile check, if they contain signs of a rooted/modified device that Magisk can't hide, or that they are built in a way that makes it impossible to pass SafetyNet. Check in your ROM thread or with the creator/developer.
- You might have remnants of previous modifications that trigger SafetyNet on your device. A clean install of your system may be required.
- If you can't get things working, and want help, make sure to provide logs and details. See ["Logs"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#logs) below.


## Keeping your device "certified"
If you're using a custom ROM, the chances of it being [perceived as uncertified by Google](https://www.xda-developers.com/google-blocks-gapps-uncertified-devices-custom-rom-whitelist/) are pretty high. If your ROM has a build date later than March 16 2018, this might mean that you can't even log into your Google account or use Gapps without [whitelisting your device with Google](https://www.google.com/android/uncertified/) first.

Magisk, and this module, can help with that.

Before setting up your device, install Magisk, this module and use the configuration file described below to pass the ctsProfile check. This should make your device be perceived as certified by Google and you can log into your Google account and use your device without having to whitelist it. Check [here](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/common/prints.sh) for usable fingerprints (only use the part to the right of the equal sign).

If you're having issues getting your device certified, take a look in the Magisk troubleshooting guide linked below.

In case you can't get the Play Store to report your device as "certified", see ["Issues"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#issues-support-etc) below.

## Current fingerprints list version
The fingerprints list will update without the need to update the entire module. Keep an eye on the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228) for info.

Just run the `props` command and the list will be updated automatically. Use the -nw option to run the script without updating the list or disable it completely in the script settings (see ["Prop script settings"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#prop-script-settings) below). If you've disabled the this setting you can update the list manually in the `Edit device fingerprint` menu or by running the `props` command with the -f option.

If you already have a device fingerprint set by the module, and it has been updated in the current fingerprints list, it will be automatically updated when the prints list gets an update. Just reboot to apply. This function can be turned of in the script settings (see ["Prop script settings"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#prop-script-settings) below)

**_Current fingerprints list version - v62_**


## Please add support for device X
Adding device fingerprints to the list relies heavily on the users. You guys. I've looked up a fingerprint from time to time, but it is a bit time consuming and I don't have that time...
	
If you want a specific device fingerprint to be added to the module, see [Finding a certified fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#finding-a-certified-fingerprint) above. If you can find a fingerprint for the device you have in mind, post it in the thread. I'll test it out and if it passes the ctsProfile check I'll add it to the list. Please also include the Android security patch date for the factory image/firmware/ROM that the fingerprint comes from.


## Please update fingerprint X
Fingerprints included in the module are updated once in a while. Mainly if a user (that's you) provides the updated fingerprint, but sometimes I do look up new fingerprints on [firmware.mobi](https://desktop.firmware.mobi). That is purely based on how much time I have on my hands and how bored I am though...

If you have an updated fingerprint available (and you've posted it for me to update the list), but I haven't yet updated the fingerprints list (which might be a while depending on how much IRL stuff I have to do), it is still perfectly possible for you to use the updated fingerprint.

You can enter the fingerprint manually in the `Edit device fingerprint` menu in the module, you can use the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#configuration-file), or you can make a [custom fingerprints list](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#custom-fingerprints-list).


## Device simulation
**_NOTE! This feature is not needed to pass SafetyNet's CTS profile test and may even cause issues. Only enable it if you actually need it, !_**

If you want to simulate a specific device (to get access to device specific apps in the Play store, as an example), you can activate this option. It will pull information from the currently used fingerprint (has to be set by the module) and use this to set a few certain props to these values. The props that can be set are (currently):
- ro.product.brand
- ro.product.name
- ro.product.device
- ro.build.version.release
- ro.build.id
- ro.build.version.incremental
- ro.build.version.sdk

By default all props are set when this option is activated, but it is possible to deactivate and activate each prop individually.

Whenever a fingerprint is set by the module, the `ro.build.description` prop will be set automatically independently from if the general device simulation option is enabled or not.


## Improved root hiding - Editing build.prop and default.prop
In some rare cases, apps and services look at the actual files (build.prop and default.prop), rather than the set prop values. With this module feature you can make sure that the actual prop in build.prop and default.prop is changed to match whatever value the prop has been set to by either MagiskHide or the module. If there's a prop value set by the module (see ["Set/reset MagiskHide Sensitive props"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#setreset-magiskhide-sensitive-props) below), that value takes precedence.


## Set/reset MagiskHide Sensitive props
By default, if MagiskHide detects certain sensitive prop values they will be changed to known safe values. These are currently:
- ro.debuggable (set to "0" by MagiskHide - sensitive value is "1")
- ro.secure (set to "1" by MagiskHide - sensitive value is "0")
- ro.build.type (set to "user" by MagiskHide - sensitive value is "userdebug")
- ro.build.tags (set to "release-keys" by MagiskHide - sensitive value is "test-keys" or "dev-keys")
- ro.build.selinux (set to "0" by MagiskHide - sensitive value is "1")

If, for some reason, you need one or more of these to be kept as their original value (one example would be resetting ro.build.type to userdebug since some ROMs need this to work properly), you can reset to the original value with this module. Keep in mind that this might trigger some apps looking for these prop values as a sign of your device being rooted.


## Change/set custom prop values
It's quite easy to change prop values with Magisk. With this module it's even easier. Just enter the prop you want to change and the new value and the module does the rest, nice and systemless. Any changes that you've previously done directly to build.prop, default.prop, etc, you can now do with this module instead. If you have a lot of props that you want to change it'll be a lot easier to use the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) (see below).

When setting a custom prop you can also pick in what boot stage it should be set in. This can also be changed later for each individual custom prop. There are three options:
- Default - The main module option will decide (see [Prop script settings](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#boot-stage) below).
- post-fs-data - The prop will always be set in post-fs-data, regardless of the main module option.
- late_start service - The prop will always be set in late_start service, regardless of the main module option.
- Both post-fs-data late_start service - In some special cases you would want the prop to be set during both boot stages. An example would be if the system reapplies the stock prop value late in the boot process (after post-fs-data).

Note: post-fs-data runs earlier than late_start service.

### My build.prop doesn't change after setting a custom prop
Magisk doesn't alter the build.prop file when changing a custom prop value, it simply loads the new value instead of the one in build.prop. If you want to check if the new value has been loaded you can see this by selecting the prop in the "Add/edit custom props" menu of the `props` script.

You can also use the `getprop` command in a terminal emulator to check the set value. Example:
```
getprop ro.build.fingerprint
```


## Removing prop values
If you would like to delete a certain prop value from your system, that can be done with the [Magisk resetprop tool](https://github.com/topjohnwu/Magisk/blob/master/docs/tools.md#resetprop). With this module you can easily set that up by adding whatever prop you want removed to the "Delete props" list. Be very careful when using this option, since removing the wrong prop may cause isses with your device. See ["Device issues because of the module"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#device-issues-because-of-the-module) below if this happens.

### My build.prop doesn't change after removing a prop value
Magisk doesn't alter the build.prop file when removing a prop value, it simply prevents the prop to load instead of removing it from build.prop. If you want to check if the prop has been removed use the `getprop` command in a terminal emulator to check. Example:
```
getprop ro.build.fingerprint
```
If the prop has been removed, the command should return nothing.


## Prop script settings
There are a couple of persistent options that you can set for the `props` script. These are currently "Boot stage", "Script colours" and "Fingerprints list check". The options are found under "Script settings" when running the `props` script. The settings menu can also be opened by using the -s option (use -h for details).

### Boot stage
It's possible to move the execution of the boot script from the default system.prop file to either post-fs-data or late_start service. If there are any kind of issues during boot or that props don't set properly, try changing the boot stage to either post-fs-data or late_start service instead. Just keep in mind that this might cause other issues like the fingerprint not setting properly (if set during late_start service) or that post-fs-data will be interupted by having too many props causing the script to run too slow.

It is also possible to set individual props, like fingerprint, security patch date and custom props individualy. There'll be an option under the corresponding menu.

Note: post-fs-data runs earlier than system.prop and late_start service runs after, right at the end of the boot process. Having to many props set in post-fs-data may have an adverse effect on the boot process. Using the default system.prop file or late_start service is prefered if possible.

### Script colours
This option will disable or enable colours for the `props` script.

### Fingerprints list check
This option will disable or enable the automatic updating of the fingerprints list when the `props` script starts. If the fingerprints list check is disabled, the list can be manually updated from within the script, under the `Edit device fingerprint` menu, or with the -f option (use -h for details).

### Automatic fingerprint update
Whenever there is an update to the fingerprints list and if you have a fingerprint applied for a device that is on the list, the fingerprint will automatically be updated (if there is an update to that particular fingerprint). This option will not update a fingerprint to one for a different Android version if there are several fingerprints available for the same device.

## Configuration file
You can use a configuration file to set your desired options, rather than running the `props` command. This is particularly useful if you have a large amount of custom props you want to set. Download the [settings file](https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/propsconf_conf) or extract it from the module zip ('propsconf_conf' in the common folder), fill in the desired options (follow the instructions in the file), place it /data or /cache (or /data/cache if you're using an A/B device) and reboot. You can also use the configuration file when first installing the module. Just place the file in the root of your internal storage (or one of the other previously mentioned locations) before flashing the module and the installation script will set everything up.

If you edit the configuration file in Windows, make sure that you use a text editor that can handle [Unix file endings](https://en.m.wikipedia.org/wiki/Newline), such as Notepad++ and similar editors (not regular Windows Notepad).

This can also be done directly at the first install (through Manager or recovery) and even on a brand new clean install of Magisk, before even rebooting your device (also see "Setting up the module on a clean Magisk/ROM flash" below).

**NOTE!** Upon detecting the file, the module installation/boot script will load the configured values into the module and then delete the the configuration file, so keep a copy somewhere if you want to use the same settings later.

### Setting up the module on a clean Magisk/ROM flash
After having made a clean ROM flash, the configuration file can be used to set the module up as you want without even having to boot first. First flash the ROM and Magisk. After that you can place the configuration file (see above) with your desired settings (fingerprint, custom props, etc) in the root of your internal storage (/sdcard), /data or /cache (or /data/cache if you're using an A/B device) and then install the module. This will set the module up just as you want it without having to do anything else. It is also possible to place the configuration file after having installed the module and rebooting (although you can only use /data or /cache as a location for the file, /sdcard will not be mounted in time). This will set everything up during boot, but it is possible that this won't work an all device/ROM combinations. If you experience issues, let the ROM boot once before setting everything up.


## Miscellaneous MagiskHide issues
If you're having issues passing SafetyNet, getting your device certified, or otherwise getting MagiskHide to work, take a look in the [Magisk and MagiskHide Installation and Troubleshooting Guide](https://www.didgeridoohan.com/magisk). Lots of good info there (if I may say so myself)...

But first: have you tried turning it off and on again? Toggling MagiskHide off and on usually works if MagiskHide has stopped working after an update of Magisk or your ROM.


## Issues, support, etc
If you have questions, suggestions or are experiencing some kind of issue, visit the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228) @ XDA.

### Known issues
- EdXposed sometimes causes Magisk's boot process to fail, resulting in the module boot scripts (mainly service.sh) not running as they should. Until this has been fixed with EdXposed, there are a couple of ways to work around this. Use the [Configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) to set everything up during installation, or disable EdXposed before setting the module up and enable it again after the module works as you want it. Just make sure to use the default settings for boot stages.

### Requires Magisk v19+
If the module won't install, with the message that Magisk v19+ is required, but you have Magisk v19+ installed, that means that your Magisk installation is broken. It's likely that you did not update properly (always update directly from the Manager) from a previous Magisk version (or something along those lines) and core parts of Magisk are still from an old install. The solution is to do a reinstallation by using "Direct install" in the Magisk Manager. If you for some reason can't do a direct install you're likely going to have to uninstall Magisk and start over.

### An option is marked as "disabled"
A couple of the options in the `props` script will be automatically disabled in some circumstances. These are:  
- _"Edit device fingerprint"_ will be disabled if another Magisk module that is known to also edit the device fingerprint is installed.
- _"Device simulation"_ will be disabled if there is no device fingerprint set by the module.
- _"Improved hiding"_ will be disable if all relevant prop values already are "safe" (in other words: the option isn't needed), or if a conflicting module that also Magic Mounts build.prop is found.

### I can't pass the ctsProfile check
See ["I still can't pass the ctsProfile check"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-still-cant-pass-the-ctsprofile-check) above.

Also see ["Props don't seem to set properly"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#props-dont-seem-to-set-properly) below.

### I can't pass the basicIntegrity check
This module can usually only really help with the ctsProfile check, by spoofing the device fingerprint. If you can't pass basicIntegrity, there's probably something else going on with your device, but there is a possibility that changing the device fingerprint can make this pass as well. If you can't get things working, see ["Miscellaneous MagiskHide issues"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#miscellaneous-magiskhide-issues) above.

### Props don't seem to set properly
If it seems like props you're trying to set with the module don't get set properly (ctsProfile still doesn't pass, custom props don't work, etc), go into the script options and change the boot stage at which the props are being set, or change the boot stage for that particular prop, to late_start service. See ["Boot stage"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#boot-stage) or ["Custom prop values"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) above. This might happen because the particular prop you're trying to set get assigned it's value late in the boot process and by setting the boot stage for the prop to the last one available (late_start service) you optimise the chances of the module setting the prop after the system.

### My device's Android security patch date changed
For some fingerprints it is necessary to also change the security patch date to match the fingerprint used (the actual patch won't change, just the displayed date). This is automatically done by the module when using a fingerprint from a build after March 16 2018. If you do not want this to happen you can manually add `ro.build.version.security_patch` to the custom props and load back the original date, but keep in mind that this may result in the fingerprint not working and SafetyNet will fail.

### Device issues because of the module
A common reason for issues with booting the device or with system apps force closing, etc, is having enabled [Device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation). This feature is not needed for passing SafetyNet's CTS profile check. Only enable it if you actually need it, and keep in mind that it may cause issues when activated.

In case of issues, if you've set a prop value that doesn't work on your device causing it not to boot, etc, don't worry. There are options. You can follow the advice in the [Magisk troubleshooting guide](https://www.didgeridoohan.com/magisk/Magisk#hn_Module_causing_issues_Magisk_functionality_bootloop_loss_of_root_etc) to remove or disable the module, or you can use the module's built-in options to reset all module settings to the defaults.

Place a file named `reset_mhpc` in /cache (or /data/cache on A/B devices) and reboot.

It is possible to use this in combination with the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) described above to keep device fingerprint or any other settings intact past the reset. Just make sure to remove any custom props that might have been causing issues from the configuration file.

### The Play Store is "uncertified"
If your device's Play Store reports that the device is "uncertified", this is usually fixed by making sure that you pass SafetyNet and then clearing data for the Play Store (and possibly rebooting). More details in the [Magisk troubleshooting guide](https://www.didgeridoohan.com/magisk/MagiskHide#hn_Device_uncertified_in_Play_storeNetflix_and_other_apps_wont_install_or_doesnt_show_up).

## Logs
In case of issues, please provide the logs by running the `props` script and selecting the "Collect logs" option (or running the `props` script with the -l option, use -h for details). All the relevant logs and module files, together with the Magisk log, the stock build.prop file and current prop values will be packaged into a file that'll be stored in the root of the device's internal storage, ready for attaching to a post in the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228), together with a detailed description of your problem.

The logs will also automatically be saved to the root of the device's internal storage if there's an issue with the module scripts.

If there are issues with other apps or your system as a result of using this module, a logcat/recovery log/etc showing the issue will most likely be necessary. Take a look in my [Magisk troubleshooting guide](https://www.didgeridoohan.com/magisk/MagiskHelp) for guidance on that.

### Collecting logs manually
If you can't run the `props` script for some reason, the logs are also stored in /cache (or /data/cache for A/B devices). The Magisk log and any files starting with "propsconf" would be useful for troubleshooting (if you don't, or can't, use the "Collect logs" option mentioned above). Providing the output from terminal might also be useful.


## Donations
If you've had any help from me or this module, any kind of [donation](https://forum.xda-developers.com/donatetome.php?u=4667597) to support the work involved would of course be appreciated. 


## Source
[GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config)


## Credits
@topjohnwu @ XDA Developers, for Magisk  
@Zackptg5, @veez21 and @jenslody @ XDA Developers, for help and inspiration


## Previous releases
Any previous releases can be found on [GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/releases).

Releases up until v2.4.0 are compatible with Magisk v15 to v16.7.  
Releases from v2.4.1 are compatible with Magisk v17+.
Releases from v4.0.0 are compatible with Magisk v19+.


## Changelog
### v4.0.3  
- Tiny bugfix release. A couple of messed up variables restored to their full glory.
- Updated fingerprint for the Xiaomi Redmi Note 5/5 Plus. List at v55.

### v4.0.2  
- Removed prompt to enable device simulation after changing device fingerprint. It has too much of a chance of causing issues and is not necessary for passing the CTS profile check.
- The check for conflicting modules that do similar edits to MagiskHide Props Config now takes into account if the conflicting module is disabled.
- Made sure that custom props can be edited for boot stage or reset, even when not set yet.
- I was gonna add a chemistry joke, but all the good ones Argon.
- Various small fixes and optimisations.
- New fingerprints for LG V20 (several variants) and Lenovo K6 Note, and updated for LG G5 and G6 (several variants), Motorola Moto G5S, Oppo Neo7 (several variants) and Samsung Galaxy S7 Edge. Fingerprints list updated to v53.

### v4.0.1  
- Fixed a bug where the automatic fingerprints update function would always revert to the oldest print available for the set device.
- Added two new devices to the fingerprints list, Oppo Neo 7 and Xiaomi Mi 9. List updated to v52.

### v4.0.0  
- Updated to the new module template. Otherwise the same as v3.5.2, apart from some code cleanup.
- Due to some of the code cleanup and the new template, this release is only compatible with Magisk v19+. Users not updating to Magisk v19+ can use module v3.5.2.
- New (Samsung Galaxy A6 Plus and Tab S3, Xiaomi Mi Note 3) and updated (Essential PH-1, Google Pixel and Pixel XL 1-3 and Pixel C, OnePlus 5T and Xiaomi Mi A2 and Pocophone F1) fingerprints added. List at v51.

### v3.5.2  
- Fixed a bug where automatic update of the applied fingerprint during installation would cause the installation to fail.

### v3.5.1  
- Fix a few bugs causing props not setting properly at boot in some cases when using the system.prop boot stage.
- Moved ro.build.version.security_patch to late_start service by default, so as not to cause issues for devices with Keymaster 4 (possible source of bootloops). Thank you @Nebrassy.
- Added an option to change security patch date boot stage under "Edit device fingerprint" boot stages.
- Added a new fingerprint for the Xiaomi Redmi Note7 and an updated one for Motorola Moto G6 Play. Fingerprints list updated to v50.

### v3.5.0  
- Added ro.build.version.sdk to the device simulation props (see the documentation for details).
- Updated editing the device fingerprint feature so that fingerprints for different Android versions can be added to the fingerprints list and the user can pick the desired one when applying a new fingerprint (see the documentation for details). Several fingerprints have been updated with dual fingerprints.
- Updated and optimised when props are set during boot. Uses Magisk's system.prop function by default, rather than post-fs-data, to avoid putting a strain on the system during boot. At what boot stage props are set can of course be completely configured by the user (see the documentation for details).
- Updated the configuration file to match current settings (see the documentation for details). Update your personal files to match.
- Fixed a bug where the props file wouldn't get the proper permissions when using the configuration file on a clean install.
- Fixed a bug where saving the simulation value for ro.build.version.incremental would give a wrong vaule.
- Fixed an infinite loop bug if making an invalid choice when asked to reboot.
- Optimised and cleaned up some code here and there.
- Updated the fingerprints list. Added Asus Zenfone Max Pro M1 and Huawei Honor 8X to the list, and updated Huawei Honor 9, P20 Pro and Xiaomi Mi 8 and Mi Mix 2S. List updated to v49.

### v3.0.3  
- Small update to the query for activating device simulation or not when picking a new fingerprint.
- Updated the fingerprints list and added Asus Zenfone Max M1 and the Elephone U Pro to the list, and updated the OnePlus 5. List updated to v44.

### v3.0.2  
- Another quickfix, this time fixing editing already set custom props (a victim of slightly too heavy-handed optimisations of variable and settings retrieval in v3.0.0).

### v3.0.1  
- Quickfix for updating the module from v2.7.2 or earlier.

### v3.0.0  
- New function for device simulation. The module sets a number of device specifying props based on the used fingerprint. See the documentation for details.
- New function for Treble GSI users that have a stock vendor partition: The module can use the certified vendor fingerprint found there. See the documentation for details. Thank you to @oF2pks for making me aware of this possibility.
- New function where the currently used fingerprint automatically will be updated if there's a new fingerprint for that device added to the fingerprints list. See the documentation for details.
- New function to set custom props in both post-fs-data and late_start service mode. See the documentation for details.
- Updated the configuration file function so that the file will now be detected during installation or at boot. See the documentation for details.
- Updated the locations for placing the configuration file when importing settings to the module. See the documentation for details.
- Updated the configuration file to be version specific. Make sure you use the latest available configuration file.
- Fixed compatibility with changed boot stages in Magisk v18.1-d73127b1(18006).
- Fixed double download of fingerprints file if using the -f option and cleaned up the runtime options a bit.
- Fixed module reset option.
- Optimised variable and settings retrieval.
- Optimised module boot scripts.
- A whole bunch of minor fixes and cleanups.

### v2.7.2  
- Re-run the post-fs-data script if the Magisk image wasn't mounted yet or if the script has been reset.
- Added fingeprints for Razer Phone 1 & 2 and Xiaomi Mi Pad 4, and updated fingerprints for Xiaomi Mi 8, Mi A2 & Pocophone F1. List v40.
- Mostly harmless.
- Small fixes, as usual.

### v2.7.1  
- Fixed an issue when users create custom prints list and configuration files with Windows file endings.
- Fixed an issue where the currently picked device wouldn't show for the custom prints list.
- Added fingerprints for Sony Xperia Z4 Tablet LTE and Xiaomi Mi A2 & Redmi Y1. Updated fingerprints for Essential PH-1, Google Nexus 5X & 6P, Pixel 1-3 (both regular and XL) & C and Sony Xperia XZ1 Compact. List updated to v39.

### v2.7.0  
- Updated Busybox logic (again). It is now required to install Busybox alongside the module, to ensure proper functionality. I recommend @osm0sis' Busybox, installable as a Magisk module from the Magisk repo.
- Added fingerprints for Google Nexus 7 (2012 & 2013, WiFi & LTE), Nexus 9 (WiFi & LTE) and Pixel C, LG V30, Motorola Moto E5 Plus, OnePlus 6T, Samsung Galaxy J7 Prime and S5, and Xiaomi Mi 8. Updated the fingerprint for Huawei P8 Lite and Xiaomi Mi Mix 2s. List updated to v38.
- Probably some other small fixes as well. Can't remember...

### v2.6.5  
- Fixed some of the "optimisations" I did in the previous release (read: I messed up).

### v2.6.4  
- Fixed the "Delete prop values" function to properly delete persistent props.
- Updated for the new paths introduced in Magisk v17.4-ab5fedda(17316).
- Added and updated fingerprints for Google Nexus 10, Huawei P8 Lite and LG G5 850. List updated to v37.
- Miscellaneous fixes.

### v2.6.3  
- Fixed custom fingerprints list that broke with the fingerprints list optimisation in v2.5.0.
- Added fingerprints for Huawei P9 Plus and HTC U12 Plus. List updated to v34.
- Minor improvements.

### v2.6.2  
- Another quick fix. Keep 'em coming...

### v2.6.1  
- Small fix (revert really) for possible issue with setting prop values (including fingerprint).

### v2.6.0  
- Updated the fingerprints list to load much, much faster.
- Added and updated fingerprints for Huawei Mate 10, Nextbook Ares 8A, OnePlus 3, 3T, 5 and 5T, and ZTE Axon 7. List updated to v33.
- The new and improved SafetyNet fix turns out to be not only for Android Pie. Gone through the entire list and added security patch dates where needed.
- Fixed some seriously botched code in v2.5.0.
- As usual, small bug fixes and improvemnts.
- No Yoshis where harmed during the making of this release.

### v2.5.0  
- Improved/fixed the SafetyNet fix when using Android Pie fingerprints.
- Updated/changed Busybox logic.
- It is sometimes an appropriate response to reality to go insane.
- Added and updated fingerprints for Essential PH-1, Google Pixel and Pixel XL (all three variants) and Nokia 7 Plus. Fingerprints list v31.
- Various bugfixes and improvements.

### v2.4.3  
- Another small update, fixing my bad memory (I wish).

### v2.4.2  
- Small update to the root detection logic. Should fix issues on devices with a broken `id` command.

### v2.4.1  
- Updated to Magisk module template v17000. Compatible with Magisk v17+ only.

### v2.4.0  
- Added a check for if the download of the internal Busybox fails.
- Added an option for picking what boot stage a custom prop should be set in.
- Updated the internal Busybox to @osm0sis' latest 1.29.2 build.
- Don't panick!
- Updated and added a couple of fingerprints.
- Various improvements, etc.

### v2.3.6  
- Added md5 checksum when downloading the internal Busybox.
- Changed the default boot stage from late_start service to post-fs-data.
- Various fixes and improvements, as usual.

### v2.3.5  
- Fixed issue with Busybox version detection.
- Fixed the documentation. Some parts had been accidentally deleted. Oops...
- Improved log collecting.
- Added and updated fingerprints for the Xiaomi Mi Note 2 and Redmi Note 5A Lite, list v23.
- Minor improvements here and there. Hopefully I haven't broken something this time...

### v2.3.4  
- Updated for Busybox v1.29.1. Thank you @osm0sis.
- Bugfixes. Because I'm blind.

### v2.3.3  
- Tiny update for installation logic and documentation.
- Also added and updated a whole bunch of fingerprints (Huawei Honor 6X, Sony Xperia X Dual, X Compact, X Performance Dual, XZ Dual, XZ Premium, XZ Premium Dual, XZ1, XZ2, XZ2 Dual, XZ2 Compact, XZ2 Compact Dual and Xiaomi Mi5/5 Pro), list v22.

### v2.3.2  
- Finally fixed installing with the configuration file on a clean Magisk installation.
- Fixed updating placeholders if boot scripts gets restored at boot.
- Updated the power requirements to 1.21 gigawatts.
- Updated and added new fingerprints (Asus Zenfone 2 Laser, Huawei P9, LG G4, Motorola Moto C Plus and G6 Play, Samsung Galaxy J5 2015, Xiaomi Mi 4C and Mi Mix 2S), list v21.
- Miscellaneous fixes and updates.

### v2.3.1  
- Fixed permissions for the settings boot script when using the reset option.
- Fixed log collecting.
- Added automatic log collecting when there's an issue with the boot scripts.
- Some updates to the documentation, mainly regarding troubleshooting issues.
- Miscellaneous improvements and fixes.

### v2.3.0  
- Added a function for removing props. See the documentation for details.
- Added a function to collect and package the logs and relevant troubleshooting files for easy uploading.
- Updated and clarified the documentation on how to use the configuration file.
- A bunch of improvements and tweaks. Several of which may go horribly wrong.
- Updated and added bunch of new fingerprints (Asus ZenPad S 8.0, Huawei P20 Pro, Samsung Galaxy S8, Sony Xperia XZ1 Dual and XZ1 Compact, Xiaomi Mi 4C and Redmi Note 3 Pro SE), list v19.
- Don't turn your back, don't look away, and *don't blink!* Good luck.

### v2.2.2  
- This is not the changelog you're looking for. You can go about your business. Move along.
- Fixed a bug with setting custom props where the value contains spaces.
- Added a couple of fingerprints (OnePlus 6 and Xiaomi Mi Note 2) and cleaned out a few old ones, list v 18.
- As usual, a whole bunch of script improvements that hopefully won't break anything.

### v2.2.1  
- Added a check for entering empty values for fingerprint and custom props.
- Added a command option to go directly to the settings menu. Run `props` with the -h option for details.

### v2.2.0  
- Added an option to set prop values earlier in the boot process.
- Moved module setup from post-fs-data.sh to post-fs-data.d.
- Fixed installing module on a fresh Magisk install.
- Fixed restoring the boot scripts during post-fs-data boot stage.
- Updated and added some new fingerprints (Google Pixel 2 XL, Huawei Honor 9, Samsung Galaxy J5 and Note 8, Xiaomi Mi A1, Mi Max 2 and Redmi Note 5 Pro), list v17.
- As usual, a bunch of improvements. They'll likely not harm any kittens, but might break the module.

### v2.1.6  
- Added some new fingerprints (Sony Xperia Z, Sony Xperia Z1, Xiaomi Redmi 4 Prime, Xiaomi Redmi Note 5/5 Plus), list v15.
- Very minor improvements that doesn't even deserve their own release, or changelog.

### v2.1.5  
- Show what device the currently set fingerprint is from.
- Fixed,updated and added a bunch of fingerprints, list v12.
- Minor updates and improvements.

### v2.1.4  
- Fixed improved hiding.
- Fixed using the configuration file on a clean install.
- Fixed a fault in the AE-35 Unit.
- Improved logging.
- A bunch of optimisations that will probably break stuff.

### v2.1.3  
- Reverted the function to only editing existing fingerprint props.
- Optimised setting the different props.
- Minor updates and improvements.

### v2.1.2  
- Detects and edits only existing device fingerprint props.
- Slightly optimised the boot scripts.
- New fingerprint (Motorola Moto E4), list v10.
- Minor updates and improvements.

### v2.1.1  
- Fixed transferring custom props between module updates.

### v2.1.0  
- "Improved hiding" will now also mask the device fingerprint in build.prop. Please reapply the option to set.
- Fixed colour code issues if running the script with ADB Shell. Huge shout-out to @veez21 over at XDA Developers.
- Fixed typo in A/B device detection. Thank you to @JayminSuthar over at XDA Developers.
- New fingerprints (Samsung Galaxy S4 and Sony Xperia Z3 Tablet Compact), list v8.
- Minor fixes and improvements.

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
### List v62  
- Asus Zenfone 2 Laser (6.0.1)
- Asus Zenfone 4 Max (7.1.1)
- Asus Zenfone 6 (9.0)
- Asus Zenfone Max M1 (8.0.0)
- Asus Zenfone Max Pro M1 (8.1.0)
- Asus ZenPad S 8.0 (6.0.1)
- BLU R1 HD 2018 (7.0)
- Elephone U Pro (8.0.0)
- Essential PH-1 (9)
- Google Nexus 4 (5.1.1)
- Google Nexus 5 (6.0.1)
- Google Nexus 5X (8.1.0)
- Google Nexus 6 (7.1.1)
- Google Nexus 6P (8.1.0)
- Google Nexus 7 2012 WiFi (5.1.1)
- Google Nexus 7 2012 LTE (5.1.1)
- Google Nexus 7 2013 WiFi (6.0.1)
- Google Nexus 7 2013 LTE (6.0.1)
- Google Nexus 9 WiFi (7.1.1)
- Google Nexus 9 LTE (7.1.1)
- Google Nexus 10 (5.1.1)
- Google Nexus Player (6.0.1)
- Google Pixel (8.1.0 & 9)
- Google Pixel XL (8.1.0 & 9)
- Google Pixel 2 (8.1.0 & 9)
- Google Pixel 2 XL (8.1.0 & 9)
- Google Pixel 3 (9)
- Google Pixel 3 XL (9)
- Google Pixel 3a (9)
- Google Pixel 3a XL (9)
- Google Pixel C (8.1.0)
- HTC 10 (6.0.1)
- HTC U11 (8.0.0)
- HTC U12 Plus (8.0.0)
- Huawei Honor 6X (8.0.0)
- Huawei Honor 8X (8.1.0)
- Huawei Honor 9 (8.0.0 & 9)
- Huawei Mate 10 (8.0.0)
- Huawei Mate 10 Pro (8.0.0)
- Huawei Mate 20 Pro (9)
- Huawei P8 Lite (8.0.0)
- Huawei P9 (7.0)
- Huawei P9 Lite (7.0)
- Huawei P9 Plus (7.0)
- Huawei P20 (9)
- Huawei P20 Lite (8.0.0 & 9)
- Huawei P20 Pro (8.1.0 & 9)
- Lenovo K6 Note (7.0)
- LeEco Le Pro3 (6.0.1)
- LG G2 BS980 (5.0.2)
- LG G4 H812 (6.0)
- LG G5 H850 (8.0.0)
- LG G5 H830 (8.0.0)
- LG G5 RS988 (7.0)
- LG G6 H870 (7.0 & 8.0.0)
- LG G6 H872 (8.0.0)
- LG V20 H918 (8.0.0)
- LG V20 H910 (8.0.0)
- LG V20 LS997 (7.0)
- LG V20 US996 (8.0.0)
- LG V20 VS995 (8.0.0)
- LG V30 H930 (8.0.0)
- Mecool KM8 (8.0.0 & 9)
- Motorola Moto C Plus (7.0)
- Motorola Moto E4 (7.1.1)
- Motorola Moto E4 Plus (7.1.1)
- Motorola Moto E5 Play (8.0.0)
- Motorola Moto E5 Plus (8.0.0)
- Motorola Moto G4 (7.0 & 8.1.0)
- Motorola Moto G5 (7.0)
- Motorola Moto G5 Plus (7.0)
- Motorola Moto G5S (7.1.1 & 8.1.0)
- Motorola Moto G6 (9)
- Motorola Moto G6 Play (8.0.0 & 9)
- Motorola Moto G6 Plus (9)
- Motorola Moto X4 (8.0.0)
- Motorola Moto Z2 Play (8.0.0)
- Nextbook Ares 8A (6.0.1)
- Nokia 7 Plus (9)
- Nvidia Shield K1 (7.0)
- Nvidia Shield Tablet (7.0)
- OnePlus 2 (6.0.1)
- OnePlus X (6.0.1)
- OnePlus 3 (8.0.0 & 9)
- OnePlus 3T (8.0.0 & 9)
- OnePlus 5 (8.1.0 & 9)
- OnePlus 5T (8.1.0 & 9)
- OnePlus 6 (8.1.0 & 9)
- OnePlus 6T (9)
- OnePlus 7 Pro (9)
- OnePlus 7 Pro NR (9)
- OPPO Neo 7 A33w (5.1)
- OPPO Neo 7 A1603 (5.1)
- Razer Phone (8.1.0)
- Razer Phone 2 (8.1.0)
- Samsung Galaxy A5 2015 (6.0.1)
- Samsung Galaxy A5 2017 (8.0.0)
- Samsung Galaxy A6 Plus (9)
- Samsung Galaxy A8 Plus (7.1.1)
- Samsung Galaxy Grand Prime (5.0.2)
- Samsung Galaxy J2 (5.1.1)
- Samsung Galaxy J3 (5.1.1)
- Samsung Galaxy J5 2015 (6.0.1)
- Samsung Galaxy J5 2016 (7.1.1)
- Samsung Galaxy J5 Prime (7.0)
- Samsung Galaxy J7 2017 (8.1.0)
- Samsung Galaxy J7 Prime (6.0.1)
- Samsung Galaxy Note 3 (5.0)
- Samsung Galaxy Note 4 (6.0.1)
- Samsung Galaxy Note 5 (7.0)
- Samsung Galaxy Note 8 (8.0.0)
- Samsung Galaxy Note 10.1 2014 (5.1.1)
- Samsung Galaxy S3 Neo (4.4.4)
- Samsung Galaxy S4 (5.0.1)
- Samsung Galaxy S4 Active (5.0.1)
- Samsung Galaxy S5 (6.0.1)
- Samsung Galaxy S6 (7.0)
- Samsung Galaxy S6 Edge (7.0)
- Samsung Galaxy S7 (8.0.0)
- Samsung Galaxy S7 Edge (8.0.0)
- Samsung Galaxy S8 (8.0.0)
- Samsung Galaxy S8 Plus (8.0.0)
- Samsung Galaxy S9 (8.0.0)
- Samsung Galaxy S9 Plus (8.0.0)
- Samsung Galaxy S10 Plus (9)
- Samsung Galaxy Tab 2 7.0 (4.2.2)
- Samsung Galaxy Tab S3 (LTE SM-T825) (8.0.0)
- Sony Xperia X (8.0.0)
- Sony Xperia X Compact (8.0.0)
- Sony Xperia X Dual (8.0.0)
- Sony Xperia X Performance (8.0.0)
- Sony Xperia X Performance Dual (8.0.0)
- Sony Xperia XA2 Dual (8.0.0)
- Sony Xperia XZ (8.0.0)
- Sony Xperia XZ Dual (8.0.0)
- Sony Xperia XZ Premium (8.0.0)
- Sony Xperia XZ Premium Dual (8.0.0)
- Sony Xperia XZ1 (8.0.0)
- Sony Xperia XZ1 Compact (8.0.0 & 9)
- Sony Xperia XZ1 Dual (8.0.0)
- Sony Xperia XZ2 (8.0.0)
- Sony Xperia XZ2 Compact (8.0.0)
- Sony Xperia XZ2 Compact Dual (8.0.0)
- Sony Xperia XZ2 Dual (8.0.0)
- Sony Xperia Z (5.1.1)
- Sony Xperia Z1 (5.1.1)
- Sony Xperia Z2 (6.0.1)
- Sony Xperia Z3 (6.0.1)
- Sony Xperia Z3 Compact (6.0.1)
- Sony Xperia Z3 Tablet Compact (6.0.1)
- Sony Xperia Z4 Tablet LTE (7.1.1)
- Sony Xperia Z5 (7.1.1)
- Sony Xperia Z5 Compact (7.1.1)
- Sony Xperia Z5 Dual (7.1.1)
- Sony Xperia Z5 Premium (7.1.1)
- Sony Xperia Z5 Premium Dual (7.1.1)
- Vodafone Smart Ultra 6 (5.1.1)
- Xiaomi Mi 3/4 (6.0.1)
- Xiaomi Mi 4C (7.0)
- Xiaomi Mi 5/5 Pro (7.0 & 8.0.0)
- Xiaomi Mi 5S (7.0)
- Xiaomi Mi 5S Plus (6.0.1 & 7.0)
- Xiaomi Mi 6 (8.0.0)
- Xiaomi Mi 8 (8.1.0 & 9)
- Xiaomi Mi 9 (9)
- Xiaomi Mi A1 (8.0.0 & 9)
- Xiaomi Mi A2 (8.1.0 & 9)
- Xiaomi Mi A2 Lite (9)
- Xiaomi Mi Max (6.0.1)
- Xiaomi Mi Max 2 (7.1.1)
- Xiaomi Mi Max 3 (9)
- Xiaomi Mi Mix 2 (8.0.0)
- Xiaomi Mi Mix 2S (8.0.0 & 9)
- Xiaomi Mi Mix 3 (9)
- Xiaomi Mi Note 2 (7.0 & 8.0.0)
- Xiaomi Mi Note 3 (8.1.0)
- Xiaomi Mi Pad 4 (8.1.0)
- Xiaomi Pocophone F1 (9)
- Xiaomi Redmi 3/3 Pro (5.1.1)
- Xiaomi Redmi 3S/X Prime (6.0.1)
- Xiaomi Redmi 4 Prime (6.0.1)
- Xiaomi Redmi 4X (6.0.1)
- Xiaomi Redmi 5A (7.1.2)
- Xiaomi Redmi Go (8.1.0)
- Xiaomi Redmi K20 Pro (9)
- Xiaomi Redmi Note 2 (5.0.2)
- Xiaomi Redmi Note 3 Pro (6.0.1)
- Xiaomi Redmi Note 3 Pro SE (6.0.1)
- Xiaomi Redmi Note 4/4X (7.0)
- Xiaomi Redmi Note 5/5 Plus (7.1.2 & 8.1.0)
- Xiaomi Redmi Note 5 Pro (8.1.0 & 9)
- Xiaomi Redmi Note 5A Lite (7.1.2)
- Xiaomi Redmi Note 6 Pro (8.1.0)
- Xiaomi Redmi Note 7 (9)
- Xiaomi Redmi Y1 (7.1.2)
- ZTE Axon 7 (7.1.1 & 8.0.0)
- ZTE Blade (6.0.1)
- ZTE Nubia Z17 (7.1.1)
- Zuk Z2 Pro (7.0)

## MIT Licence

*Copyright (c) 2018-2019 Didgeridoohan*

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
