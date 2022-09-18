#/bin/bash

echo "Installing Arch in:"
for n in 5 4 3 2 1
do
	echo "--------- $n"
	sleep 1s
done

echo "--------- 0 \n \n"

ip link set wlan0 up
timedatectl set-ntp true

echo "Partitioning disks"
sleep 2s
parted /dev/sda mklabel gpt
echo "criating esp partition"
parted /dev/sda mkpart "ESP" fat32 1MiB 401MiB
parted /dev/sda set 1 esp on
echo "creating swap"
parted /dev/sda mkpart "Swap" linux-swap 402MiB 5GiB
echo "creating root"
parted /dev/sda mkpart "Root" btrfs 5001MiB 100%

echo "Formating partitions"
sleep 2s
mkfs.btrfs /dev/sda3
mkswap /dev/sda2
mkfs.fat -F 32 /dev/sda1

echo "Mounting partitions"
sleep 2s
mount /dev/sda3 /mnt
mount /dev/sda1 /mnt/boot --mkdir
swapon /dev/sda2

echo "Getting mirrors"
sleep 2s
reflector --country Brazil,Worlwide --sort rate --save /etc/pacman.d/mirrorlist

echo "Installing essential packages"
sleep 2s
pacstrap /mnt linux linux-firmware base --needed --noconfirm
pacstrap /mnt base-devel networkmanager connman netctl --needed --noconfirm
pacstrap /mnt man man-db man-pages --needed --noconfirm
pacstrap /mnt iw iwd --needed --noconfirm
pacstrap /mnt curl wget vim vi nano --needed --noconfirm
pacstrap /mnt sudo libnewt --needed --noconfirm

echo "Generating fstab"
sleep 2s
genfstab -U /mnt >> /mnt/etc/fstab

echo "Chrooting"
arch-chroot /mnt /run/instalarch/after.sh
