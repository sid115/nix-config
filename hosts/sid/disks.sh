#!/usr/bin/env bash

SSD='/dev/sda'
MNT='/mnt'
SWAP_GB=4

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
sgdisk -n1:1M:+1G         -t1:EF00 -c1:EFI $SSD
sgdisk -n2:0:+"$SWAP_GB"G -t2:8200 -c2:SWAP $SSD
sgdisk -n3:0:0            -t3:8304 -c3:ROOT $SSD
partprobe -s $SSD
udevadm settle

wait_for_device "${SSD}1"
wait_for_device "${SSD}2"
wait_for_device "${SSD}3"

echo "Formatting partitions..."
mkfs.vfat -F 32 -n EFI "${SSD}1"
mkswap -L SWAP "${SSD}2"
mkfs.ext4 -L ROOT "${SSD}3"

echo "Mounting partitions..."
mount -o X-mount.mkdir "${SSD}3" "$MNT"
mkdir -p "$MNT/boot"
mount -t vfat -o fmask=0077,dmask=0077,iocharset=iso8859-1 "${SSD}1" "$MNT/boot"

echo "Enabling swap..."
swapon "${SSD}2"

echo "Partitioning and setup complete:"
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
