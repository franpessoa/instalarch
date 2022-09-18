#/bin/bash

echo "Installing Arch in:"
for n in 10 9 8 7 6 5 4 3 2 1
do
	echo "--------- $n"
	sleep 1s
done

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
arch-chroot /mnt
systemctl enable --now NetworkManager

echo "Setting timezone"
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
timedatectl set-ntp true
timedatectl set-timezone America/Sao_Paulo
locale-gen
echo LANG=en_US.UTF-8 | tee /etc/locale.conf
echo KEYMAP=br-abnt2 | tee /etc/vconsole.conf

echo "Network configuration"
sleep 2s
echo fran-lg | tee /etc/hostname
echo -ne "
127.0.0.1	localhost
::1	localhost
127.0.1.1	fran-lg
" > /etc/hosts


getent hosts
sleep 2s

echo "Generating initramfs"
sleep 2s
mkinitcpio -P

echo "Setting root password: please fill"
passwd

echo "Installing bootloader"
echo 3s
pacman -S grub efibootmgr --needed --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="Arch Linux / GRUB"
