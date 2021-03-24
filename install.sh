#!/bin/sh

TARGET=$1
IMAGE="ArchLinuxARM-rpi-aarch64-latest.tar.gz"

# Format and partition target installation device
(echo o; echo n; echo p; echo 1; echo; echo +200M; echo t; echo c; echo n; echo p; echo 2; echo; echo; echo w) | fdisk ${TARGET}

# Format partions
mkfs.vfat ${TARGET}1
mkfs.ext4 ${TARGET}2

# Create partition mount points
mkdir boot
mkdir root

# Mount partitions
mount ${TARGET}1 boot
mount ${TARGET}2 root

# Download Arch Linux ARM image
wget http://os.archlinuxarm.org/os/${IMAGE}

# Unpack root file system
bsdtar -xpf ${IMAGE} -C root

# Flush file system buffers
sync

# Move boot files to boot partition
mv root/boot/* boot

# Unmount partitions
umount boot root

# Clean up local file system
rm -rf boot root ${IMAGE}
