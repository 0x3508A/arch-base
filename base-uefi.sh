#!/bin/bash

# For Btrfs
# pacman -S btrfs-progs

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
export HOSTNAME='arch'
echo "${HOSTNAME}" >> /etc/hostname
{
	echo "127.0.0.1 localhost";
	echo "::1       localhost";
	echo "127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}";
}>> /etc/hosts
echo root:password | chpasswd

# Packages in Stages

pacman -S grub efibootmgr mtools dosfstools os-prober \
	sof-firmware nano nano-syntax-highlighting \
	man-db man-pages texinfo \
	networkmanager network-manager-applet dialog ufw \
	openssh rsync reflector cups bluez bluez-utils avahi \
	inetutils dnsutils nfs-utils nss-mdns\
	base-devel linux-headers ntfs-3g exfatprogs \
	acpi acpid acpi_call tlp hddtemp smartmontools \
	xdg-user-dirs xdg-utils gvfs gvfs-smb \
	inxi terminus-font bash-completion \
	alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack \
	flatpak

# For Btrfs
# pacman -S grub-btrfs

# Packages for Virtual Machines
# pacman -S --needed virt-manager qemu qemu-arch-extra edk2-ovmf \
#	bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset

# pacman -S --noconfirm xf86-video-intel
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# For Windows change the efi-directory to 
# /boot/efi is you mounted the EFI partition at /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 

# For Windows change the /etc/default/grub file and uncomment the line
# GRUB_DISABLE_OS_PROBER=false
# Then generate the config again by the below command.
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
# systemctl enable reflector.timer # This is needed only if you want to update mirror list
systemctl enable fstrim.timer # Enable if you have a SSD
# systemctl enable libvirtd # Only if you need Virtual Machines
# systemctl enable ufw
systemctl enable acpid

useradd -m user
echo user:password | chpasswd
usermod -aG wheel,audio,power,rfkill,video,storage,uucp,lock,lp user
# usermod -aG libvirt user # Only if you need Virtual Machines

echo "user ALL=(ALL) ALL" >> /etc/sudoers.d/user
chmod 440 /etc/sudoers.d/user

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
