#!/usr/bin/env bash

set -e
set +x

echo " -- Fix Time"
echo
systemctl enable --now systemd-timesyncd
timedatectl set-ntp true
timedatectl set-local-rtc 1
echo
timedatectl status

echo " -- Initalizing the pacman Keyring"
echo
# pacman-key --init
# pacman-key --populate archlinux
# pacman -Syy

echo " -- Installing Remaining Packages"
echo
echo " !! Select 'wireplumber' in audio packages"
echo
pacman -S alsa-utils pipewire-alsa pipewire \
    pipewire-jack pipewire-pulse sof-firmware \
    xdg-utils xdg-user-dirs

echo " -- Creating User"
echo
useradd -m user
passwd user
# echo user:password | chpasswd
usermod -aG wheel,audio,power,rfkill,video,storage,uucp,lock,lp user

# In Secure Version
echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/user
# Secure Version
# echo "user ALL=(ALL) ALL" >> /etc/sudoers.d/user

chmod 440 /etc/sudoers.d/user

echo " -- Installing Graphics drivers"
echo
# # For older Intel Cards
# pacman -S xf86-video-intel
# # For Embedded Intel Cards
# pacman -S mesa vulkan-intel
# # For Latest ATI/AMD cards
# pacman -S xf86-video-amdgpu
# # Nvidia Cards
# pacman -S nvidia nvidia-utils
# # Optional Dependency
# pacman -S nvidia-settings

echo " -- Installing XFCE"
echo
pacman -S xorg xfce4 xfce4-goodies pavucontrol xcape lightdm \
    lightdm-gtk-greeter lightdm-gtk-greeter-settings \
    firefox keepassxc veracrypt vlc blueman \
    file-roller p7zip unzip unrar

systemctl enable lightdm

echo " -- Running GRUB Config one more time to fix missing OSs"
echo
grub-mkconfig -o /boot/grub/grub.cfg

echo " -- Enabling firewall"
echo 
ufw limit 22/tcp comment "SSH"
ufw allow 5353 comment "avahi"
ufw deny to 224.0.0.1 comment "Block multicast packages"
ufw default deny incoming
ufe default allow outgoing
ufw enable
systemctl enable ufw

printf "\e[1;32mDone! Type reboot and login using your local user.\e[0m\n"
