#!/bin/bash
# Build the ISO in an Arch Linux Ports aarch64 container. Result lands in out/.

set -euo pipefail

profile=configs/releng

pacman-key --init
pacman -Syu --noconfirm --needed archiso systemd-ukify

# pacstrap verifies against the container's keyring, not the one the ISO ships,
# so the profile's repo keys have to be trusted here too.
for key in "$profile"/airootfs/usr/local/share/pacman/custom-keys/*.gpg; do
	[[ -e "$key" ]] || continue
	pacman-key --add "$key"
	# Primary keys only: subkey fingerprints also appear, and fail lsign-key.
	gpg --show-keys --with-colons "$key" |
		awk -F: '/^pub:/ { p = 1; next } /^fpr:/ && p { print $10; p = 0 }' |
		while read -r fpr; do pacman-key --lsign-key "$fpr"; done
done

# The image's package cache no longer matches the databases and fails checksums.
# Not 'pacman -Scc --noconfirm': that prompt defaults to N and clears nothing.
rm -rf /var/cache/pacman/pkg/*

# Work dir outside the bind mount: root owned files in the checkout break the
# runner's post-job cleanup.
./archiso/mkarchiso -v -w /tmp/archiso-work -o /build/out "$profile"
