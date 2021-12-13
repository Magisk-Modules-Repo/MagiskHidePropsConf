# MagiskHide Props Config
## By Didgeridoohan @ XDA Developers


<a href="https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228"><img src="https://img.shields.io/badge/-XDA-orange.svg"></a> [Support Thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228)

<a href="https://www.paypal.me/didgeridoohan"><img src="https://img.shields.io/badge/-PayPal-blue.svg"></a> If you find the module useful, please don't hesitate to [support the work involved](https://www.paypal.me/didgeridoohan).

## What's this?
This module is a very complicated way of doing something very simple. Complicated for me, that is... The aim is to make it easy for you, the user. The module changes prop values using the [Magisk resetprop tool](https://github.com/topjohnwu/Magisk/blob/master/docs/tools.md#resetprop), something that is very easy to do with a [Magisk boot script](https://github.com/topjohnwu/Magisk/blob/master/docs/details.md#magisk-booting-process) and some simple commands. This is very useful for a lot of things, among others to help pass the SafetyNet CTS Profile check on custom and uncertified ROMs (see [here](https://didgeridoohan.com/magisk/MagiskHide#hn_Matching_official_prop_values_to_pass_SafetyNet) for further details on this). And of course for any normal modification of your device that is done by altering build.prop or similar files.

What this module does is that it adds a terminal based UI for those that don't want (or can't) create a boot script for themselves, making the process of creating such a boot script very simple. With this module I'm also maintaining a list of certified build fingerprints for a number of devices, so that it's easy to pick one you want to use.

Keep reading below to find out more details about the different parts of the module.

Keep in mind that this module cannot help you pass CTS if your device uses hardware backed key attestation to detect an unlocked bootloader. There is currently no known way to circumvent that.


