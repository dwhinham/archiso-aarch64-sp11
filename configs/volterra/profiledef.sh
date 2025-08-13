#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="archlinuxarm-volterra"
iso_label="ARCH_AARCH64_$(date +%Y%m)"
iso_publisher="Alex R"
iso_application="ARM64 Arch Linux Live/Rescue Disk for Windows Dev Kit 2023"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('uefi-aarch64.systemd-boot.esp')
arch="aarch64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'arm' '-b' '1M' '-Xdict-size' '1M')
#airootfs_image_tool_options=('-zlz4hc,12')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.ssh"]="0:0:0700"
  ["/root/.ssh/authorized_keys"]="0:0:0600"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/usr/local/bin/ironrobin-setup"]="0:0:755"
  ["/usr/local/bin/workman"]="0:0:755"
)
