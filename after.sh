#/bin/bash
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
127.0.0.1       localhost
::1     localhost
127.0.1.1       fran-lg
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
