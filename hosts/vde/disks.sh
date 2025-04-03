#!/usr/bin/env bash

SSD='/dev/disk/by-id/wwn-0x500a0751e280a38c'
MNT='/mnt'

# Helper function to wait for devices
wait_for_device() {
  local device=$1
  echo "Waiting for device: $device ..."
  while [[ ! -e $device ]]; do
    sleep 1
  done
  echo "Device $device is ready."
}

if ! command -v sgdisk &> /dev/null; then
  nix-env -iA nixos.gptfdisk
fi

swapoff --all
udevadm settle

wait_for_device $SSD

echo "Wiping filesystem on $SSD..."
wipefs -a $SSD

echo "Clearing partition table on $SSD..."
sgdisk --zap-all $SSD

echo "Partitioning $SSD..."
sgdisk -n1:1M:+1G -t1:EF00 -c1:BOOT $SSD
sgdisk -n2:0:0    -t2:8304 -c2:ROOT $SSD
partprobe -s $SSD
udevadm settle

wait_for_device ${SSD}-part1
wait_for_device ${SSD}-part2

echo "Formatting partitions..."
mkfs.vfat -F 32 -n BOOT "${SSD}-part1"
mkfs.ext4 -L ROOT "${SSD}-part2"

echo "Mounting partitions..."
mount -o X-mount.mkdir "${SSD}-part2" "$MNT"
mkdir -p "$MNT/boot"
mount -t vfat -o fmask=0077,dmask=0077,iocharset=iso8859-1 "${SSD}-part1" "$MNT/boot"

echo "Partitioning and setup complete:"
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
