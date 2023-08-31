#!/usr/bin/env bash

set -e
set +x

if [ ! -e /tmp/timedate.done ];then
echo
echo " -- Configuring NTP"
echo
sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo systemctl enable --now systemd-timesyncd
touch /tmp/timedate.done
echo
timedatectl status
echo
echo "   !! Done"
echo
sleep 5
fi

if [ ! -e /tmp/ufw.done ]; then
echo
echo " -- Enabling Firewall"
echo

sudo ufw enable && \
sudo ufw limit 22 && \
sudo systemctl enable --now ufw
touch /tmp/ufw.done
echo
echo "   !! Done"
echo
sleep 5
fi

echo
if [ ! -e /tmp/yay.done ]; then
echo
echo " -- Installing yay"
echo

git clone https://aur.archlinux.org/yay.git
pushd yay || exit 1
makepkg -si --noconfirm
popd || exit 2
rm -rf yay/
touch /tmp/yay.done
echo
echo "   !! Done"
echo
sleep 5
fi

if [ ! -e /tmp/xfce.done ]; then
echo
echo " -- installing XFCE"
echo

sudo pacman -S --noconfirm xf86-video-intel
# sudo pacman -S --noconfirm xf86-video-amdgpu
# sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

sudo pacman -S --noconfirm xorg xcape lxdm xfce4 xfce4-goodies \
	gnu-free-fonts \
	gedit gedit-plugins rhythmbox firefox pavucontrol \
	arc-gtk-theme arc-icon-theme obs-studio vlc mpv viewnior \
	veracrypt keepassxc gparted bleachbit gnome-disk-utility \
	evince gnome-keyring seahorse arch-audit paperkey blueman \
	pipewire pipewire-alsa pipewire-pulse pipewire-jack \
	sof-firmware alsa-utils wireplumber \
	xdg-user-dirs xdg-utils xdg-desktop-portal-gnome \
	flatpak udisks2 udiskie \
	gvfs gvfs-smb gvfs-afc gvfs-mtp gvfs-nfs gvfs-google gvfs-gphoto2 \
	webp-pixbuf-loader ffmpegthumbnailer	

sudo systemctl enable lxdm
touch /tmp/xfce.done
echo
echo "   !! Done"
echo
sleep 5
fi

if [ ! -e /tmp/userdir.done ]; then
echo
echo " -- Update User directories"
echo
sudo xdg-user-dirs-update
xdg-user-dirs-update
touch /tmp/userdir.done
echo
echo "   !! Done"
echo
sleep 2
fi

if [ ! -e /tmp/fixwireless.done ]; then
echo
echo " -- Fix and Unlock control of Wireless"
echo
sudo rfkill unblock wlan
sudo rfkill unblock bluetooth
touch /tmp/fixwireless.done
echo
echo "   !! Done"
echo
sleep 2
fi

if [ ! -e /tmp/installapps.done ]; then
echo
echo " -- Applications Install"
echo

sudo pacman -S --noconfirm \
	baobab cheese simple-scan pdfarranger img2pdf \
	restic tree tmux print-manager system-config-printer \
	patch yubikey-personalization-gui grsync ifuse speedcrunch \
	usbview zbar catfish htop usbutils neofetch beep \
	vim-airline vim-spell-en binutils emacs exa bat gitg stow \
	screen meld ctags make cmake diffutils entr shellcheck \
	sqlitebrowser xclip go python-pyserial python-pygments \
	python-pip python-virtualenv the_silver_searcher \
	tk upx flameshot screenkey ffmpeg unicode-emoji \
	yt-dlp wget telegram-desktop signal-desktop \
	jq gping curlie xh nmap remmina httrack vim-airline vim-spell-en \
	kdiff3 filezilla pdftricks cherrytree \
	imagemagick aspell aspell-en hyphen hyphen-en mythes-en \
	hunspell-en_US libmythes \
	ttf-liberation ttf-bitstream-vera adobe-source-sans-pro-fonts \
	ttf-droid ttf-dejavu ttf-ubuntu-font-family ttf-anonymous-pro \
	noto-fonts-emoji ttf-joypixels ttf-indic-otf  noto-fonts \
	gimp inkscape audacity openscad freecad xchm vidcutter \
	pandoc-cli texlive-bin texlive-core texlive-pictures \
	unicode-emoji unrar p7zip unzip f3d flac jasper choose
touch /tmp/installapps.done
echo
echo "   !! Done"
echo
sleep 5
fi

if [ ! -e /tmp/installoffice.done ]; then
echo
echo " -- Office Install"
echo

# INSTALLING LibreOffice
sudo pacman -S --noconfirm libreoffice-still
touch /tmp/installoffice.done
echo
echo "   !! Done"
echo
sleep 5
fi

if [ ! -e /tmp/hwtools.done ]; then
echo
echo " -- Hardware Tools Install"
echo

sudo pacman -S --noconfirm \
	openocd avr-binutils avr-gcc avr-libc avrdude arduino \
	kicad moserial lrzsz stlink picocom android-tools android-udev \
	sdcc pulseview \
	arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-gdb \
	arm-none-eabi-newlib

# Enable this for Full Kicad experience
# sudo pacman -S kicad-library kicad-library-3d
touch /tmp/hwtools.done
echo
echo "   !! Done"
echo
sleep 5
fi

if [ ! -e /tmp/fix-xfce.done ]; then
echo
echo " -- Fix the save-session problem of xfce"
echo

xfconf-query -c xfce4-session -p /general/SaveOnExit -n -t bool -s false
sudo mkdir -p /etc/xdg/xfce4/kiosk
{
	echo "[xfce4-session]";
	echo "SaveSession=NONE";
} | sudo tee /etc/xdg/xfce4/kiosk/kioskrc
echo

# Disable Terminal F1 and F11 shortcuts
mkdir -p ~/.config/xfce4/terminal
{
	echo '(gtk_accel_path "<Actions>/terminal-window/fullscreen" "")';
	echo '(gtk_accel_path "<Actions>/terminal-window/contents" "")';
} > ~/.config/xfce4/terminal/accels.scm
echo

# Fix Start menu Actions
mkdir -p ~/.config/autostart
cat <<STFXEOF > ~/.config/autostart/Start-Menu-Fix.desktop
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=Star Menu Fix
Comment=
Exec=xcape -e 'Super_L=Alt_L|F1'
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false
STFXEOF

#sed -i 's/xfce4-popup-applicationsmenu/xfce4-popup-whiskermenu/' \
#	~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
#sed -i 's/applicationsmenu/whiskermenu/' \
#	~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

echo
touch /tmp/fix-xfce.done
echo
echo "   !! Done"
echo
sleep 5
fi

if [ ! -e /tmp/zramd.done ]; then
echo
echo " -- Install AUR Packages: zram"
echo

yay -S --noconfirm zramd
echo
sudo systemctl enable zramd
touch /tmp/zramd.done
echo
echo "   !! Done"
echo
sleep 5
echo
fi

# echo
# echo "Begin Install AUR Packages: others - Press Enter to continue..."
# read -r
# echo

# yay -S --noconfirm ttf-devanagarifonts

# # More Packages
# yay -S --noconfirm gforth simplescreenrecorder caffeine-ng \
#	thonny nodemcu-pyflasher brave-bin

# yay -S --noconfirm auto-cpufreq
# sudo systemctl enable --now auto-cpufreq

echo
echo " -- Installation Done"
echo
rm -rf /tmp/*.done
sleep 2

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m\n"
sleep 5
sudo reboot

