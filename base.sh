#!/bin/bash

set -e
set +x

# Script Vars
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo " -- Copying $SCRIPT_DIR/etc to actual /etc"
echo
cp -rT "$SCRIPT_DIR/etc" /etc/


echo " -- Seting Up Time"
echo
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock -l --systohc # For RTC as local
# hwclock --systohc # Normal Config

echo " -- Seting up Locale"
echo
sed -i "/en_US.UTF-8/s/^#//g" /etc/locale.gen
locale-gen

echo " -- Setting up network"
echo
export HOSTNAME='arch'
echo "${HOSTNAME}" >> /etc/hostname
{
	echo "127.0.0.1 localhost";
	echo "::1       localhost";
	echo "127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}";
}>> /etc/hosts

echo " -- Setting Root Password"
echo
passwd root

echo " -- Installing basic packages"
echo
pacman -Syy
echo
pacman -S grub efibootmgr dosfstools mtools os-prober \
	networkmanager ufw dialog network-manager-applet \
	openssh rsync reflector cups bluez bluez-utils \
	base-devel linux-headers ntfs-3g acpi acpid acpi_call tlp \
	gvfs nfs-utils inetutils inxi dnsutils nss-mdns \
	terminus-font man-db man-pages texinfo 

# echo " -- Installing extra Packages for btrfs"
# echo
# pacman -S btrfs-progs grub-btrfs

echo " -- Applying GRUB config Modifications"
echo
# Enable os-prober to detect Windows and other OS
sed -i "/GRUB_DIABLE_OS_PROBER/s/^#//g" /etc/default/grub
# # Enable Save default/grub
# sed -i "/GRUB_SAVEDEFAULT/s/^#//g" /etc/default/grub
# Hide Grub Menu - This can be enabled by pressing ESC at boot
sed -i "/GRUB_TIMEOUT_STYLE/s/menu/hidden/g" /etc/default/grub

echo " -- Installing GRUB"
echo
# Normal Grub Install Command
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
## For Windows change the efi-directory to
## /boot/efi is you mounted the EFI partition at /boot/efi
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

# Generate GRUB Config
grub-mkconfig -o /boot/grub/grub.cfg

echo " -- Enabling Services"
echo
systemctl enable NetworkManager
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable acpid
systemctl enable sshd
systemctl enable cups.service
systemctl enable fstrim.timer # Enable if you have a SSD
systemctl enable bluetooth
systemctl enable avahi-daemon

printf "\e[1;32mDone! Type exit, umount -R /mnt and poweroff.\e[0m\n"
