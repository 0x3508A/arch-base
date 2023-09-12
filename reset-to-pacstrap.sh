#!/usr/bin/env bash

# Stop the Display Manger
sudo systemctl disable lightdm
# sudo systemctl disable gdm
# sudo systemctl disable sddm

# Mark Everything as Dependency
sudo pacman -D --asdeps "$(pacman -Qqe)"

# Mark pacstrap packages as explicit

sudo pacman -D --asexplicit base linux-lts linux-firmware vim nano git \
	bash-completion intel-ucode

# sudo pacman -D --asexplicit base linux-lts linux-firmware vim nano git \
# 	bash-completion amd-ucode

# Take into Root user as otherwise it would not work
# Dangerous command to remove all dependencies
su -c 'pacman -Qttdq | pacmans -Rns -'

