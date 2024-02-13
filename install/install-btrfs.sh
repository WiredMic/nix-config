#!/bin/sh
# disk="USER INPUT"
read -p "Enter Install Disk: " disk

echo $disk | grep "nvme" && disk_type="nvme" && disk_part="p"

echo $disk | grep "sd" && disk_type="sd" && disk_part=""

disk_sub=$disk$disk_part

if [ -z ${disk_type+x} ]; then 
  echo "This is not a know drive";
  exit 1;
else 
  echo "This drive is a $disk_type type"; 
fi

# Ask for confirmation
read -p "Install Btrfs on the drive $drive (yY/nN): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1


# --------------------------------------------------------
# install btrfs on the disk 
# https://nixos.wiki/wiki/Btrfs
# -------------------------------------------------------

# Partition the disk

printf "label: gpt\n,550M,U\n,,L\n" | sudo sfdisk /dev/$disk

# Format partitions and create subvolumes

sudp nix-shell -p btrfs-progs
sudo mkfs.fat -F 32 /dev/${disk_sub}1

# Encrypt btrfs partion

sudo cryptsetup --verify-passphrase -v luksFormat ${disk_sub}2 
sudo cryptsetup open ${disk_sub}2 enc

sudo mkfs.btrfs -f /dev/${disk_sub}2
sudo mkdir -p /mnt
sudo mount /dev/${disk_sub}2 /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudp btrfs subvolume create /mnt/nix
sudo umount /mnt

# Mount the partitions and subvolumes

sudo mount -o compress=zstd,subvol=root /dev/${disk_sub}2 /mnt
sudo mkdir /mnt/{home,nix}
sudo mount -o compress=zstd,subvol=home /dev/${disk_sub}2 /mnt/home
sudo mount -o compress=zstd,noatime,subvol=nix /dev/${disk_sub}2 /mnt/nix
sudo 
sudo mkdir /mnt/boot
sudo mount /dev/${disk_sub}1 /mnt/boot

# Install NixOS

sudo nixos-generate-config --root /mnt
sudo cp ./configuration.nix /mnt/etc/nixos/

echo "
edit /mnt/etc/nixos/hardware-configuration.nix to add compressing

fileSystems = {
  "/".options = [ "compress=zstd" ];
  "/home".options = [ "compress=zstd" ];
  "/nix".options = [ "compress=zstd" "noatime" ];
  "/swap".options = [ "noatime" ];
};

"
echo "
after install with 
nixos-install
"
