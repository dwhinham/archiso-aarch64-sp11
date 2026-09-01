# archiso for AArch64 laptops

This repository contains a customized archiso config for building images for ARM64 laptops. Pre-built images are available in [Releases](https://codeberg.org/ironrobin/archiso-x13s/releases).

It uses upstream releng plus a thin layer with stubble to support everything that stubble does.
Here's a list of currently supported devices (although most are not tested):

- msm8998-lenovo-miix-630-81f1.json
- sc7180-acer-aspire1.json
- sc8180x-lenovo-flex-5g-81xe.json
- sc8180x-lenovo-flex-5g-82ak.json
- sc8280xp-huawei-gaokun3.json
- sc8280xp-lenovo-thinkpad-x13s-21bx.json
- sc8280xp-lenovo-thinkpad-x13s-21by.json
- sc8280xp-lenovo-thinkpad-x13s-4810.json
- sc8280xp-microsoft-blackrock.json
- sc8280xp-microsoft-surface-pro-9-5G.json
- sdm850-lenovo-yoga-c630.json
- x1e001de-devkit.json
- x1e78100-acer-sfa14-11.json
- x1e78100-lenovo-thinkpad-t14s.json
- x1e78100-lenovo-thinkpad-t14s-lcd.json
- x1e78100-lenovo-thinkpad-t14s-oled.json*
- x1e78100-medion-sprchrgd-14s1-elite.json
- x1e80100-asus-vivobook-s15.json
- x1e80100-asus-zenbook-a14.json
- x1e80100-asus-zenbook-a14-oled.json
- x1e80100-crd.json
- x1e80100-dell-inspiron-14-plus-7441.json
- x1e80100-dell-latitude-7455.json
- x1e80100-dell-xps13-9345.json
- x1e80100-hp-elitebook-ultra-g1q.json
- x1e80100-hp-omnibook-x14.json
- x1e80100-lenovo-yoga-slim7x.json
- x1e80100-microsoft-denali.json
- x1e80100-microsoft-romulus13.json
- x1e80100-microsoft-romulus15.json
- x1p42100-acer-swift-go14-01.json
- x1p42100-asus-vivobook-s15.json
- x1p42100-asus-zenbook-a14.json
- x1p42100-hp-omnibook-x14.json
- x1p42100-lenovo-ideapad-5-2in1.json
- x1p42100-lenovo-ideapad-slim-5-oled.json
- x1p42100-lenovo-thinkbook-16.json
- x1p42100-microsoft-surface-pro-12in.json
- x1p64100-acer-swift-sf14-11.json

*needs special boot parameters to boot.

aarch64 specific packages can be found [here](https://codeberg.org/ironrobin/aarch64/releases/tag/packages).

## Boot instructions
0. Disable secure boot
1. Download the latest Pre-built image
2. Flash to a USB `dd bs=4M if=archlinux-YYYY.MM.DD-aarch64.iso of=<DEV-TARGET> conv=fsync oflag=direct status=progress`
3. Reboot the laptop
4. Select the USB to boot (e.g., for Lenovo, press F12 when the logo appears)

## Installation
The instructions in the [Installation_guide](https://wiki.archlinux.org/title/Installation_guide) mostly apply
However there are some limitations with the current archinstall.

 * UKI is not currently supported; make sure it's disabled
 * If you enable encryption, you will need to add some modules to your mkinitcpio.conf file. See https://codeberg.org/ironrobin/archiso-x13s/wiki/Feature-Support#full-disk-encryption

Tips appreciated but never expected:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/V3P324EPK2)
