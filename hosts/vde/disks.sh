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

echo "Partitioning $SSD..."
sgdisk -n5:0:0 -t5:8304 -c5:ROOT $SSD
partprobe -s $SSD
udevadm settle

wait_for_device ${SSD}-part1 # Windows ESP
wait_for_device ${SSD}-part5

echo "Formatting partitions..."
mkfs.ext4 -L ROOT "${SSD}-part5"

echo "Mounting partitions..."
mount -o X-mount.mkdir "${SSD}-part5" "$MNT"
mkdir -p "$MNT/boot"
mount "${SSD}-part1" "$MNT/boot"

echo "Partitioning and setup complete:"
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
