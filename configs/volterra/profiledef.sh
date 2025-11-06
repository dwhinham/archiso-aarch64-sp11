#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="archlinux-volterra"
iso_label="ARCH_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Alex Robinson <alex@ironrobin.net>"
iso_application="ARM64 Arch Linux Live/Rescue Disk for Windows Dev Kit 2023"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('uefi.systemd-boot')
arch='aarch64'
dtb='sc8280xp-microsoft-blackrock.dtb'
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
#airootfs_image_tool_options=('-zlz4hc,12')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/root/.ssh"]="0:0:0700"
  ["/root/.ssh/authorized_keys"]="0:0:0600"
  ["/usr/local/bin/ironrobin-setup"]="0:0:755"
)
