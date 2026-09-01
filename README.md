# archiso for AArch64 laptops

This repository contains a customized archiso config for building images for ARM64 laptops. Pre-built images are available in [Releases](https://codeberg.org/ironrobin/archiso-x13s/releases).

It builds on Arch Linux's upstream releng profile with a thin compatibility layer powered by stubble, allowing a single image to boot across supported AArch64 laptops.

### Supported devices

🟢 Known to boot
⚪ Untested

- ⚪Acer Aspire 1
- ⚪Acer Swift 14 AI (SF14-11)
- ⚪Acer Swift Go 14 AI (SFG14-01)
- ⚪ASUS Vivobook S 15
- ⚪ASUS Zenbook A14
- 🟢ASUS Zenbook A14 OLED
- ⚪Dell Inspiron 14 Plus 7441
- ⚪Dell Latitude 7455
- ⚪Dell XPS 13 9345
- ⚪HP EliteBook Ultra G1q
- 🟢HP OmniBook X 14
- ⚪Huawei Gaokun 3
- ⚪Lenovo Flex 5G (81XE)
- ⚪Lenovo Flex 5G (82AK)
- 🟢Lenovo IdeaPad 5 2-in-1
- ⚪Lenovo IdeaPad Slim 5 OLED
- ⚪Lenovo Miix 630 (81F1)
- ⚪Lenovo ThinkBook 16
- ⚪Lenovo ThinkPad T14s
- ⚪Lenovo ThinkPad T14s LCD
- 🟢Lenovo ThinkPad T14s OLED*
- 🟢Lenovo ThinkPad X13s (21BX)
- 🟢Lenovo ThinkPad X13s (21BY)
- 🟢Lenovo ThinkPad X13s (4810)
- ⚪Lenovo Yoga C630
- ⚪Lenovo Yoga Slim 7x
- ⚪Medion SPRCHRGD 14 S1 Elite
- ⚪Microsoft Surface Pro 9 5G
- ⚪Microsoft Surface Pro 12-inch
- 🟢Microsoft Windows Dev Kit 2023 (Project Volterra)
- ⚪Microsoft Denali
- ⚪Microsoft Romulus 13
- ⚪Microsoft Romulus 15
- ⚪Qualcomm X1E001DE Development Kit
- ⚪Qualcomm X1E80100 CRD

*64 GB version needs special boot parameters to boot.

Listed devices have boot support; hardware feature support varies by device and kernel version.

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
