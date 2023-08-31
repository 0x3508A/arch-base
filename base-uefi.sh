#!/bin/bash

set -e
set +x

# Script Vars
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

NEED='false'
if [ ! -e /etc/hostname ]; then
NEED='true'
fi

if [ "$NEED" == "true" ]; then

echo "Copying $SCRIPT_DIR/etc to actual /etc"
echo
cp -rT "$SCRIPT_DIR/etc" /etc/

# # Speed up pacman and Add Colors
# sed -i "/Color/s/^#//g" /etc/pacman.conf
# sed -i "/ParallelDownloads/s/^#//g" /etc/pacman.conf

# Begin Common Block
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
sed -i "/en_US.UTF-8/s/^#//g" /etc/locale.gen
locale-gen
# echo "LANG=en_US.UTF-8" >> /etc/locale.conf
# echo "KEYMAP=us" >> /etc/vconsole.conf
export HOSTNAME='arch'
echo "${HOSTNAME}" >> /etc/hostname
{
	echo "127.0.0.1 localhost";
	echo "::1       localhost";
	echo "127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}";
}>> /etc/hosts
echo root:password | chpasswd

fi

# Update Pacman
pacman-key --init
pacman-key --populate archlinux
pacman -Syy



# Packages in Stages
pacman -S grub efibootmgr mtools dosfstools os-prober \
	nano nano-syntax-highlighting \
	man-db man-pages texinfo \
	networkmanager network-manager-applet dialog ufw \
	openssh rsync reflector cups bluez bluez-utils avahi \
	inetutils dnsutils nfs-utils nss-mdns \
	base-devel linux-headers ntfs-3g exfatprogs \
	acpi acpid acpi_call tlp hddtemp smartmontools \
	inxi terminus-font bash-completion \
	pacman-contrib

# # For Btrfs
# pacman -S --noconfirm btrfs-progs grub-btrfs

# Enable os-prober to detect Windows and other OS
sed -i "/GRUB_DIABLE_OS_PROBER/s/^#//g" /etc/default/grub
# Enable Save default/grub
sed -i "/GRUB_SAVEDEFAULT/s/^#//g" /etc/default/grub
# Hide Grub Menu - This can be enabled by pressing ESC at boot
#sed -i "/GRUB_TIMEOUT_STYLE/s/menu/hidden/g" /etc/default/grub

# Normal Grub Install Command
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# # For Windows change the efi-directory to 
# # /boot/efi is you mounted the EFI partition at /boot/efi
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB 
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable fstrim.timer # Enable if you have a SSD
systemctl enable acpid
systemctl enable paccache.timer

if [ "$NEED" == "true" ]; then

useradd -m user
echo user:password | chpasswd
usermod -aG wheel,audio,power,rfkill,video,storage,uucp,lock,lp user

echo "user ALL=(ALL) ALL" >> /etc/sudoers.d/user
chmod 440 /etc/sudoers.d/user

fi

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
