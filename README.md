# Arch Linux AArch64 for Surface Pro 11

This repository aims to provide a working Arch Linux distribution for the ARM-based Microsoft Surface Pro 11 (Snapdragon X1E/X1P).

It was formerly based on *Arch Linux ARM* (now in the `archive/alarm` branch). This has now been dropped in favour of the [Arch Linux Ports AArch64 project](https://ports.archlinux.page/aarch64/) which, whilst still "unofficial" today, is working towards official port status and can be considered more "official" than Arch Linux ARM.

This was the original Arch Linux image for the Surface Pro 11, in development since early 2025. **The goal of this project is upstream Linux support**: fixes are submitted to the kernel and reviewed by maintainers on the [LKML](https://lore.kernel.org/lkml/?q=whinham) as they become ready, and the intention is for everything here to go upstream eventually, so that support for the machine is built into Linux itself and every distro benefits. Contributors here were instrumental in getting a Surface Pro 11 devicetree into the mainline kernel, and this repo is meant to shrink as more of its patches land.

Many "Surface Pro 11" images that appeared later are little more than an ISO wrapped in AI-generated code, docs and tooling, often built on this project's and other developers' work without credit, and none of it has gone upstream. Work that never reaches upstream has to be reinvented by every distro, however many commits it spans.

This project is not affiliated with other Surface Pro 11 images; please don't use our issue tracker to promote or seek support for them.

## What's working

| **Feature**               | **Working?** | **Notes**                                                                                                                                                  |
|---------------------------|:------------:|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| NVMe                      |       ✅      |                                                                                                                                                            |
| Graphics                  |       ✅      | Requires firmware to be installed, see below.                                                                                                              |
| Backlight                 |   Partially  | OLED backlight control working, LCD control needs enabling; no LCD model available for testing; no volunteers have stepped forward.                         |
| USB3                      |   Partially  | USB-C ports are working, but Surface Dock connector is presumably not.                                                                                      |
| USB4/Thunderbolt          |       ❌      | No external display output when using [official USB4 dock](https://learn.microsoft.com/en-us/surface/surface-usb4-dock). This is a limitation for all X1 machines; work ongoing upstream[^7]. |
| USB-C display output      |       ✅      | Working as of 6.15-rc6 (for DP alt mode).                                                                                                                  |
| Wi-Fi                     |       ✅      | Working with a kernel hack to disable rfkill[^2]. MAC address will be random unless you use [sp11-mac-fixup] to set it.                                    |
| Bluetooth                 |       ✅      | Requires some `udev` rules to set up a valid MAC address. [sp11-mac-fixup] takes care of this.                                                             |
| 5G modem                  |       ❌       | No 5G model available for testing; no volunteers have stepped forward.                                                                                     | 
| Audio                     |       ✅      | Speakers working but intentionally limited in volume to avoid damage (as with all X1E machines) because hardware speaker protection is not implemented yet. Microphone is working. |
| Touchscreen/Pen           |       ✅      | Working thanks to the work of Jingyuan Liang[^8], @scuggo[^5] and @orvitpng[^6]. Requires [iptsd].                                                         |
| Flex Keyboard             |       ✅      | Only when attached to the Surface Pro; not sure about Bluetooth yet.                                                                                       |
| Suspend/resume            |       ✅      | Seems to be working reliably but needs more testing.                                                                                                       |
| Cameras (and status LEDs) |       ❌       | Not investigated yet; some support may come with Bryan O'Donoghue's patch series[^9].                                                                      |

## Boot instructions

0. Disable secure boot.
1. Download the latest pre-built image.
2. Flash to a USB `dd bs=4M if=archlinux-sp11-YYYY.MM.DD-aarch64.iso of=<DEV-TARGET> conv=fsync oflag=direct status=progress`. Don't use Ventoy.
3. Reboot the laptop; hold down Volume Up as the machine reboots to get to the EFI menu.
5. Tap "Boot configuration" and swipe left on "USB Storage" to boot it immediately.
6. **WAIT PATIENTLY** approx. 2-3 minutes for boot to complete - **black screen is normal** while things decompress, **JUST LEAVE IT ALONE**.

## Installation

The instructions in the [Installation guide] mostly apply, but here are some notes specific to this machine:

- If you want to dual-boot, you need to shrink your Windows partition - it's probably safer to do this from within Windows itself.
- Launch `archinstall --config /root/sp11.json`. This preset ensures our essential custom package repo and its packages will be included.
- Ensure the ESP partition is assigned the mountpoint `/boot`; this will be a small FAT32 partition.
- Create a root partition and assign it the mountpoint `/`. It may be easiest to go with `ext4` to start with.
- Customise locale, authentication, etc., but **DO NOT** touch bootloader config, package repos, packages or custom commands. It's recommended to leave network settings alone (it's set to install NetworkManager).
- The UKI option in archinstall is not currently supported; **leave it disabled**. We use a custom method to work around this; you'll end up with `systemd-boot` as the bootloader and UKI kernels being installed to your EFI partition, one for each Surface variant.
- If you enable encryption, you will need to add some modules to your mkinitcpio.conf file. See https://codeberg.org/ironrobin/archiso-aarch64/wiki/Feature-Support#full-disk-encryption.

## Post-install fixups

- After getting yourself online (you can use `nmtui`), run `sudo sp11-grab-fw` to download and install proprietary firmware that is not redistributed here. This gets your GPU and other hardware working. Reboot after installing.
- Edit `/etc/sp11-mac.conf` and set your Bluetooth and Wi-Fi MAC addresses. You can [get them from Windows](https://wiki.debian.org/InstallingDebianOn/Thinkpad/X13s#Note_Wi-Fi_and_Bluetooth_mac_addresses).
 
## Kernel

The kernel repository is located at https://github.com/dwhinham/linux-sp11.
The aim is to try to keep it up to date with the latest Arch kernel, with a patch queue on top.

Some patches may be going through the upstreaming process already; [check the LKML](https://lore.kernel.org/lkml/?q=whinham).

## Package repository

- https://github.com/dwhinham/archlinux-repo/releases

## What's changed since ALARM?

- A proper Arch Linux Ports ISO spun with `archiso` that should boot reliably; not a hacked-together disk image based on Arch Linux ARM.
- SAM fixes addressing tablet mode detection (dead keyboard on resume from suspend), power profile/fan support; patches applied upstream.
- Suspend/resume should be more reliable now.
- Volume buttons implemented; patch applied upstream.
- Mic distortion fixed; patch applied upstream.
- HDMI/DP audio output; patch applied upstream.
- AudioReach topology [merged upstream](https://github.com/linux-msm/audioreach-topology/pull/76); needs time to trickle down to new `linux-firmware` release; for now we provide [sp11-audioreach-topology].
- ALSA UCM profiles [in review upstream](https://github.com/alsa-project/alsa-ucm-conf/pull/847); for now we provide [alsa-ucm-conf-sp11].
- Iris hardware video decoder/encoder enabled; patch in review upsteam.

## Why fork [archiso-aarch64](https://codeberg.org/ironrobin/archiso-aarch64)?

@ironrobin has done the hard work of creating a generic AArch64 ISO builder that boots on several ARM laptops, and it **does** boot on Surface Pro 11 (Denali)[^1].

However, the Surface Pro 11 is an awkward machine with some issues that still need to be solved with a combination of kernel patches and userspace workarounds before it's usable:

- Wi-Fi rfkill needs to be forced off with a hack[^2].
- Wi-Fi needs repackaged firmware (extract similar board definition from `board-2.bin` and force it to be loaded)[^3].
- Touchscreen and pen support needs HID-over-SPI support[^4] to be merged along with QSPI protocol stuff[^5][^6].

If solutions for all of these eventually land upstream, this repository can be retired.

## Support us

Tips appreciated but never expected:

@dwhinham [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/d0pefish)

@ironrobin [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/V3P324EPK2)

[^1]: https://codeberg.org/ironrobin/archiso-aarch64
[^2]: https://lore.kernel.org/lkml/20251220-surface-sp11-for-next-v5-2-16065bef8ef3@gmail.com/
[^3]: https://bugzilla.kernel.org/show_bug.cgi?id=222036
[^4]: https://lore.kernel.org/lkml/20260609-send-upstream-v4-0-b843d5e6ced3@chromium.org/
[^5]: https://git.scug.io/nikkuss/x1e-nixos
[^6]: https://github.com/orvitpng/nix1e
[^7]: https://lore.kernel.org/lkml/20260908-topic-usb4phy-v5-0-73aac69578ef@oss.qualcomm.com/
[^8]: https://lore.kernel.org/lkml/20260609-send-upstream-v4-0-b843d5e6ced3@chromium.org/
[^9]: https://lore.kernel.org/lkml/20260917-x1e-camss-csi2-phy-dtsi-v7-0-1a63eb35838b@linaro.org/

[installation guide]: https://wiki.archlinux.org/title/Installation_guide
[iptsd]: https://github.com/linux-surface/iptsd
[sp11-mac-fixup]: https://github.com/dwhinham/archlinux-repo/tree/main/sp11-mac-fixup
[sp11-audioreach-tppology]: https://github.com/dwhinham/archlinux-repo/tree/main/sp11-audioreach-topology
[alsa-ucm-conf-sp11]: https://github.com/dwhinham/archlinux-repo/tree/main/alsa-ucm-conf-sp11
