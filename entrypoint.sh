#!/bin/bash
set -e
cd /build

pacman-key --init
pacman -Syu --noconfirm --needed sudo erofs-utils dosfstools mtools arch-install-scripts git wget curl
useradd builduser -m
chown -R builduser:builduser /build
passwd -d builduser
printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

sudo -u builduser bash -c 'cd /build && sudo ./archiso/mkarchiso -v configs/x13s'||status=$?
if [ $status -ne 0 ]; then
    echo "Build failed"
    exit 1
fi
# Test Local Cache
