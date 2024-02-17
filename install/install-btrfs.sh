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

# fetch neovim

sudo nix-shell -p neovim

# Partition the disk

printf "label: gpt\n,550M,U\n,,L\n" | sudo sfdisk /dev/$disk

# Format partitions and create subvolumes

sudo nix-shell -p btrfs-progs
sudo mkfs.fat -F 32 /dev/${disk_sub}1

# Encrypt btrfs partion

sudo cryptsetup -v luksFormat /dev/${disk_sub}2 
sudo cryptsetup open /dev/${disk_sub}2 enc

sudo mkfs.btrfs -f /dev/mapper/enc
sudo mkdir -p /mnt
sudo mount /dev/mapper/enc /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/swap
sudo umount /mnt

# Mount the partitions and subvolumes

sudo mount -o compress=zstd,subvol=root /dev/mapper/enc /mnt
sudo mkdir /mnt/{home,nix}
sudo mount -o compress=zstd,subvol=home /dev/mapper/enc /mnt/home
sudo mount -o compress=zstd,noatime,subvol=nix /dev/mapper/enc /mnt/nix
sudo mkdir /swap
sudo mount -o subvol=swap /dev/mapper/enc /swap
sudo btrfs filesystem mkswapfile --size 36g --uuid clear /swap/swapfile

sudo mkdir /mnt/boot
sudo mount /dev/${disk_sub}1 /mnt/boot

# make a keyfile

sudo dd if=/dev/urandom of=./keyfile.bin bs=1024 count=4
sudo cryptsetup luksAddKey /dev/mapper/enc ./keyfile.bin
# sudo echo ./keyfile.bin | cpio -o -H newc -R +0:+0 --reproducible | gzip -9 > /mnt/boot/initrd.keys.gz
sudo mkdir -p /mnt/etc/secrets/initrd
sudo mv ./keyfile.bin /mnt/etc/secrets/initrd/
sudo rm ./keyfile.bin

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

and make a swap fileSystems
and add

swapDevices = [ { device = "/swap/swapfile"; } ];
"
echo "
after install with 
nixos-install
"
