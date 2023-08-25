#!/usr/bin/env bash

sudo timedatectl set-ntp true
sudo timedatectl set-localrtc 1
sudo hwclock --systohc
timedatectl status

echo "Press Enter to continue"
read -r

sudo ufw enable
sudo ufw limit 22
sudo systemctl enable --now ufw

git clone https://aur.archlinux.org/pikaur.git
cd pikaur/
makepkg -si --noconfirm

# pikaur -S --noconfirm auto-cpufreq
# sudo systemctl enable --now auto-cpufreq

sudo pacman -S xorg lxdm xfce4 \
	xfce4-goodies gedit gedit-plugins rhythmbox firefox pavucontrol \
	simplescreenrecorder arc-gtk-theme arc-icon-theme obs-studio vlc \
	veracrypt keepassxc gparted bleachbit gnome-disk-utility mpv \
	baobab evince cheese simple-scan seahorse pdfarranger img2pdf \
	restic tree tmux arch-audit gnome-keyring paperkey \
	patch yubikey-personalization-gui grsync ifuse speedcrunch \
	usbview zbar catfish htop print-manager usbutils \
	vim-airline vim-spell-en binutils emacs exa bat gitg stow \
	screen meld ctags make cmake diffutils entr shellcheck \
	sqlitebrowser xclip go python-pyserial python-pygments \
	python-pip python-virtualenv the_silver_searcher \
	tk upx flameshot screenkey ffmpeg unicode-emoji \
	yi-dlp wget telegram-desktop signal-desktop \
	jq gping curlie xh nmap remmina httrack system-config-printer \


sudo systemctl enable lxdm
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
sudo reboot

