#!/usr/bin/env bash

SSD='/dev/disk/by-id/nvme-TEAM_TM8FPD001T_TPBF2503240010201457'
MNT='/mnt'
SWAP_GB=16

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
sgdisk -n5:0:+"$SWAP_GB"G -t5:8200 -c5:SWAP $SSD
sgdisk -n6:0:0            -t6:8304 -c6:ROOT $SSD
partprobe -s $SSD
udevadm settle

wait_for_device ${SSD}-part1 # Windows ESP
wait_for_device ${SSD}-part5
wait_for_device ${SSD}-part6

echo "Formatting partitions..."
mkswap -L SWAP "${SSD}-part5"
mkfs.ext4 -L ROOT "${SSD}-part6"

echo "Mounting partitions..."
mount -o X-mount.mkdir "${SSD}-part6" "$MNT"
mkdir -p "$MNT/boot"
mount "${SSD}-part1" "$MNT/boot"

echo "Enabling swap..."
swapon "${SSD}-part5"

echo "Partitioning and setup complete:"
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
