---
name: Fingerprint submission
about: If you want to submit a device fingerprint, please follow this procedure.
title: ''
labels: ''
assignees: ''

---

When submitting a device fingerprint for inclusion in the module list, please provide the device name and the values from the following props:
- ro.build.fingerprint (but preferably all of the fingerprint props available on your device, since they don't always match)
- ro.build.version.security_patch
- ro.product.manufacturer
- ro.product.model

A simple way of getting all the required information is to use [ipdev's](https://github.com/ipdev99) great props extraction tool: https://github.com/ipdev99/mHideGP