## Documentation index
##### Warning
- [Warning](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#warning-1)
##### Installation and usage
- [Prerequisites](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#prerequisites)
- [Installation](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#installation)
- [Usage](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#usage)
- [Run options](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#run-options)
##### What option should I use?
- [What option should I use?](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#what-option-should-i-use-1)
  - [Not passing SafetyNet](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#not-passing-safetynet)
  - [Simulating other devices](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#simulating-other-devices)
  - [Working with props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#working-with-props)
##### Passing SafetyNet's CTS Profile
- [Spoofing device's fingerprint to pass the ctsProfile check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#spoofing-devices-fingerprint-to-pass-the-ctsprofile-check)
  - [Use vendor fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#use-vendor-fingerprint-for-treble-gsi-roms)
  - [Matching the Android security patch date](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#matching-the-android-security-patch-date)
  - [Can I use any fingerprint?](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#can-i-use-any-fingerprint)
  - [How do I submit a fingerprint?](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#how-do-i-submit-a-fingerprint)
  - [Finding a certified fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#finding-a-certified-fingerprint)
    - [The getprop method](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#the-getprop-method)
    - [The stock ROM/firmware/factory image method](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#the-stock-romfirmwarefactory-image-method)
    - [The Android Dumps method](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-Android-Dumps-method)
    - [The firmware.mobi method](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-firmwaremobi-method)
  - [Custom fingerprints list](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#custom-fingerprints-list)
- [Keeping your device "certified"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#keeping-your-device-certified)
- [Current fingerprints list version](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#current-fingerprints-list-version)
- [Please add support for device X](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#please-add-support-for-device-x)
- [Please update fingerprint X](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#please-update-fingerprint-x)
##### Forcing BASIC attestation for the bootloader check
- [Force BASIC key attestation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#force-basic-key-attestation)
##### Simulating another device
- [Device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation)
##### MagiskHide props
- [Set/reset MagiskHide Sensitive props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#setreset-magiskhide-sensitive-props)
##### SELinux
- [SELinux Permissive](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#selinux-permissive)
##### Custom props
- [Change/set custom prop values](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values)
- [Removing prop values](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#removing-prop-values)
##### Settings, etc
- [Prop script settings](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#prop-script-settings)
  - [Boot stage](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#boot-stage)
  - [Script colours](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#script-colours)
  - [Automatic module update check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#automatic-module-update-check)
  - [Automatic update of fingerprints list](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#automatic-update-of-fingerprints-list)
  - [Automatic fingerprint update](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#automatic-fingerprint-update)
  - [Background boot script](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#background-boot-script)
  - [Export settings](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#export-settings)
- [Configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file)
  - [Setting up the module on a clean Magisk/ROM flash](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#setting-up-the-module-on-a-clean-magiskrom-flash)
##### Issues and logs
- [Miscellaneous MagiskHide issues](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#miscellaneous-magiskhide-issues)
- [Issues, support,etc](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#issues-support-etc)
  - [Known issues](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#known-issues)
  - [I still can't pass the ctsProfile check](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#i-still-cant-pass-the-ctsprofile-check)
  - [Device issues because of the module](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#device-issues-because-of-the-module)
  - [props not found](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#props-not-found)
  - [The boot scripts did not run](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#the-boot-scripts-did-not-run)
  - [An option is marked as "disabled"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#an-option-is-marked-as-disabled)
  - [I can't pass the ctsProfile check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-cant-pass-the-ctsprofile-check)
  - [I can't pass the basicIntegrity check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-cant-pass-the-basicintegrity-check)
  - [Props don't seem to set properly](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#props-dont-seem-to-set-properly)
  - [My build.prop doesn't change after using the module](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#my-buildprop-doesnt-change-after-using-the-module)
  - [My device's Android security patch date changed](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#my-devices-android-security-patch-date-changed)
  - [My device's model has changed](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#my-devices-model-has-changed)
  - [The Play Store is broken](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-play-store-is-broken)
  - [The interface looks weird](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-interface-looks-weird)
  - [Boot takes a lot longer after setting props](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#boot-takes-a-lot-longer-after-setting-props)
  - [The screen goes black momentarily at boot](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-screen-goes-black-momentarily-at-boot)
  - [The Play Store is "uncertified"](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-play-store-is-uncertified)
- [Logs](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#logs)
  - [Collecting logs manually](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#collecting-logs-manually)
##### Miscellaneous
- [Donations](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#donations)
- [Source](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#source)
- [Credits and mentions](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#credits-and-mentions)
- [Changelog](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changelog)
- [Current fingerprints list](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#current-fingerprints-list)
- [Licence](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#mit-licence)


## Warning
Let's start off with a warning.

This module changes your devices prop values. Fingerprint, model and whatever prop you want (depending on what options you use). This may have consequences (everything in life does, live with it). Your device might be perceived as a different device (which can create issues with the Play Store, YouTube video resolution, OTA updates, etc) and cause system instabilities and even bootloops.

Read through the documentation to find more details and how to fix your device if things go south.


## Prerequisites
- Magisk v20+.


## Installation
Install through the Magisk Manager Downloads section. Or, download the zip from the Manager or the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228), and install through the Magisk Manager -> Modules, or from a custom recovery.

The current release is always attached to the OP of the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228). Any previous releases can be found on [GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/releases).


## Usage
After installing the module and rebooting, run the command `props` in terminal (you can find a terminal emulator on [F-Droid](https://f-droid.org/) or in the [Play Store](https://play.google.com/store/apps)), and follow the instructions to set your desired options. If you use Termux, you'll have to call su before running the command.

You can also run the command with options. See below or use -h for details.

If you want further details as to what this module does and can do, keep reading. To get an overview of what is available, take a look at the index above. If experiencing issues, take a look at the part about [Issues, support,etc](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#issues-support-etc), and don't forget to provide [logs](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#logs) when asking for help.

### Run options
```
Usage: props NAME VALUE
   or: props [options]...

Entering a property NAME and VALUE will save
this information to the module settings as custom
prop values.

Options:
  -d    *Update to fingerprints test list during start.
  -f    *Update fingerprints list during start.
  -l    *Save module logs and info.
  -h    *Show this message.
  -nc   Run without colours.
  -nw   Run without connecting to the web during start.
  -r    *Reset all options/settings.
  -s    *Open script settings menu.
  -t    Activate test mode.
  -u    *Perform a module update check during start.
```
Options marked with an asterisk (\*) cannot be combined with each other.

The settings option (-s) can be used even if the module boot scripts did not run.


## What option should I use?
### Not passing SafetyNet
If you can't pass the CTS profile check of the SafetyNet check there are a few things that you might have to do.

If you are using a custom ROM (or have a stock ROM on a device that isn't certified by Google) you most likely need to change the device fingerprint to one that has been Google certified. Use the "[Edit device fingerprint"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#spoofing-devices-fingerprint-to-pass-the-ctsprofile-check) feature.

If you have a stock device, or a custom ROM and using a certified fingerprint, but still can't pass CTS you most likely need to [force BASIC key attestation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#force-basic-key-attestation).

### Simulating other devices
Simple: use the ["Device simulation"](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation) feature.

### Working with props
If you need to change props edited by MagiskHide, use the ["MagiskHide props"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#setreset-magiskhide-sensitive-props) feature.

For adding custom props or removing props from your device, there are the ["Custom props"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) and ["Delete props"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#removing-prop-values) features.

## Spoofing device's fingerprint to pass the ctsProfile check
If your device can't pass SafetyNet fully, the CTS profile check fails while basic integrity passes, that means MagiskHide is working on your device but Google doesn't recognise your device as being certified (if basic integrity fails there is generally nothing this module can do, please check [I can't pass the basicIntegrity check](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-cant-pass-the-basicintegrity-check)).

This might be because your device simply hasn't been certified or that the ROM you are using on your device isn't recognised by Google (because it's a custom ROM). Stock ROMs usually do not need this feature.

To fix this, you can use a known working device fingerprint (`ro.build.fingerprint`), one that has been certified by Google, usually from a stock ROM/firmware/factory image, and replace your device's current fingerprint with this. You can also use a fingerprint from another device, but this will change how your device is perceived.

**NOTE:** If you're using a fingerprint for an Android build after March 16th 2018 you might have to change the security patch date to one that matches the fingerprint used. You can use the [Custom prop](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) function of this module to change `ro.build.version.security_patch` to the desired date. If you don't know the security patch date you can try finding it with trial and error (although it's a much better option to find the actual date from the ROM/firmware/factory image in question). The dates are always either the 1st or the 5th of the month, so try different months one after the other until the CTS profile passes.

There are a bunch of tested certified fingerprints available in the module, just in case you can't get a hold of one for your device. For some devices there are several fingerprints available, for different Android versions. When picking a fingerprint you will also have to pick which version you need.

After having applied a device fingerprint from the module, whenever that particular print is updated in the included prints list, the chosen fingerprint will be automatically updated when the fingerprints list is. Just reboot to apply the new fingerprint. If there are several fingerprints available for the same device, this option only applies for fingerprints of the same Android version. In that case, if you want to update to a newer version you will have to update the fingerprint manually.

If you are using a Treble GSI ROM you can enable the [Use vendor fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#use-vendor-fingerprint-for-treble-gsi-roms) option (for more details, see below) in the `Edit device fingerprint` menu.


### Use vendor fingerprint (for Treble GSI ROMs)
When using a Treble GSI ROM with a stock vendor partition, it is sometimes possible to use the vendor fingerprint to make the device pass the CTS profile check. Enabling this option will make the module scripts pull the vendor fingerprint on each boot and use this to spoof the device fingerprint. This in turn means you will only have to enable this option once and even if you update your vendor partition the fingerprint used will always be the latest one.

### Matching the Android security patch date
For some devices, if the fingerprint is for an Android build after March 16th 2018, it is necessary to use a security patch date that matches the fingerprint used. For the module provided fingerprints this is done automatically, but if you enter a fingerprint manually you will have to update the security patch date yourself (if they don't already match). If you're setting a fingeprint without using the internal fingerprints list, use the [Custom props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) function of this module to change `ro.build.version.security_patch` to the desired date.


### Can I use any fingerprint?
It's usually possible to use any certfied fingerprint to pass CTS on your device. It doesn't have to match either device or Android version. If you don't use a fingerprint for your device, the device might be percieved as the device that the fingerprint belongs to, in certain situations (Play Store, etc). The Android version generally doesn't matter much, and if you're using a ROM with an Android version much newer than what is officially available for your device, you are going to have to use an older fingerprint if you want to use the one for your device. But, like already stated, that doesn't really matter (most of the time, there might of course be exceptions).

There are some situations where it might matter what fingerprint you use and Google Play is a prime example. When changing the device fingerprint for your device it is very possible that apps will be filtered in the Play store for that particular device and Android version. If you suddenly find yourself not being able to find certain apps or the latest updates of apps (like YouTube), it might be because you have changed the device fingerprint.


### How do I submit a fingerprint?
If you have a device fingerprint that you want to submit to the module, just post it in the [Support Thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228) together with device details and the [matching security patch date](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#matching-the-android-security-patch-date).
To make sure that the [device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation) feature works properly with the print you submit, please also include the values for `ro.product.manufacturer` and `ro.product.model` (use the getprop command or the [Android Dumps](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-Android-Dumps-method) or [firmware.mobi](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#the-firmwaremobi-method) methods outlined below).
Also see [Finding a certified fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#finding-a-certified-fingerprint) below.


### Finding a certified fingerprint
If you need a certain fingerprint from a device, here are a few tips on how to find it. Also remember that you might need to get the security patch date that corresponds to the fingerprint you find (see [Matching the Android security patch date](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#matching-the-android-security-patch-date) above).

Make sure that you get the actual device fingerprint, since there might be props that look similar to what you need. Here's an example, taken from a Google Nexus 6 (device name Shamu):
```
google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
```


#### The getprop method
You can get a certified fingerprint for your device by running the getprop command below on a stock ROM/firmware/factory image that fully passes SafetyNet.
```
getprop ro.build.fingerprint
```
If you're already on a custom ROM that can't pass the CTS profile check, this might not be an option... Head over to your device's forum and ask for help. If someone can run the getprop command on their device for you, you're good to go. Or, you can try the other method described below.

*Note that this is sometimes the only surefire way of getting the proper fingerprint.*


#### The stock ROM/firmware/factory image method
Another way to find a certified fingerprint is to download a stock ROM/firmware/factory image for your device and extract the fingerprint from there.

XDA member @ipdev has spent quite some time creating an automated script for extracting the necessary information from a downloaded stock ROM/firmware/factory image, and it can even create a fingerprints list for you. You can find it together with instructions on how to use it here: https://github.com/ipdev99/mHideGP

*Note that the following is possibly not the best way of finding the fingerprint.*
The main problem is that it might be hard to find the actual, certified fingerprint since there might also be other similar props that aren't certified.

You can find the file to download in your device's forum on XDA Developers (either as a firmware file, a proper stock ROM, or in the development section as a debloated stock ROM), from the manufacturer's website, or elsewhere on the great interweb (just remember to be careful when downloading unknown files, it's dangerous to go alone!).

Once you have the file downloaded, there are several different ways that the fingerprint can be found. In all cases you'll have to access the file somehow, and in most cases it's just a matter of unpackaging it. After that it depends on how the package is constructed.

- Sometimes there'll be a build.prop file directly in the zip/package. You might find the fingerprint in there.
- For some devices you'll have to unpack the system.img to get to the build.prop or default.prop file, where you might find the info you want.This can sometimes be done with a simple archive app/program, but sometimes more advanced utilities are needed. On Windows, you can use something like [this tool](https://forum.xda-developers.com/showpost.php?p=57742855&postcount=42). You'll also find more info in the [main thread for that post](https://forum.xda-developers.com/android/software-hacking/how-to-conver-lollipop-dat-files-to-t2978952).
- Other times you'll find the fingerprint in META-INF\com\google\android\updater-script. Look for "Target:" and you'll likely find the fingerprint there.
- Etc... Experiment, the fingerprint will be in there somewhere.


#### The Android Dumps method
Android Dumps is a great resource for finding props for different devices. [Check it here](https://dumps.tadiphone.dev/dumps).


#### The firmware.mobi method
Sometimes you can also find up to date and certified fingerprints at [firmware.mobi](https://desktop.firmware.mobi/).


### Custom fingerprints list
You can add your own fingerprint to the list by placing a file, named `printslist` (no file extension), in the root of your internal storage with the fingerprints. It needs to be formated as follows: `device name=fingerprint`. The fingerprints added to this list will be found under the `Custom` category in the fingerprints menu. If you create the printslist file in Windows, make sure that you use a text editor that can handle [Unix file endings](https://en.m.wikipedia.org/wiki/Newline), such as Notepad++ and similar editors (not regular Notepad).
Here's an example:
```
Google Nexus 6 (7.1.1):Motorola:Nexus 6=google/shamu/shamu:7.1.1/N8I11B/4171878:user/release-keys
```
**NOTE 1:** If you're using a fingerprint for an Android build after March 16th 2018 you might have to change the security patch date to one that matches the fingerprint used. This can be done directly in the fingerprints list, by adding two underscores directly followed by the date at the end of the fingerprint (`__2018-09-05`). You can also use the [Custom props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) function of this module to change `ro.build.version.security_patch` to the desired date. If you don't know the security patch date you can try finding it with trial and error (quite tedious). The dates are usually always either the 1st or the 5th of the month, so try different months one after the other until the CTS profile passes.  
**NOTE 2:** If you want the [device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation) feature of the module to work properly with the prints from the custom list you will also have to include the manufacturer and model in the list. This is done by adding the values for these two props right before the equal sign (=) that separates the device name from the fingerprint. Separate the device name and android versions and the two values with colons (:). See the example above.


## Keeping your device "certified"
If you're using a custom ROM, the chances of it being [perceived as uncertified by Google](https://www.xda-developers.com/google-blocks-gapps-uncertified-devices-custom-rom-whitelist/) are pretty high. If your ROM has a build date after March 16 2018, this might mean that you can't even log into your Google account or use Gapps without [whitelisting your device with Google](https://www.google.com/android/uncertified/) first.

Magisk, and this module, can help with that.

Before setting up your device, install Magisk, this module and use the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) described below to pass the ctsProfile check. This should make your device be perceived as certified by Google and you can log into your Google account and use your device without having to whitelist it. Check [here](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/common/prints.sh) for usable fingerprints (only use the part to the right of the equal sign).

If you're having issues getting your device certified, take a look in the Magisk troubleshooting guide linked below.

In case you can't get the Play Store to report your device as "certified", see ["Issues"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#issues-support-etc) below.


## Current fingerprints list version
The fingerprints list will update without the need to update the entire module. Keep an eye on the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228) for info.

Just run the `props` command and the list will be updated automatically. Use the -nw option to run the script without updating the list or disable it completely in the script settings (see ["Prop script settings"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#prop-script-settings) below). If you've disabled the this setting you can update the list manually in the `Edit device fingerprint` menu or by running the `props` command with the -f run option.

If you already have a device fingerprint set by the module, and it has been updated in the current fingerprints list, it will be automatically updated when the prints list gets an update. Just reboot to apply. This function can be turned of in the script settings (see ["Prop script settings"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#prop-script-settings) below)

**_Current fingerprints list version - v137_**


## Please add support for device X
Adding device fingerprints to the list relies heavily on the users. You guys. I've looked up a fingerprint from time to time, but it is a bit time consuming and I don't have that time...

If you want a specific device fingerprint to be added to the module, see [Finding a certified fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#finding-a-certified-fingerprint) above. If you can find a fingerprint for the device you have in mind, [submit](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#how-do-i-submit-a-fingerprint) it for inclusion in the list of certified fingerprints.


## Please update fingerprint X
Fingerprints included in the module are updated once in a while. Mainly if a user (that's you) provides the updated fingerprint, but sometimes I do look up new fingerprints (that is purely based on how much time I have on my hands and how bored I am though, and I have very little time and a very interesting life). Take a look at [Finding a certified fingerprint](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#finding-a-certified-fingerprint) to get some hints as to how you can find a print to [submit](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#how-do-i-submit-a-fingerprint).

If you have an updated fingerprint available (and you've [posted it](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#how-do-i-submit-a-fingerprint) for me to update the list), but I haven't yet updated the fingerprints list (which might be a while depending on how much IRL stuff I have to do), it is still perfectly possible for you to use the updated fingerprint.

You can enter the fingerprint manually in the `Edit device fingerprint` menu in the module, you can use the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#configuration-file), or you can make a [custom fingerprints list](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#custom-fingerprints-list).


## Force BASIC key attestation
Google now enforces the use of hardware backed key attestation on devices that has the necessary hardware (all devices that shipped with Android 8+ and even some older devices).This can be circumvented by tricking the device into not using the hardware attestation, and it might also be needed to change the prop models (`ro.product.model`) to something other than your devices actual model. This feature can help with that.

@kdrag0n over on XDA Developers have a Magsk module that will trick keystore into thinking that the hardware isn't available and this will then force basic attestation. You can find that module together with details on how it works here:
https://forum.xda-developers.com/t/magisk-module-universal-safetynet-fix-1-1-0.4217823/

The Universal SafetyNet fix not only trickes the keystore into using basic attestation, from v2.1.0 it also changes prop values that might be necessary to trick Google Play Services into letting you pass the CTS profile check, so if you're using that module you most likely will not need to use the Force BASIC key attestation feature of this module.

If you aren't successful in passing CTS by changing the model, you could try using the Xposed (although it is recommended to use LSPosed if you want to have the best chance of passing SafetyNet) module XprivacyLua and restrict Google Play Services. Instructions on how to install LSPosed and XprivacyLua and how to use that module can be found with a simple web search, I won't cover that here.

This feature of the module has nothing to do with the device fingerprint, but uses the included fingerprints list to find the necessary value to use for the `ro.product.model` prop (and related props).

As long as Google doesn't roll out hardware based key attestation universally, it seems like we can fool SafetyNet into using the basic attestation by changing the `ro.product.model` prop (to pass the CTS profile check even with an unlocked bootloader). The module scripts will also alter related partition specific props (odm, product, system, vendor and system_ext) to match, if they are available. Thank you to @Displax over at XDA for finding this: https://forum.xda-developers.com/showpost.php?p=83028387&postcount=40658

The prefered method is to pick a device manually from the list of devices (based on the module fingerprints list) or set your own custom value. Do NOT pick your own device, instead try a device that is as close to your actual device as possible. The closer it is to your actual device the less is the likelyhood that things will stop working as a result of the model prop change.

It is also possible to use a custom value, if that's what you prefer.

If a device isn't picked from the list or a custom value entered, this feature will by default use an old devices model prop value, based on your device or currently set fingerprint, to make sure that it is recognised as a device without the necessary hardware (picked from the available devices in the module fingerprints list). Using an actual model value from an old device may also help with keeping OEM specific features working (like the Samsung Galaxy Store). If device/OEM specific features still doesn't work after activating this option, or your device is otherwise behaving strangely, try picking a device manually from the included list (see below). If no model prop value from an old enough device is available, the value from `ro.product.device` will be used instead.

Note that using the [Device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation) feature to simulate `ro.product.model` (and related props) will be disabled when this feature is enabled (all other simiulation props will still work though). It is also worth noting that using the [Device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation) feature to change ro.product.model will also force a basic key attestation.


## Device simulation
**_NOTE! This feature is not generally needed to pass SafetyNet's CTS profile test and may even cause issues. Only enable it if you actually need it!_**

If you want to simulate a specific device (to get access to device specific apps in the Play store, as an example), you can activate this option. It will pull information from the currently used fingerprint (has to be set by the module) and use this to set a few certain props to these values. The props that can be set are (currently):
- ro.product.brand
- ro.product.name
- ro.product.device
- ro.build.version.release
- ro.build.id
- ro.build.version.incremental
- ro.build.display.id
- ro.build.version.sdk
- ro.product.manufacturer
- ro.product.model (disabled if [Force BASIC key attestation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#force-basic-key-attestation) is enabled)

By default all props are disabled when this option is activated, but it is possible to activate or deactivate each prop individually or all of them at once. It is also possible to activate several props simultaneously by choosing the corresponding numbers in the menu list and entering them separated by a comma.
Example: If I would like to activate ro.product.name, ro.product.device and ro.product.manufacturer I would enter __"2,3,9"__.

There are also several partition specific variations of some of the used props (system, vendor, product, odm). If these are available they will also be set to the simulation prop value. This can be disabled in the option settings.

Whenever a fingerprint is set by the module, the `ro.build.description` prop will be set automatically independently from if the general device simulation option is enabled or not. It can of course also be disabled.


## Set/reset MagiskHide Sensitive props
Up to and including Magisk v23 MagiskHide changes some sensitive props to "safe" values that won't trigger apps that might be looking for them as a sign of your device being tampered with (root).

This feature is enabled by default and will automatically change any triggering values it finds to "safe" values.

The props in question are:
__General__
- ro.debuggable
- ro.secure
- ro.build.type

__Rootbeer, Microsoft, etc__
- ro.build.tags

__SafetyNet, unlocked bootloader, etc__
- ro.boot.vbmeta.device_state
- ro.boot.verifiedbootstate
- ro.boot.flash.locked
- ro.boot.veritymode
- vendor.boot.vbmeta.device_state

__Samsung__
- ro.boot.warranty_bit
- ro.warranty_bit
- ro.vendor.boot.warranty_bit
- ro.vendor.warranty_bit

There are a few props that will only change if a triggering value is detected, and these are (by default these will be set in the late_start service boot stage but can be set during post-fs-data if this is changed in the settings):
__Recovery mode__
- ro.bootmode
- ro.boot.mode
- vendor.boot.mode

__MIUI cross-region flash__
- ro.boot.hwc
- ro.boot.hwcountry

And lastly there are props that will only change after boot is completed. These are:
__SafetyNet, unlocked bootloader, etc__
- vendor.boot.verifiedbootstate

ro.build.selinux used to be changed by MagiskHide, but since some root detectors has a broken implementation of detecting this prop it is simply removed instead of changed (MagiskHide did this since Magisk build 20412).

If, for some reason, you need one or more of these to be kept as their original value (one example would be resetting ro.build.type to userdebug since some ROMs need this to work properly), you can reset to the original value by simply disabling this prop in the module. Keep in mind that this might trigger some apps looking for these prop values as a sign of your device being rooted. If you want to further customise the prop in question you can use the ["Add/edit custom props"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) feature.

It is possible to change or reset each prop individually or all of them at once. It is also possible to change several props simultaneously by choosing the corresponding numbers in the menu list and entering them separated by a comma. This will change any props set to a sensitive value to a safe value and vice versa.
Example: If I would like to change ro.debuggable, ro.secure and ro.build.tags I would enter __"1,2,4"__.

## SELinux Permissive
If MagiskHide detected that SELinux was in a permissive state it would change permissions for a couple of SELinux related files on the device, to prevent detection of this state. This has been implemented in the late_start service script.

## Change/set custom prop values
It's quite easy to change prop values with Magisk. With this module it's even easier. Just enter the prop you want to change and the new value and the module does the rest, nice and systemless. Any changes that you've previously done directly to build.prop, default.prop, etc, you can now do with this module instead. If you have a lot of props that you want to change it'll be a lot easier to use the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) (see below).

A custom prop can also be set by running the `props` command with the prop name and value directly in the command prompt (no need for using the ui). See [Run options](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#run-options).

When setting a custom prop you can also pick in what boot stage it should be set in. This can also be changed later for each individual custom prop. There are four options:
- Default - The main module option will decide (see [Prop script settings](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#boot-stage) below).
- post-fs-data - The prop will always be set in post-fs-data, regardless of the main module option.
- late_start service - The prop will always be set in late_start service, regardless of the main module option.
- Both post-fs-data late_start service - In some special cases you would want the prop to be set during both boot stages. An example would be if the system reapplies the stock prop value late in the boot process (after post-fs-data).
**Note: post-fs-data runs earlier than late_start service.**

It is also possible to set a delay for when the prop is supposed to be set. This is useful if a prop value is originally set late during boot, or even a while after the device has finished booting. Pick this option while setting a new prop or editing one that has already been set and enter the amount of seconds you want the delay to be. By default the script will wait for "Boot completed" to be broadcast before starting to count the delay. This option can be disabled on a per prop level if necessary.
**Note 1: A prop with a delay will automatically be set during the late_start service boot stage.  
Note 2: The delay will usually be sligtly longer than the entered value (mostly counted in tenths of a second), due to small delays in execution of the scripts.**

## Removing prop values
If you would like to delete a certain prop value from your system, that can be done with the [Magisk resetprop tool](https://github.com/topjohnwu/Magisk/blob/master/docs/tools.md#resetprop). With this module you can easily set that up by adding whatever prop you want removed to the "Delete props" list. Be very careful when using this option, since removing the wrong prop may cause isses with your device. See ["Device issues because of the module"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#device-issues-because-of-the-module) below if this happens.


## Prop script settings
There are a couple of persistent options that you can set for the `props` script. These are currently "Boot stage", "Script colours" and "Fingerprints list check". The options are found under "Script settings" when running the `props` script. The settings menu can also be opened by using the -s run option (use -h for details).


### Boot stage
It's possible to move the execution of the boot script from the default system.prop file to either post-fs-data or late_start service. If there are any kind of issues during boot or that props don't set properly, try changing the boot stage to either post-fs-data or late_start service instead. Just keep in mind that this might cause other issues like the fingerprint not setting properly (if set during late_start service) or that post-fs-data will be interupted by having too many props causing the script to run too slow.

It is also possible to set individual props, like fingerprint, security patch date and custom props individualy. There'll be an option under the corresponding menu

If boot stage is set to late_start service, general execution or for specific prop types, it is also possible to enable a soft reboot after these props are changed. This can sometimes be needed for a prop to properly be set to memory at such a late stage in the boot process, so if a prop doesn't appear to be set properly during the late_start service boot stage, try enabling this option. This feature is disabled by default since it has the possibility to cause issues on some devices.

Note: post-fs-data runs earlier than system.prop and late_start service runs after, right at the end of the boot process. Having to many props set in post-fs-data may have an adverse effect on the boot process and may result in props not being set properly. Using the default system.prop file or late_start service is prefered if possible.


### Script colours
This option will disable or enable colours for the `props` script.


### Automatic module update check
This option will disable or enable the automatic check for a module update when the `props` script starts. If the update check is disabled, it can still be performed manually from within the script, in the main menu, or with the -u run option (use -h for details).


### Automatic update of fingerprints list
This option will disable or enable the automatic updating of the fingerprints list when the `props` script starts. If the fingerprints list check is disabled, the list can be manually updated from within the script, under the `Edit device fingerprint` menu, or with the -f run option (use -h for details).


### Automatic fingerprint update
Whenever there is an update to the fingerprints list and if you have a fingerprint applied for a device that is on the list, the fingerprint will automatically be updated (if there is an update to that particular fingerprint). This option will not update a fingerprint to one for a different Android version if there are several fingerprints available for the same device.


### Backround boot script
By default, parts of the module post-fs-data boot script is executed in the background, but the parts that don't might still cause issues on some devices. If there are issues with the boot scripts not running during boot, try enabling this option to execute the script entirely in the background. Keep in mind that this might cause other issues, so only enable if necessary.


### Export settings
If you have a lot of different props set it can be handy to have a [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) (see below) tucked away for future installs of the module. With this feature you can export the current module settings to a [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) for future use. The file will be saved on your internal storage, in the /mhpc directory.


## Configuration file
You can use a configuration file to set your desired options, rather than running the `props` command. This is particularly useful if you have a large amount of custom props you want to set. Download the [settings file](https://raw.githubusercontent.com/Magisk-Modules-Repo/MagiskHide-Props-Config/master/common/propsconf_conf), extract it from the module zip (in the /common folder) or copy it from the module directory under /data/adb (in the /common folder), fill in the desired options (follow the instructions in the file), place it in the root of your internal storage (/sdcard), in /data or in /cache (or /data/cache if you're using an A/B device) and reboot. You can also use the configuration file when first installing the module. Just place the file in the root of your internal storage (or one of the other previously mentioned locations) before flashing the module and the installation script will set everything up.

**NOTE!** If a configuration file is used during boot there will be a reboot during the late_start service boot stage, to load the newly set up values. This can cause issues for devices that have to boot through recovery for Magisk to be active (A-only SAR devices), so a manual reboot after the automatic one will be necessary (or just use the configuration file at install instead).

If you edit the configuration file in Windows, make sure that you use a text editor that can handle [Unix file endings](https://en.m.wikipedia.org/wiki/Newline), such as Notepad++ and similar editors (not regular Windows Notepad).

Using the configuration file can also be done directly at the first install (through Manager or recovery) and even on a brand new clean install of Magisk, before even rebooting your device (also see "Setting up the module on a clean Magisk/ROM flash" below). Just place the file in one of the above mentioned locations prior to installing the module.

**NOTE!** Upon detecting the file, the module installation/boot script will load the configured values into the module and then delete the the configuration file, so keep a copy somewhere if you want to use the same settings later.


### Setting up the module on a clean Magisk/ROM flash
After having made a clean ROM flash, the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) can be used to set the module up as you want without even having to boot first. First flash the ROM and Magisk. After that you can place the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) (see above) with your desired settings (fingerprint, custom props, etc) in the root of your internal storage (/sdcard), in /data or in /cache (or /data/cache if you're using an A/B device) and then install the module. This will set the module up just as you want it without having to do anything else. It is also possible to place the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) after having installed the module and rebooting. This will set everything up during boot, but it is possible that this won't work an all device/ROM combinations. If you experience issues, let the ROM boot once before setting everything up.


## Miscellaneous MagiskHide issues
If you're having issues passing SafetyNet, getting your device certified, or otherwise getting MagiskHide to work, take a look in the [Magisk and MagiskHide Installation and Troubleshooting Guide](https://www.didgeridoohan.com/magisk). Lots of good info there (if I may say so myself)...

But first: have you tried turning it off and on again? Toggling MagiskHide off and on usually works if MagiskHide has stopped working after an update of Magisk or your ROM.


## Issues, support, etc
If you have questions, suggestions or are experiencing some kind of issue, visit the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228) @ XDA.


### Known issues
For the moment, nothing special (I think). If you've got issues, take a look at the most common problems listed below.


### I still can't pass the ctsProfile check
If you've picked a certified fingerprint from the provided list, or you're using a fingerprint that you know is certified, or you've forced basic key attestation but still can't pass the ctsProfile check, try one or more of the following:
- Make sure that [MagiskHide is enabled and working](https://www.didgeridoohan.com/magisk/MagiskHide#hn_Test_MagiskHide).
- Take a look under [What option should I use](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#what-option-should-i-use-1), to make sure that you are using the proper settings for your situation.
- If your device uses hardware backed key attestation (any device that shipped with Android 8+, and some older devices too), you will have to [force BASIC key attestation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#force-basic-key-attestation).
- Do you pass basicIntegrity? If you don't, there's something else going on that this module can't help you with. Take a look under ["Miscellaneous MagiskHide issues"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#miscellaneous-magiskhide-issues) below.
- Go to the "Edit fingerprints menu", select "Boot stages", and start by changing the security patch date boot stage to either default or post-fs-data. If that doesn't work, also try changing the fingerprint boot stage to post-fs-data. The default boot stage can also be changed if you go into the script options and change the boot stage to post-fs-data. See ["Boot stage"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#boot-stage) below.
- Try a different fingerprint (pick one from the provided list). You might want to reset the "Boot stage" settings to the default values first though.
- If you're not using one of the fingerprints provided in the module, make sure you have a matching security patch date set in [Custom props](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values). See ["Matching the Android security patch date"](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf#matching-the-android-security-patch-date) above.
- Some ROMs will just not be able to pass the ctsProfile check, if they contain signs of a rooted/modified device that Magisk can't hide, or that they are built in a way that makes it impossible to pass SafetyNet. Check in your ROM thread or with the creator/developer.
- You might have remnants of previous modifications that trigger SafetyNet on your device. A clean install of your system may be required.
- If you can't get things working, and want help, make sure to provide logs and details. See ["Logs"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#logs).


### Device issues because of the module
A common reason for issues with booting the device or with system apps force closing, etc, is having enabled [Device simulation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#device-simulation). This feature is not needed for passing SafetyNet's CTS profile check. Only enable it if you actually need it, and keep in mind that it may cause issues when activated.

In case of issues, if you've set a prop value that doesn't work on your device causing it not to boot, etc, don't worry. There are options. You can follow the advice in the [Magisk troubleshooting guide](https://www.didgeridoohan.com/magisk/Magisk#hn_Module_causing_issues_Magisk_functionality_bootloop_loss_of_root_etc) to remove or disable the module, or you can use the module's built-in options to reset all module settings to the defaults or to disable the module without resetting.

Create a file (named `reset_mhpc` or `disable_mhpc` depending on your needs, keep reading for details) in the root of your internal storage (/sdcard), in /data or in /cache (or /data/cache if you're using an A/B device) and reboot. If you want to reset the module, name the file `reset_mhpc`, or if you want to disable the module name it `disable_mhpc`. If you disable the module it can later be enabled again from the Magisk Manager.

If your device does not have access to /sdcard, /data or /cache through recovery (or there's no custom recovery available), you can disable all modules by booting to Safe Mode (see the [Magisk troubleshooting guide](https://www.didgeridoohan.com/magisk/Magisk#hn_Safe_Mode) for details), or disable Magisk by flashing a stock boot/recovery image. If you use Safe Mode, boot back into regular Android again and all modules will be disabled. Now you can place the reset or disable file in the root of your internal storage (/sdcard), and lastly either reenable the module from the Magisk app or reinstall Magisk by flashing a patched boot/recovery image again. At the next boot the module will be reset/disabled and you should be up and running again.

The reset file can be used in combination with the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) described above to keep device fingerprint or any other settings intact past the reset. Just make sure to remove any custom props that might have been causing issues from the configuration file.


### props not found
There are two common reasons why you would get an error saying "not found" when running the `props` command in a terminal emulator.

You need to first run `su`. This is especially true if you use Termux, but can also happen on some devices.
If you still get "props not found" after running `su` it is likely that you have somehow disabled the module. Check in the Magisk Manager and make sure that the module is enabled.
If neither of these options apply, check below on how to provide [logs](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#logs) for troubleshooting.


### The boot scripts did not run
Sometimes there are issues with the boot scripts and as a result the `props` command won't work. A common cause for this is having EdXposed installed (see above). Always try rebooting to see if things start working, but if they don't, make sure to share the logs (that have been saved automatically to your internal storage) in the module [support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228).

This issue can in rare cases be caused by the module post-fs-data boot script taking too long to execute. This can be worked around by enabling the [script setting](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#prop-script-settings) to execute the script entirely in the background. This has the potential of causing other issues though, so only enable it if you need it.

If the issue is caused by having changed any of the script settings (for boot stages, etc), you can still enter the settings menu by using the -s [run option](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#run-options).

It might still be possible to use the module, even though you can't run the `props` command. Use the [configuration file](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#configuration-file) to set your desired options and make sure that all the boot options (CONFPRINTBOOT, CONFPATCHBOOT, CONFSIMBOOT and CONFBOOT) are set to use the default boot stage (since the boot scripts don't seem to run properly).


### An option is marked as "disabled"
A couple of the options in the `props` script will be automatically disabled in some circumstances. These are:  
- _"Edit device fingerprint"_ will be disabled if another Magisk module that is known to also edit the device fingerprint is installed. This is to avoid confusion about which fingerprint is actually applied.
- _"Device simulation"_ will be disabled if there is no device fingerprint set by the module.


### I can't pass the ctsProfile check
See ["I still can't pass the ctsProfile check"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#i-still-cant-pass-the-ctsprofile-check) above.

Also see ["Props don't seem to set properly"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#props-dont-seem-to-set-properly) below.


### I can't pass the basicIntegrity check
This module can usually only really help with the ctsProfile check, by spoofing the device fingerprint. If you can't pass basicIntegrity, there's probably something else going on with your device, but there is a possibility that changing the device fingerprint can make this pass as well. If you can't get things working, see ["Miscellaneous MagiskHide issues"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#miscellaneous-magiskhide-issues) above.


### Props don't seem to set properly
If it seems like props you're trying to set with the module don't get set properly (ctsProfile still doesn't pass, custom props don't work, etc), go into the script options and change the boot stage at which the props are being set, or change the boot stage for that particular prop, to late_start service. See ["Boot stage"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#boot-stage) or ["Custom prop values"](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#changeset-custom-prop-values) above. This might happen because the particular prop you're trying to set get assigned it's value late in the boot process and by setting the boot stage for the prop to the last one available (late_start service) you optimise the chances of the module setting the prop after the system.

If the boot stage already is set to the late_start service stage you might need to activate the soft reboot option for that particular setting. Sometimes a soft reboot is required after setting a prop for the value to be properly loaded into memory.

This may also be caused by the post-fs-data.sh script being set to run in the background because of the execution taking to long. Try disabling this option in the [script settings](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#prop-script-settings) and see if that changes anything.

There is also a possibility that the prop value you are trying to set is too long. This is only an issue on Magisk releases up until build 22006, where the prop value is limited to 91 characters. Builds after that should not have this issue.


### My build.prop doesn't change after using the module
Magisk doesn't alter the build.prop file when changing or removing a prop value, it simply loads a new value or prevents the prop to load instead of adding or removing it from build.prop. If you want to check if a prop has been changed use the `getprop` command in a terminal emulator to check. Example:
```
getprop ro.build.fingerprint
```
If the prop has been removed, the command should return nothing.


### My device's Android security patch date changed
For some fingerprints it is necessary to also change the security patch date to match the fingerprint used (the actual patch won't change, just the displayed date). This is automatically done by the module when using a fingerprint from a build after March 16 2018. If you do not want this to happen you can manually add `ro.build.version.security_patch` to the custom props and load back the original date, but keep in mind that this may result in the fingerprint not working and SafetyNet will fail.


### My device's model has changed
In order to fool SafetyNet into using basic key attestation for the bootloader state check rather than hardware (which we cannot fool), the device model sometimes has to be changed to one that does NOT match the actual device. If your device uses hardware backed attestation, you might have to do this to pass the CTS profile check of SafetyNet. See [Force BASIC key attestation](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/blob/master/README.md#force-basic-key-attestation) for more details.


### The Play Store is broken
If you suddenly can't find some apps, or that you aren't offered the latest version of an app, it might be because of having changed the device fingerprint. See [Can I use any fingerprint?](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#can-i-use-any-fingerprint) for details.


### The interface looks weird
If the interface of the props script looks strange, with a lot of gibberish along the lines of "\e[01;32m", that means that your terminal emulator of choice can't display colours properly (the "gibberish" is a colour code). Check the terminal emulators preferences if it is possible to change the terminal type to something that can display colours. You could also run the `props` command with the [-nc option](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#run-options) (No Colour), or disable colours in the [script settings](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/blob/master/README.md#script-colours).


### Boot takes a lot longer after setting props
If boot takes longer than usual after setting a new fingerprint or a custom prop, try changing the [boot stage](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config#boot-stage) to post-fs-data.


### There's a reboot during boot
This happens when any prop is set during the late_start service boot stage and the soft reboot option is enabled. A soft reboot can sometime be necessary to properly load the new prop values, but also has the potential for causing issues on some devices.


### The screen goes black momentarily at boot
See the section directly above about an additional reboot. Same thing.


### The Play Store is "uncertified"
If your device's Play Store reports that the device is "uncertified", this is usually fixed by making sure that you pass SafetyNet and then clearing data for the Play Store (and possibly rebooting). More details in the [Magisk troubleshooting guide](https://www.didgeridoohan.com/magisk/MagiskHide#hn_Device_uncertified_in_Play_storeNetflix_and_other_apps_wont_install_or_doesnt_show_up).


## Logs
In case of issues, please provide the logs by running the `props` script and selecting the "Collect logs" option (or running the `props` script with the -l run option, use -h for details, or collecting them manually as described below). All the relevant logs and module files, together with the Magisk log, the stock build.prop file and current prop values will be packaged into a file that'll be stored in the root of the device's internal storage, ready for attaching to a post in the [module support thread](https://forum.xda-developers.com/apps/magisk/module-magiskhide-props-config-t3789228), together with a detailed description of your problem.

The logs will also automatically be saved to the root of the device's internal storage if there's an issue with the module scripts.

If there are issues with other apps or your system as a result of using this module, a logcat/recovery log/etc showing the issue will most likely be necessary. Take a look in my [Magisk troubleshooting guide](https://www.didgeridoohan.com/magisk/MagiskHelp) for guidance on that.


### Collecting logs manually
If you can't run the `props` script for some reason, or the automatic option mentioned above doesn't work, the module logs are stored in /data/adb/mhpc and all files in that directory would be useful for troubleshooting. The Magisk log (retrieved from /cache or saved from the Magisk Manager) and magisk.log.bak would also help. Providing the output from terminal might be useful as well.

Please provide the above mentioned files in an archive (zip-file), for simplicity and convenience.


## Donations
If you've had any help from me or this module, any kind of [donation](https://forum.xda-developers.com/donatetome.php?u=4667597) to support the work involved would of course be appreciated.


## Source
[GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config)


## Credits and mentions
@topjohnwu @ XDA Developers, for Magisk.  
@Zackptg5, @veez21 and @jenslody @ XDA Developers, for help and inspiration.  
@Some_Random_Username @ XDA Developers, for all the OnePlus fingerprints.  
@Displax @ XDA Developers, for all the prints and the basic attestation workaround.  
@ipdev @ XDA Developers, for being always helpful, bringing tons of fingerprints to the module list and the [mHideGP script](https://github.com/ipdev99/mHideGP).  
And of course, everyone that provides fingerprints for me to add to the list. The module wouldn't be the same without you guys. Thank you!


## Previous releases
Any previous releases can be found on [GitHub](https://github.com/Magisk-Modules-Repo/MagiskHide-Props-Config/releases).

Releases up until v2.4.0 are compatible with Magisk v15 to v16.7.  
Releases from v2.4.1 are compatible with Magisk v17 to v18.1.  
Releases from v4.0.0 are compatible with Magisk v19+.  
Releases from v5.0.0 are recommended for Magisk v19.4+.  
Releases from v5.2.5 will only install on Magisk v20+.
Releases from v5.4.0 will only install on Magisk v20.4+.


## Changelog
### v6.1.2  
- Added rudimentary tampering check.
- Added fingerprints for OnePlus 9RT, Samsung Galaxy A52 4G and Xiaomi Mi 6X and Redmi K30 Pro. Updated fingerprints for OnePlus 6 to Nord CE, many variants. List updated to v137.

### v6.1.1  
- Updated custom props so that it's possible to set the same prop with different values during different boot stages.
- Updated some module checks to match the new state of Magisk (MagiskHide is dead, long live MagiskHide).
- Added fingerprints for LG G8 ThinQ, Samsung Galaxy S20 FE SM-G780F and Xiaomi Redmi K20 Europe. Updated fingerprints for Google Pixel 3 to 5a (all variants), Nokia 6.1 Plus, Oneplus 6T, 9 and 9 Pro (several variants), Xiaomi Mi 9T Europe, Mi 9T Pro Global and Redmi K20 Pro China. List updated to v135.

### v6.1.0  
- Added settings file version check.
- Added a check for the new Universal SafetyNet Fix and disable sensitive props at install if v2.1.0 or newer is detected.
- Changed default boot stage for SELinux fix and triggering props to late_start service.
- Fixed update check.
- Fixed a few problems with the configuration file import.
- Make sure late props are set after boot completed (might break some features otherwise, forgot about that).
- Minor UI fixes.
- Added fingerprints for Asus Smartphone for Snapdragon Insiders and Xiaomi Mi 11 Lite Indonesia. Updated fingerprint for Xiaomi Mi 10 Lite 5G Global. List updated to v133.

### v6.0.2  
- Fix problems when trying to disable/enable sensitive props.
- Fix typo when checking for triggering prop values (meant that props wouldn't set properly during boot).
- Fix UI info for if a sensitive prop has been set by the module or not.
- More optimisations of the new code (but it's by no means optimised).

### v6.0.1  
- Quickfix update to make the soft reboot when setting props in the late_start service boot stage an option. It has the potential for causing issues it seems (mainly on Samsung devices apparently). See the documentation for details.
- Minor UI fixes and optimisations.

### v6.0.0  
- Updated the "Edit MagiskHide props" feature to include all the sensitive prop values that MagiskHide changed, up to and including Magisk v23. All props will now be set by default. See the documentation for details.
- Alter the permissions for SELinux files if SELinux is permissive (was included in MagiskHide up to Magisk v23).
- Reenabled "Force BASIC key attestation", since Google seems to have changed things around again. See the documentation for details.
- Fix reboot function in post-fs-data.sh.
- Various small fixes.
- Added fingerprints for Google Pixel 5a and Motorola Moto Z3 Play. List updated to v132.

### v5.4.1  
- Changed internet connection test to use Github rather than Google, for users that do not have access to Google in their countries.
- Fixed a bug where prop values containing equal signs would be truncated.
- Fix error message in log regarding copying system.prop during module installation.
- Added fingerprints for the POCO F3 (Europe, Global, Indonesia, Russia, Taiwan and Turkey) and Redmi K40 China and updated the fingerprint for the Xiaomi Mi 8 Explorer. Fingerprints list updated to v131.

### v5.4.0  
- Removed "Force BASIC key attestation". Google has once again updated SafetyNet and this method no longer works to pass CTS on devices with hardware backed key attestation. Use @kdrag0n's Magisk module instead: https://forum.xda-developers.com/t/magisk-module-universal-safetynet-fix-1-1-0.4217823
- Added fingerprint for the Fairphone 3/3 Plus. List updated to v113.

### v5.3.6  
- Updated the menu item for picking a device manually for the "Force BASIC key attestation" feature to better match the menu option. Press "f" to pay respect.
- Minor updates to the "Force BASIC key attestation" menus to be more clear and informative (hopefully).
- Added fingerprints for Nvidia Shield TV 2015, 2015 Pro, 2019 and 2019 Pro, OnePlus 8T (several variants), Redmi Note 8 Pro	Global and Xiaomi Mi 10 Lite 5G Global and Mi 10 Ultra. Updated fingerprints for Nvidia Shield TV 2017, OnePlus 6, 6T, 8 (most variants) and 8 Pro (most variants), POCO F2 Pro European, Samsung Galaxy A40 and Note 20 Ultra 5G and Xiaomi Mi 9T Europe and Global, Mi A2, Mi A2 Lite, Pocophone F1 and Redmi Note 8. List updated to v106.

### v5.3.5  
- Fixed issue with partition model props not being set correctly.
- Make sure that simulating ro.product.model is completely disabled when enabling "Force BASIC key attestation".
- Removed Android versions from the device list when picking a model for "Force BASIC key attestation".

### v5.3.4  
- Added a module update check option. See the documentation for details.
- Added `system_ext` to the list of partitions used for certain props (thank you @simonsmh).
- Fixed an edge case where changing settings after updating the module, but not having rebooted yet would cause issues with system.prop being kept from the previous version.
- Fixed the -nw run option and made sure that some run options can't be picked together. See the documentation for details.
- Cleaned up some unused variables.
- Added print for Sony Xperia 10 II Dual XQ-AU52. Updated fingerprints for Google Pixel 2, 2 XL, 4, 4 XL and 4a, OnePlus 8 IN2015 and 8 Pro In2025 and Xiaomi Mi 10 Global, Mi 10 Pro and Pocophone F1. List updated to v102.

### v5.3.3  
- More (very) minor ui tweaks.
- Added fingerprint for Samsung Galaxy J7 Neo SM-J701M. Updated fingerprints for OnePlus 8 IN2013, 8 Pro IN2023, Nord AC2001, Nord European AC2003 and Nord Global AC2003 and Samsung Galaxy Tab S5e SM-T720. List updated to v5.
- There are 10 types of people in the world. Those who understand binary numbers and those who don't.

### v5.3.2  
- Some minor fixes/clarifications in the ui.
- Added PIXELARITY to the list of modules that also edit device fingerprint.
- Added fingerprint for Google Pixel 4a, Huawei Mate 9 and P9 EVA-AL10, OnePlus Nord Global AC2003, Samsung Galaxy A7 2018 and Xiaomi Mi 10 European. Updated print for Google Pixel 2-4 (all variants), Oneplus 6, 6T, 7 (several variants), 7 Pro (several variants), 7T (several variants), 7T Pro (several variants), 8 (several variants), 8 Pro (several variants) and OnePlus Nord, POCO F2 Pro, Samsung Galaxy A5 2017 and Xiaomi Mi A1, Mi A2 and Mi 9T European. List updated to v99.

### v5.3.1  
- Added a feature to enable a delay for when custom props to be executed (during the late_start service boot stage). See the documentation for details.
- Fixed a possibly longstanding bug where props couldn't be set using the ui on some devices (would get stuck on "Working. Please wait...").
- Fixed some of the settings in an exported settings file not being set correctly.
- Minor adjustments and bugfixes (mainly stupid bugs introduced in the last update).
- Added fingerprint for Nokia 6.1, Samsung Galaxy S5, S10 and Tab S4 and Xiaomi Mi 10 Lite 5G. Updated fingerprints for Asus ZenFone Max M1, Google Pixel 2-4 (all variants) and Xiaomi Pocofone F1. List updated to v97.

### v5.3.0  
- Added a new feature to force SafteyNet's bootloader check to use basic attestation rather than hardware. See the documentation for details.
- Added fingerprints for Asus ZenFone Max Pro M2, Fxtec Pro 1, Huawei Honor 6X BLN-L22, Lenovo Tab 4 8 Plus, LG V30, OnePlus 7, 7 Pro, 7T, 7T Pro, 8 and 8 Pro (Chinese variants), OnePlus Nord, Redmi Note 9 Pro, Samsung Galaxy A3 2016 and 2027 and Galaxy Tab 4 7.0, 8.0 and 10.1 and Xiaomi Redmi K20 Pro India. Updated fingerprints for OnePlus 7 Pro NR and 7 Pro NR Spr, 8 (almost all variants) and 8 Pro (all variants), Redmi Note 8 Pro and Xiaomi Mi A1, Mi A3 and Redmi 8. List updated to v95.

### v5.2.7  
- Added a new run option to set custom props directly from the command prompt. See the documentation for details. Shoutout to @ps000000 @ XDA Developers for putting the idea in my head.
- Added fingerprints for OnePlus 8 IN2019, Realme X2 Pro, Samsung Galaxy A90 5G and Tab A 8.0 LTE 2019. Updated fingerprints for Google Pixel 2-4 (all variants), Huawei P20, OnePlus 8 IN2017, POCO X2 and Xiaomi Mi A1, Mi A2, Mi A2 Lite and Mi A3. Fingerprints list updated to v94.

### v5.2.6  
- Fixed the supposedly "improved" verbose boot logging.
- Change to using Magisk's internal Busybox for the `props` script (the boot scripts are already using it without issues and have for some time). Separately installed Busybox no longer needed. Thank you @Juzman for the push.
- Added info about MagiskHide's status in the "Edit device fingeprint" menu.
- Added fingerprint for Lenovo Tab 4 10 Plus TB-X704F and TB-X704L, Samsung Galaxy Note 4 SM-N910G and Xiaomi Redmi Note 8. Updated fingerprints for Google Pixel 2-4 XL, Motorola Moto G7 Power, OnePlus 5, 5T, 6, 6T, several variants of 7, 7 Pro, several variants of 7T and 7T Pro and several variants of 8 and 8 Pro, Poco X2, Redmi K30 Pro, Samsung Galaxy A5 2017 and Xiaomi Mi A2, Mi A2 Lite and PocoPhone F1. List updated to v92.

### v5.2.5  
- Fixed and improved verbose boot logging.
- Fixed collecting logs producing a broken 0-byte file.
- Logging does not need to use nanoseconds. Microseconds is enough.
- Added ro.bootmode and ro.boot.mode to "Edit MagiskHide props".
- Don't use ro.build.selinux in "Edit MagiskHide props" if it isn't set.
- Added fingerprints for POCO F2 Pro, Redmi K30 Pro Zoom Edition and Note 9S, Samsung Galaxy A20 and Xiaomi Redmi 6 and 6A. Updated fingerprint for OnePlus 5, 5T, 7 Pro (GM1911 and GM1917) several variants of 8 and 8 Pro, Redmi K30 Pro and Xiaomi Mi A1, Mi A3, Redmi 7 and Redmi Note 7. Relabeled Xiaomi Redmi K30 Pro and Redmi Note 8 Pro with Redmi as manufacturer. List updated to v91.

### v5.2.4  
- Added a function for disabling the module by placing a specific file in /sdcard, /data or /cache (see the documentation for details). Useful if there are issues with booting the device after installing/setting up the module.
- Fixed some issues with setting partition props in other boot stages than default.
- Fixed an issue with boot scripts clashing if post-fs-data.sh script takes too long.
- Fixed an issue with settings transfer overwriting the file backup at install.
- Fixed an issue with log writing that came with the change to using getprop for retreiving prop values.
- Added fingerprints for Xiaomi Redmi 7. Updated fingerprints for Google Pixel 2-4 (all variants), OnePlus 7 Pro NR, Samsung Galaxy A5 2017 and Xiaomi Pocophone F1. Fingerprints list updated to v80.

### v5.2.3  
- Fixed issue with settings transferring between module updates.
- Use resetprop only to set values and retrieve values with getprop. For whatever reason some devices have issues with resetprop and this might make the module work on those.
- Updated fingerprints for OnePlus 6, 6T and 7T Pro NR. Fingerprints list updated to v79.

### v5.2.2  
- Another quick fix taking care of a weird copy-pasta error that broke manufacturer and model simulation.

### v5.2.1  
- Quick fix for broken fingerprints list and settings export.

### v5.2.0  
- Added ro.product.manufacturer and ro.product.model to simulation props.
- Added an option to also use partition specific versions of simulation props (see the documentation for details).
- Fixed basic device simulation so that it now only sets props that are already found on the device.
- Fixed changing MagiskHide sensitive props in late_start service boot stage (see the documentation for details).
- Updated simulation props editing so that several props can be activated at once (see the documentation for details).
- Updated MagiskHide sensitive prop editing so that several props can be activated at once (see the documentation for details).
- Added a new feature to export current module settings to a configuratino file (see the documentation for details).
- Updated the documentation and added Android Dumps as a resource for finding certified fingerprints (see the documentation for details).
- Various under the hood changes and improvements.
- Added fingerprint for Samsung Galaxy Note 9 and Xiaomi Mi Box S. Updated fingerprints for HTC U12 Plus, Nokia 6.1 Plus and several variants of OnePlus 7, 7 Pro and 7T. List updated to v78.

### v5.1.2  
- Reset current fingerprint if disabling fingerprint modification because of a conflicting module.
- Fixed using the configuration file in /sdcard during boot on FBE encrypted devices.
- Added fingerprint for Huawei P20 (L09 single SIM), Motorola Moto G7 Power, Samsung Galaxy Core Prime and Xiaomi Mi 9 SE. Updated fingerprint for OnePlus 7 Pro NR and Razer Phone 2. List updated to v73.

### v5.1.1  
- Updated the module to conform with the current module installation setup.
- Minor updates.
- Added fingerprint for Samsung Galaxy Note 10 Plus and Xiaomi Mi 9T (Global version). Updated fingerprints for Essential PH-1, Google Pixel 2-4 (all variants), Oneplus 5, 5T and 6T, Xiaomi Mi 9T (European version), Mi Mix 2 and Redmi Note 4/4x. Fingerprints list updated to v72.

### v5.1.0  
- Fixed issue caused by some devices toybox commands not working as expected.
- Cleaned up the post-fs-data script to remove unnecessary strain from the boot process. Moved as much as possible to the late_start service boot script instead. Among other things, this means that there will be a reboot late in the boot process when using the configuration file during boot (see the documentation for details).
- Added new script setting to execute the post-fs-data module boot script completely in the background (see the documentation for details).
- Fixed some typos.
- Various minor fixes and optimisations (which just means I can't remember exactly what I did and can't be bothered to look it up).
- Added fingerprints for the Fairphone 2, Google Pixel 4 and 4 XL, OnePlus 7T and Samsung Galaxt Tab A WiFi. Updated fingerprints for the Essential PH-1, Google Pixel 2-3a (both regular and XL), OnePlus 6, 6T, 7 Pro and 7 Pro NR, Samsung Galaxy A5 2017 and Xiaomi Mi 9 Lite and Redmi K20 Pro/Mi 9T Pro. List updated to v66.

### v5.0.1  
- Fixed issue with settings being cleared when updating from earlier module versions. Sorry if anyone got all their custom props removed...
- Fixed issue with creating a custom prints list.
- Fixed issue with saving Magisk log.
- Added fingerprint for Xiaomi Note 7 Pro. Fingerprints list updated to v65.

### v5.0.0  
- Updated possible locations for both the configuration and reset files (can now be placed in the root of internal storage, in /data or in /cache).
- Updated device simulation so that all props now are disabled by default. Should hopefully make a few less careless users experience issues caused by the feature. NOTE! All simulation prop values will be disabled with this update. If you did have basic simulation enabled prior to the update, you have to manually enable it again.
- Updated device simulation and added ro.build.display.id.
- Updated reboot function.
- Fixed a bug with the reset file (reset_mhpc) where system.prop would not be reset.
- Fixed the setting of fingerprint props so that props that aren't already present on the device won't be set.
- Fixed a bug where too similar custom props could not be set.
- Fixed removal of old settings file on a fresh install.
- Fixed possible issues with retrieving default file values on some devices/ROMs.
- Fixed an issue where colours and clearing of the screen between menus don't work on Magisk v19.4+. Credits to @veez21 for the fix.
- Stopped using /cache for logs and other module files. New location is /data/adb/mhpc. See the documentation for details.
- Removed the "Improved root hiding" feature. It is most likely just placebo, but more importantly will also mount the system partition as rw on SAR devices. Big no-no... Might make a reworked reapperance in the future.
- Slight tweaks to the ui and on-screen instructions, for (hopefully) better clarity and understanding.
- Updated fingerprints for Asus Zenfone 6, Essential PH-1, Google Pixel 1-3a (regular and XL) and Pixel C, Huawei Mate 20 Pro, Motorola Moto G5S, OnePlus 5, 5T, 6T and 7 Pro, Samsung Galaxy A5 2017, Xiaomi Mi A2, Pocophone F1, Redmi 5A, Redmi K20 Pro, Redmi Note 5 Pro and Redmi Note 7. Added prints for Asus Zenfone 3 Max, Nokia 6.1 Plus, OnePlus One, Walmart Onn 8, Xiaomi Mi 9 Lite, Mi 9T, Mi A3, Redmi 4A and Redmi Note 4 Mediatek. Removed fingerprint for the LG G6 H872. List updated to v64.

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
### List v137  
- Asus ROG Phone 3 ZS661KS (10)
- Asus ROG Phone 5 ZS673KS (10)
- Asus Smartphone for Snapdragon Insiders ASUS_I007D (11)
- Asus ZenFone 2 Laser ASUS_Z00LD (6.0.1)
- Asus ZenFone 3 Max ASUS_X00DD (7.1.1 & 8.1.0)
- Asus ZenFone 3 Ultra ASUS_A001 (7.0)
- Asus ZenFone 4 ASUS_Z01KD (8.0.0 & 9)
- Asus ZenFone 4 Max ASUS_X00HD (7.1.1)
- Asus ZenFone 5 ASUS_X00QD (9)
- Asus ZenFone 5Z ASUS_Z01RD (9)
- Asus ZenFone 6 ASUS_I01WD (9)
- Asus ZenFone 7/7 Pro Europe ASUS_I002D (10)
- Asus ZenFone 7/7 Pro Global ASUS_I002D (10)
- Asus ZenFone Max M1 ASUS_X00PD (8.0.0 & 9 & 10)
- Asus ZenFone Max Pro M1 ASUS_X00TD (8.1.0 & 9)
- Asus ZenFone Max Pro M2 ASUS_X01BD (9)
- Asus Zenfone 8 Mini Europe ASUS_I006D (11)
- Asus Zenfone 8 Mini Global ASUS_I006D (11)
- Asus ZenPad S 8.0 P01MA (6.0.1)
- BLU S1 (7.0)
- BLU Vivo XI (8.1.0)
- Elephone U Pro (8.0.0)
- Essential PH-1 (7.1.1 & 8.1.0 & 9 & 10)
- Fairphone 2 (6.0.1)
- Fairphone 3/3 Plus (10)
- Fxtec Pro 1 (9)
- Google Nexus 4 (5.1.1)
- Google Nexus 5 (6.0.1)
- Google Nexus 5X (6.0 & 6.0.1 & 7.0 & 7.1.1 & 7.1.2 & 8.0.0 & 8.1.0)
- Google Nexus 6 (5.0 & 5.0.1 & 5.1 & 5.1.1 & 6.0 & 6.0.1 & 7.0 & 7.1.1)
- Google Nexus 6P (6.0 & 6.0.1 & 7.0 & 7.1.1 & 7.1.2 & 8.0.0 & 8.1.0)
- Google Nexus 7 2012 Mobile (5.1.1)
- Google Nexus 7 2012 WiFi (5.1.1)
- Google Nexus 7 2013 Mobile (6.0.1)
- Google Nexus 7 2013 WiFi (6.0.1)
- Google Nexus 9 LTE (5.0.1 & 5.0.2 & 5.1.1 & 6.0 & 6.0.1 & 7.0 & 7.1.1)
- Google Nexus 9 WiFi (5.0 & 5.0.1 & 5.0.2 & 5.1.1 & 6.0 & 6.0.1 & 7.0 & 7.1.1)
- Google Nexus 10 (5.1.1)
- Google Nexus Player (5.0 & 5.1 & 5.1.1 & 6.0.1 & 7.0 & 7.1.1 & 7.1.2 & 8.0.0)
- Google Pixel (7.1 & 7.1.1 & 7.1.2 & 8.0.0 & 8.1.0 & 9 & 10)
- Google Pixel XL (7.1 & 7.1.1 & 7.1.2 & 8.0.0 & 8.1.0 & 9 & 10)
- Google Pixel 2 (8.0.0 & 8.1.0 & 9 & 10 & 11)
- Google Pixel 2 XL (8.0.0 & 8.1.0 & 9 & 10 & 11)
- Google Pixel 3 (9 & 10 & 11 & 12)
- Google Pixel 3 XL (9 & 10 & 11 & 12)
- Google Pixel 3a (9 & 10 & 11 & 12)
- Google Pixel 3a XL (9 & 10 & 11 & 12)
- Google Pixel 4 (10 & 11 & 12)
- Google Pixel 4 XL (10 & 11 & 12)
- Google Pixel 4a (10 & 11 & 12)
- Google Pixel 4a 5G (11 & 12)
- Google Pixel 5 (11 & 12)
- Google Pixel 5a (11 & 12)
- Google Pixel 6 (12)
- Google Pixel 6 Pro (12)
- Google Pixel C (6.0.1 & 7.0 & 7.1.1 & 7.1.2 & 8.0.0 & 8.1.0)
- HTC 10 (6.0.1)
- HTC U11 (8.0.0)
- HTC U12 Plus (8.0.0 & 9)
- HTC Exodus 1 (9)
- Huawei Honor 6X BLN-AL10 (8.0.0)
- Huawei Honor 6X BLN-L22 (8.0.0)
- Huawei Honor 8X JSN-L21 (8.1.0)
- Huawei Honor 9 STF-L09 (8.0.0 & 9)
- Huawei Mate 9 MHA-L29 (9)
- Huawei Mate 10 ALP-L29 (8.0.0)
- Huawei Mate 10 Pro BLA-L29 (8.0.0)
- Huawei Mate 20 Lite SNE-LX1 (9)
- Huawei Mate 20 Pro LYA-L29 (9)
- Huawei P8 Lite PRA-LX1 (8.0.0)
- Huawei P9 EVA-AL10 (8.0.0)
- Huawei P9 EVA-L09 (7.0)
- Huawei P9 Lite VNS-L31 (7.0)
- Huawei P9 Plus VIE-AL10 (8.0.0)
- Huawei P9 Plus VIE-L09 (7.0)
- Huawei P10 Lite (8.0.0)
- Huawei P20 EML-L09 (9 & 10)
- Huawei P20 Dual SIM EML-L29 (9)
- Huawei P20 Lite (9)
- Huawei P20 Lite Dual SIM (8.0.0 & 9)
- Huawei P20 Pro CLT-L29 (8.1.0 & 9)
- Infinix Note 5 (9 & 10)
- Lenovo K6 Note (7.0)
- Lenovo Tab 4 8 Plus TB-8704F (8.1.0)
- Lenovo Tab 4 10 Plus TB-X704F (7.1.1)
- Lenovo Tab 4 10 Plus TB-X704L (7.1.1)
- LeEco Le Pro3 (6.0.1)
- LG G2 VS980 (5.0.2)
- LG G4 H812 (6.0)
- LG G5 H830 (8.0.0)
- LG G5 H850 (8.0.0)
- LG G5 RS988 (7.0)
- LG G6 H870 (7.0 & 8.0.0)
- LG G7 ThinQ LM-G710 (9)
- LG G8 ThinQ LM G850l (11)
- LG K20 Plus LG-TP260 (7.0)
- LG K20 Plus LGMP260 (7.0)
- LG K20 V VS501 (7.0)
- LG V20 H910 (8.0.0)
- LG V20 H918 (8.0.0)
- LG V20 H990DS (7.0)
- LG V20 LS997 (8.0.0)
- LG V20 US996 (8.0.0)
- LG V20 VS995 (8.0.0)
- LG V30 H930 (8.0.0)
- LG V30 LS998 (8.0.0)
- Mecool KM8 (8.0.0 & 9)
- Meizu 16th (8.1.0)
- Meizu 17 (10)
- Meizu X8 (8.1.0)
- Motorola Moto C Plus (7.0)
- Motorola Moto E4 (7.1.1)
- Motorola Moto E4 Plus (7.1.1)
- Motorola Moto E5 Play (8.0.0)
- Motorola Moto E5 Plus (8.0.0)
- Motorola Moto Edge (10 & 11)
- Motorola Moto G Stylus (10)
- Motorola Moto G 5g (10)
- Motorola Moto G 5g Plus (10 & 11)
- Motorola Moto G Pro (11)
- Motorola Moto G4 (7.0 & 8.1.0)
- Motorola Moto G5 (7.0)
- Motorola Moto G5 Plus (7.0)
- Motorola Moto G5S (7.1.1 & 8.1.0)
- Motorola Moto G5S Plus (8.1.0)
- Motorola Moto G6 (9)
- Motorola Moto G6 Play (8.0.0 & 9)
- Motorola Moto G6 Plus (9)
- Motorola Moto G7 XT1962-1 (9 & 10)
- Motorola Moto G7 XT1962-5 (10)
- Motorola Moto G7 Power (9 & 10)
- Motorola Moto G7 Play (9 & 10)
- Motorola Moto G7 Play T-Mobile (10)
- Motorola Moto Razr 2020 (10 & 11)
- Motorola Moto X Play (7.1.1)
- Motorola Moto X4 (8.0.0 & 9)
- Motorola Moto Z2 Force T-Mobile (8.0.0)
- Motorola Moto Z2 Play (8.0.0)
- Motorola Moto Z3 Play (9)
- Nextbook Ares 8A (6.0.1)
- Nokia 6 TA-1021 (9)
- Nokia 6 TA-1025 (9)
- Nokia 6 TA-1033 (9)
- Nokia 6 TA-1039 (9)
- Nokia 6.1 (10)
- Nokia 6.1 Plus (9 & 10)
- Nokia 6.2 (9)
- Nokia 7 Plus (9 & 10)
- Nokia 7.1 TA-1095 (10)
- Nvidia Shield Tablet K1 (7.0)
- Nvidia Shield Tablet LTE (7.0)
- Nvidia Shield Tablet WiFi (7.0)
- Nvidia Shield TV 2015 (8.0.0 & 9)
- Nvidia Shield TV 2015 Pro (8.0.0 & 9)
- Nvidia Shield TV 2017 (8.0.0 & 9)
- Nvidia Shield TV 2019 (9)
- Nvidia Shield TV 2019 Pro (9)
- OnePlus One (6.0.1)
- OnePlus 2 (6.0.1)
- OnePlus X (6.0.1)
- OnePlus 3 (8.0.0 & 9)
- OnePlus 3T (8.0.0 & 9)
- OnePlus 5 (8.1.0 & 9 & 10)
- OnePlus 5T (7.1.1 & 8.0.0 & 8.1.0 & 9 & 10)
- OnePlus 6 (8.1.0 & 9 & 10 & 11)
- OnePlus 6T (9 & 10 & 11)
- OnePlus 6T T-Mobile (9 & 10)
- OnePlus 7 China GM1900 (10 & 11)
- OnePlus 7 GM1901 (9 & 10 & 11)
- OnePlus 7 Europe GM1903 (9 & 10 & 11)
- OnePlus 7 GM1905 (9 & 10 & 11)
- OnePlus 7 Pro China GM1910 (10 & 11)
- OnePlus 7 Pro GM1911 (9 & 10 & 11)
- OnePlus 7 Pro Europe GM1913 (9 & 10 & 11)
- OnePlus 7 Pro T-Mobile GM1915 (9 & 10 & 11)
- OnePlus 7 Pro GM1917 (9 & 10 & 11)
- OnePlus 7 Pro NR Europe GM1920 (9 & 10)
- OnePlus 7 Pro NR Sprint GM1925 (9 & 10)
- OnePlus 7T China HD1900 (10 & 11)
- OnePlus 7T HD1901 (10 & 11)
- OnePlus 7T Europe HD1903 (10 & 11)
- OnePlus 7T HD1905 (10 & 11)
- OnePlus 7T T-Mobile HD1907 (11)
- OnePlus 7T Pro China HD1910 (10 & 11)
- OnePlus 7T Pro HD1911 (10 & 11)
- OnePlus 7T Pro Europe HD1913 (10 & 11)
- OnePlus 7T Pro HD1917 (10 & 11)
- OnePlus 7T Pro NR HD1925 (10 & 11)
- OnePlus 8 China IN2010 (10 & 11)
- OnePlus 8 India IN2011 (10 & 11)
- OnePlus 8 Europe IN2013 (10 & 11)
- OnePlus 8 Global IN2015 (10 & 11)
- OnePlus 8 Visible IN2015 (10 & 11)
- OnePlus 8 T-Mobile IN2017 (10 & 11)
- OnePlus 8 Verizon IN2019 (10)
- OnePlus 8 Pro China IN2020 (10 & 11)
- OnePlus 8 Pro India IN2021 (10 & 11)
- OnePlus 8 Pro Europe IN2023 (10 & 11)
- OnePlus 8 Pro Global IN2025 (10 & 11)
- OnePlus 8T China KB2000 (11)
- OnePlus 8T India KB2001 (11)
- OnePlus 8T Europe KB2003 (11)
- OnePlus 8T Global KB2005 (11)
- OnePlus 8T T-Mobile KB2007 (11)
- OnePlus 9 India LE2111 (11 & 12)
- OnePlus 9 Europe LE2113 (11)
- OnePlus 9 LE2115 (11 & 12)
- OnePlus 9 TMO LE2117 (11)
- OnePlus 9 Pro India LE2121 (11 & 12)
- OnePlus 9 Pro Europe LE2123 (11)
- OnePlus 9 Pro LE2125 (11 & 12)
- OnePlus 9 Pro TMO LE2127 (11)
- OnePlus 9R India LE2101 (11)
- OnePlus 9RT China MT2110 (11)
- OnePlus N10 5G Global BE2026 (10 & 11)
- OnePlus N10 5G Europe BE2029 (10 & 11)
- OnePlus N10 5G Metro BE2025 (10 & 11)
- OnePlus N10 5G T-Mobile BE2028 (10 & 11)
- OnePlus N100 Global BE2011 (10 & 11)
- OnePlus N100 Europe BE2013 (10 & 11)
- OnePlus N100 Metro BE2015 (10 & 11)
- OnePlus N100 T-Mobile BE2012 (10 & 11)
- OnePlus N200 Global DE2117 (11)
- OnePlus N200 T-Mobile DE2118 (11)
- OnePlus Nord India AC2001 (10 & 11)
- OnePlus Nord Europe AC2003 (10 & 11)
- OnePlus Nord Global AC2003 (10 & 11)
- OnePlus Nord 2 India DN2101 (11)
- OnePlus Nord 2 Europe DN2103 (11)
- OnePlus Nord CE EB13AA (11)
- OnePlus Nord CE India EB2101 (11)
- OnePlus Nord CE Europe EB2103 (11)
- OPPO A53s Europe (10)
- OPPO Find X2 Neo Europe CPH2009 (10 & 11)
- OPPO Neo 7 A33w (5.1)
- OPPO Neo 7 A1603 (5.1)
- POCO F2 Pro Europe (10)
- POCO F2 Pro Global (10 & 11)
- POCO F3 Europe (11)
- POCO F3 Global (11)
- POCO F3 Indoniesia (11)
- POCO F3 Russia (11)
- POCO F3 Taiwan (11)
- POCO F3 Turkey (11)
- POCO M3 Pro 5G Indonesia (11)
- POCO X2 (10)
- POCO X3 NFC Europe (10 & 11)
- POCO X3 NFC Global (10 & 11)
- POCO X3 Pro Global (11)
- Razer Phone (7.1.1 & 8.1.0 & 9)
- Razer Phone 2 (8.1.0 & 9)
- Realme X2 Pro (10)
- Realme XT RMX1921 (10)
- Redmi 9T Global (10)
- Redmi K30 Pro China (10)
- Redmi K30 Pro Zoom Edition China (10)
- Redmi K30 Ultra China (10)
- Redmi K30S Ultra China (10)
- Redmi K40 China (11)
- Redmi Note 8 Pro Europe (10 & 11)
- Redmi Note 8 Pro Global (9 & 10)
- Redmi Note 8 Pro India (9 & 10)
- Redmi Note 8 Pro Russia (9 & 10)
- Redmi Note 9 Pro Europe (10)
- Redmi Note 9 Pro Global (10)
- Redmi Note 9 Pro Indonesia (10)
- Redmi Note 9 Pro Max India (10)
- Redmi Note 9S Europe (10)
- Redmi Note 9S Global (10 & 11)
- Redmi Note 10 Pro Global (11)
- Samsung Galaxy A01 Core (10)
- Samsung Galaxy A3 2015 SM-A300FU (6.0.1)
- Samsung Galaxy A3 2016 SM-A310F (7.0)
- Samsung Galaxy A3 2017 SM-A320FL (8.0.0)
- Samsung Galaxy A5 2015 SM-A500FU (6.0.1)
- Samsung Galaxy A5 2016 SM-A510F (7.0)
- Samsung Galaxy A5 2017 SM-A520F (8.0.0)
- Samsung Galaxy A6 SM-A600F (10)
- Samsung Galaxy A6 Plus SM-A605G (9)
- Samsung Galaxy A7 2017 SM-A720F (8.0.0)
- Samsung Galaxy A7 2018 SM-A750GN (9 & 10)
- Samsung Galaxy A8 Plus SM-A730F (7.1.1)
- Samsung Galaxy A20 SM-A205W (9)
- Samsung Galaxy A40 SM-A405FN (10)
- Samsung Galaxy A50 SM-A505F (9)
- Samsung Galaxy A50S SM-A507FN (10)
- Samsung Galaxy A51 SM-A515F (10)
- Samsung Galaxy A52 4G (11)
- Samsung Galaxy A70 SM-A705FN (10)
- Samsung Galaxy A71 SM-A715F (10)
- Samsung Galaxy A90 5G SM-A908B (9)
- Samsung Galaxy Core Prime SM-G361F (5.1.1)
- Samsung Galaxy Grand Prime SM-G530BT (5.0.2)
- Samsung Galaxy J2 2015 SM-J200H (5.1.1)
- Samsung Galaxy J2 Core SM-S260DL (8.1.0)
- Samsung Galaxy J3 SM-J320FN (5.1.1)
- Samsung Galaxy J5 2015 SM-J500FN (6.0.1)
- Samsung Galaxy J5 2016 SM-J510FN (7.1.1)
- Samsung Galaxy J5 Prime SM-G570F (7.0)
- Samsung Galaxy J7 2016 SM-J710FQ (8.1.0)
- Samsung Galaxy J7 2017 SM-J730F (8.1.0)
- Samsung Galaxy J7 Neo SM-J701M (8.1.0)
- Samsung Galaxy J7 Prime SM-G610F (6.0.1)
- Samsung Galaxy M20 SM-M205F (10)
- Samsung Galaxy M21 SM-M215F (10)
- Samsung Galaxy Note 3 SM-N9005 (5.0)
- Samsung Galaxy Note 4 SM-N910F (6.0.1)
- Samsung Galaxy Note 4 SM-N910G (6.0.1)
- Samsung Galaxy Note 5 SM-N920C (7.0)
- Samsung Galaxy Note 8 SM-N950F (8.0.0)
- Samsung Galaxy Note 9 SM-N960F (10)
- Samsung Galaxy Note 10 Plus SM-N9750 (10)
- Samsung Galaxy Note 10 Plus SM-N975F (10)
- Samsung Galaxy Note 10 Plus SM-N975U (10)
- Samsung Galaxy Note 10.1 2014 SM-P600 (5.1.1)
- Samsung Galaxy Note 20 Ultra SM-N986U (10)
- Samsung Galaxy Note 20 Ultra 5G SM-N9860 (10)
- Samsung Galaxy Note 20 Ultra 5G SM-N986B/DS (10)
- Samsung Galaxy S3 Neo GT-I9300I (4.4.4)
- Samsung Galaxy S4 GT-I9505 (5.0.1)
- Samsung Galaxy S4 Active GT-I9295 (5.0.1)
- Samsung Galaxy S5 SM-G900F (6.0.1)
- Samsung Galaxy S5 SM-G900H (6.0.1)
- Samsung Galaxy S6 SM-G920F (7.0)
- Samsung Galaxy S6 Edge SM-G925F (7.0)
- Samsung Galaxy S7 SM-G930F (8.0.0)
- Samsung Galaxy S7 Edge SM-G935F (8.0.0)
- Samsung Galaxy S8 SM-G950F (8.0.0)
- Samsung Galaxy S8 Plus SM-G955F (8.0.0)
- Samsung Galaxy S9 SM-G960F (8.0.0 & 10)
- Samsung Galaxy S9 Plus SM-G965F (8.0.0)
- Samsung Galaxy S10 SM-G973F (10 & 11)
- Samsung Galaxy S10 SM-G973F Europe (11)
- Samsung Galaxy S10 SM-G973N (11)
- Samsung Galaxy S10 5G SM-G977B (11)
- Samsung Galaxy S10 5G SM-G977N (11)
- Samsung Galaxy S10 Lite SM-G770F (11)
- Samsung Galaxy S10 Plus SM-G975F (10 & 11)
- Samsung Galaxy S10 Plus SM-G975F Europe (11)
- Samsung Galaxy S10 Plus SM-G975N (11)
- Samsung Galaxy S10 Plus SM-G975U (9)
- Samsung Galaxy S10e SM-G970F (10 & 11)
- Samsung Galaxy S10e SM-G970F Europe (11)
- Samsung Galaxy S10e SM-G970N (10 & 11)
- Samsung Galaxy S20 FE SM-G780F (11)
- Samsung Galaxy S20 FE 5G SM-G781B (10)
- Samsung Galaxy S20 Ultra SM-G988B (10)
- Samsung Galaxy S21 SM-G991B (11)
- Samsung Galaxy Tab 2 7.0 GT-P5110 (4.2.2)
- Samsung Galaxy Tab 4 7.0 SM-T230NU (4.4.2)
- Samsung Galaxy Tab 4 8.0 SM-T330NU (5.1.1)
- Samsung Galaxy Tab 4 10.1 SM-T530NU (5.0.2)
- Samsung Galaxy Tab A 8.0 LTE 2019 SM-T295 (9)
- Samsung Galaxy tab A 10.1 WiFi 2019 SM-T510 (10)
- Samsung Galaxt Tab A WiFi SM-T590 (9)
- Samsung Galaxt Tab A LTE SM-T595 (9)
- Samsung Galaxt Tab A LTE SM-T597 (9)
- Samsung Galaxy Tab E 9.6 SM-T560 (4.4.4)
- Samsung Galaxy Tab S2 SM-T813 (7.0)
- Samsung Galaxy Tab S3 LTE SM-T825 (8.0.0)
- Samsung Galaxy Tab S4 WiFi SM-T830 (10)
- Samsung Galaxy Tab S4 LTE SM-T835 (10)
- Samsung Galaxy Tab S4 LTE SM-T837A (10)
- Samsung Galaxy Tab S5e SM-T720 (9 & 10 & 11)
- Samsung Galaxy Tab S6 Lite SM-P610 (10)
- Samsung Galaxy Tab S7+ WiFi SM-T970 (11)
- Sony Xperia 5 DSDS J9210 (10)
- Sony Xperia 10 (10)
- Sony Xperia 10 II Dual XQ-AU52 (10)
- Sony Xperia M (4.3)
- Sony Xperia X F5121 (8.0.0)
- Sony Xperia X Compact F5321 (8.0.0)
- Sony Xperia X Dual F5122 (8.0.0)
- Sony Xperia X Performance F8131 (8.0.0)
- Sony Xperia X Performance Dual F8132 (8.0.0)
- Sony Xperia XA2 Dual H4113 (8.0.0)
- Sony Xperia XA2 Ultra H3223 (9)
- Sony Xperia XZ F8331 (8.0.0)
- Sony Xperia XZ Dual F8332 (8.0.0)
- Sony Xperia XZ Premium G8141 (8.0.0)
- Sony Xperia XZ Premium Dual G8142 (8.0.0)
- Sony Xperia XZ1 G8341 (8.0.0)
- Sony Xperia XZ1 Compact G8441 (8.0.0 & 9)
- Sony Xperia XZ1 Dual G8342 (8.0.0)
- Sony Xperia XZ2 H8216 (8.0.0)
- Sony Xperia XZ2 Compact H8314 (8.0.0)
- Sony Xperia XZ2 Compact Dual H8324 (8.0.0)
- Sony Xperia XZ2 Dual H8266 (8.0.0)
- Sony Xperia Z C6603 (5.1.1)
- Sony Xperia Z1 C6903 (5.1.1)
- Sony Xperia Z2 D6503 (6.0.1)
- Sony Xperia Z3 D6633 (6.0.1)
- Sony Xperia Z3 Compact D5803 (6.0.1)
- Sony Xperia Z3 Tablet Compact SGP621 (6.0.1)
- Sony Xperia Z4 Tablet LTE SGP771 (7.1.1)
- Sony Xperia Z5 E6603 (7.1.1)
- Sony Xperia Z5 E6653 (7.1.1)
- Sony Xperia Z5 Compact E5823 (7.1.1)
- Sony Xperia Z5 Dual E6633 (7.1.1)
- Sony Xperia Z5 Premium E6853 (7.1.1)
- Sony Xperia Z5 Premium Dual E6883 (7.1.1)
- Vodafone Smart Ultra 6 (5.1.1)
- Walmart Onn 8 (9)
- Xiaomi Mi 3 Global (6.0.1)
- Xiaomi Mi 4 Global (6.0.1)
- Xiaomi Mi 4C China (7.0)
- Xiaomi Mi 5/5 Pro Global (7.0 & 8.0.0)
- Xiaomi Mi 5S Global (7.0)
- Xiaomi Mi 5S Plus Global (6.0.1 & 7.0)
- Xiaomi Mi 6 Global (8.0.0 & 9)
- Xiaomi Mi 6X China (9)
- Xiaomi Mi 8 Global (8.1.0 & 9 & 10)
- Xiaomi Mi 8 Explorer (10)
- Xiaomi Mi 8 Pro Global (10)
- Xiaomi Mi 8 Pro Russia (10)
- Xiaomi Mi 9 China (10 & 11)
- Xiaomi Mi 9 Europe (9)
- Xiaomi Mi 9 Lite Global (9)
- Xiaomi Mi 9 SE Global (9)
- Xiaomi Mi 9T China (10)
- Xiaomi Mi 9T Europe (9 & 10 & 11)
- Xiaomi Mi 9T Pro China (9 & 10)
- Xiaomi Mi 9T Pro Europe (10)
- Xiaomi Mi 9T Pro Global (10 & 11)
- Xiaomi Mi 10 China (10 & 11)
- Xiaomi Mi 10 Europe (10)
- Xiaomi Mi 10 Lite 5G Europe (10)
- Xiaomi Mi 10 Lite 5G Global (10 & 11)
- Xiaomi Mi 10 Pro China (10 & 11)
- Xiaomi Mi 10 Ultra China (10 & 11)
- Xiaomi Mi 10S China (11)
- Xiaomi Mi 10T Europe (10)
- Xiaomi Mi 10T Lite Europe (10)
- Xiaomi Mi 10T Pro Europe (10)
- Xiaomi Mi 11 China (11)
- Xiaomi Mi 11 Lite Indonesia (11)
- Xiaomi Mi A1 Global (7.1.2 & 8.0.0 & 8.1.0 & 9)
- Xiaomi Mi A2 Global (8.1.0 & 9 & 10)
- Xiaomi Mi A2 Lite Global (8.1.0 & 9 & 10)
- Xiaomi Mi A3 Europe (9 & 10 & 11)
- Xiaomi Mi A3 Global (9 & 10 & 11)
- Xiaomi Mi Box S (9)
- Xiaomi Mi Max Global (6.0.1)
- Xiaomi Mi Max 2 Global (7.1.1)
- Xiaomi Mi Max 3 Global (9)
- Xiaomi Mi Mix 2 Global (8.0.0 & 9)
- Xiaomi Mi Mix 2S Global (8.0.0 & 9)
- Xiaomi Mi Mix 2S China (10)
- Xiaomi Mi Mix 3 Global (9 & 10)
- Xiaomi Mi Mix 3 5G Europe (9)
- Xiaomi Mi Note 2 China (8.0.0)
- Xiaomi Mi Note 2 Global (7.0)
- Xiaomi Mi Note 3 Global (8.1.0)
- Xiaomi Mi Note 10 Europe (9)
- Xiaomi Mi Pad Global (4.4.4)
- Xiaomi Mi Pad 4 China (8.1.0)
- Xiaomi Pocophone F1 Global (9 & 10)
- Xiaomi Redmi 3/3 Pro Global (5.1.1)
- Xiaomi Redmi 3S/X Prime Global (6.0.1)
- Xiaomi Redmi 4 Pro Global (6.0.1)
- Xiaomi Redmi 4A Global (7.1.2)
- Xiaomi Redmi 4X China (6.0.1)
- Xiaomi Redmi 5 Plus Global (7.1.2 & 8.1.0)
- Xiaomi Redmi 5A Global (7.1.2 & 8.1.0)
- Xiaomi Redmi 6 Global (9)
- Xiaomi Redmi 6 Pro China (9)
- Xiaomi Redmi 6 Pro India (9)
- Xiaomi Redmi 6A Global (9)
- Xiaomi Redmi 7 Europe (10)
- Xiaomi Redmi 7 Global (9)
- Xiaomi Redmi 7A Global (9 & 10)
- Xiaomi Redmi 8 China (9 & 10)
- Xiaomi Redmi 9 China (10)
- Xiaomi Redmi Go Global (8.1.0)
- Xiaomi Redmi K20 Europe (11)
- Xiaomi Redmi K20 Pro China (9 & 10 & 11)
- Xiaomi Redmi K20 Pro Europe (10)
- Xiaomi Redmi K20 Pro Global (10)
- Xiaomi Redmi K20 Pro India (10)
- Xiaomi Redmi K30 Pro China (11)
- Xiaomi Redmi Note 2 Global (5.0.2)
- Xiaomi Redmi Note 3 Pro China (6.0.1)
- Xiaomi Redmi Note 3 Pro SE Global (6.0.1)
- Xiaomi Redmi Note 4 Global (7.0)
- Xiaomi Redmi Note 4X Global (7.0)
- Xiaomi Redmi Note 4 Mediatek Global (6.0)
- Xiaomi Redmi Note 5 Global (7.1.2 & 8.1.0)
- Xiaomi Redmi Note 5 Pro Global (8.1.0 & 9)
- Xiaomi Redmi Note 5A Lite Global (7.1.2)
- Xiaomi Redmi Note 6 Pro Global (8.1.0 & 9)
- Xiaomi Redmi Note 7 Global (9)
- Xiaomi Redmi Note 7 Pro India (9)
- Xiaomi Redmi Note 8 Global (9 & 10)
- Xiaomi Redmi Note 8T Europe (9 & 10)
- Xiaomi Redmi Y1 Global (7.1.2)
- ZTE Axon 7 (7.1.1 & 8.0.0)
- ZTE Blade (6.0.1)
- ZTE Nubia Z17 (7.1.1)
- Zuk Z2 Pro (7.0)

## MIT Licence

*Copyright (c) 2018-2021 Didgeridoohan*

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
