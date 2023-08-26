#!/usr/bin/env bash

echo
sudo timedatectl set-ntp true
sudo timedatectl set-local-rtc 1
sudo hwclock --systohc
timedatectl status

echo "Press Enter to continue"
read -r
echo

echo
echo "Enabling Firewall - Press Enter to continue..."
read -r
echo

sudo ufw enable
sudo ufw limit 22
sudo systemctl enable --now ufw

echo
echo "Installing yay - Press Enter to continue..."
read -r
echo

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm
cd ..
rm -rf yay/

echo
echo "Special For pipewire -"
echo "  - Choose 'pipipewire-jack'"
echo "  - Choose 'wireplumber'"
echo
echo "Begin installing XFCE - Press Enter to continue..."
read -r
echo

# pikaur -S --noconfirm auto-cpufreq
# sudo systemctl enable --now auto-cpufreq

sudo pacman -S --noconfirm xf86-video-intel
# sudo pacman -S --noconfirm xf86-video-amdgpu
# sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

sudo pacman -S xorg lxdm xfce4 xfce4-goodies \
	gedit gedit-plugins rhythmbox firefox pavucontrol \
	arc-gtk-theme arc-icon-theme obs-studio vlc mpv viewnior \
	veracrypt keepassxc gparted bleachbit gnome-disk-utility \
	evince gnome-keyring seahorse arch-audit paperkey blueman \
	sof-firmware alsa-utils  wireplumber \
	pipewire pipewire-alsa pipewire-pulse pipewire-jack \
	xdg-user-dirs xdg-utils \
	gvfs gvfs-smb gvfs-afc gvfs-mtp gvfs-nfs gvfs-google gvfs-gphoto2 \
	webp-pixbuf-loader ffmpegthumbnailer	

sudo systemctl enable lxdm

# Update User directories
sudo xdg-user-dirs-update
xdg-user-dirs-update

# Fix and Unlock control of Wireless
sudo rfkill unblock wlan
sudo rfkill unblock bluetooth

echo
echo "Begin Applications Install - Press Enter to continue..."
read -r
echo

sudo pacman -S baobab cheese simple-scan pdfarranger img2pdf \
	restic tree tmux print-manager system-config-printer \
	patch yubikey-personalization-gui grsync ifuse speedcrunch \
	usbview zbar catfish htop usbutils neofetch \
	vim-airline vim-spell-en binutils emacs exa bat gitg stow \
	screen meld ctags make cmake diffutils entr shellcheck \
	sqlitebrowser xclip go python-pyserial python-pygments \
	python-pip python-virtualenv the_silver_searcher \
	tk upx flameshot screenkey ffmpeg unicode-emoji \
	yt-dlp wget telegram-desktop signal-desktop \
	jq gping curlie xh nmap remmina httrack vim-airline vim-spell-en \
	kdiff3 filezilla libreoffice-still pdftricks cherrytree \
	imagemagick aspell aspell-en hyphen hyphen-en mythes-en \
	hunspell-en_US languagetool libmythes \
	ttf-liberation ttf-bitstream-vera adobe-source-sans-pro-fonts \
	ttf-droid ttf-dejavu ttf-ubuntu-font-family ttf-anonymous-pro \
	jre8-openjdk \
	gimp inkscape audacity openscad freecad xchm vidcutter \
	pandoc-cli texlive-bin texlive-core texlive-pictures \
	unicode-emoji unrar p7zip unzip f3d flac jasper 

echo
echo "Begin Hardware Tools Install - Press Enter to continue..."
read -r
echo

sudo pacman -S openocd avr-binutils avr-gcc avr-libc avrdude arduino \
	kicad kicad-library kicad-library-3d \
	moserial lrzsz stlink picocom android-tools android-udev \
	sdcc pulseview \
	arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-gdb \
	arm-none-eabi-newlib

echo
echo "Begin Install AUR Packages - Press Enter to continue..."
read -r
echo

yay -S --noconfirm zramd
sudo systemctl enable zramd

echo

yay -S --noconfirm gforth simplescreenrecorder caffeine-ng \
	thonny nodemcu-pyflasher brave-bin

echo
echo "Installation Done - Press Enter to Reboot..."
read -r
echo

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m\n"
sleep 5
sudo reboot

