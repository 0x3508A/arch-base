#!/usr/bin/env bash

set -e
set +x

echo " -- Installing Remaining Packages"
echo
echo " !! Select 'wireplumber' in audio packages"
echo
sudo pacman -S alsa-utils pipewire-alsa pipewire \
    pipewire-jack pipewire-pulse sof-firmware \
    xdg-utils xdg-user-dirs

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
sudo pacman -S xorg xfce4 xfce4-goodies pavucontrol xcape lightdm \
    lightdm-gtk-greeter lightdm-gtk-greeter-settings \
    firefox keepassxc veracrypt vlc blueman \
    file-roller p7zip unzip unrar

sudo systemctl enable lightdm

printf "\e[1;32mDone! Type reboot and login using your local user.\e[0m\n"