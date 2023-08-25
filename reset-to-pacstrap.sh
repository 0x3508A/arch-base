#!/usr/bin/env bash

## Stop the Display Manger
# sudo systemctl disable gdm
# sudo systemctl disable lightdm
# sudo systemctl disable sddm

## Mark Everything as Dependency
# sudo pacman -D --asdeps $(pacman -Qqe)

## Mark pacstrap packages as explicit

# sudo pacman -D --asexplicit base linux linux-firmware vim git \
# 	bash-completion intel-ucode

# sudo pacman -D --asexplicit base linux linux-firmware vim git \
# 	bash-completion amd-ucode

## Take into Root user as otherwise it would not work
# su -
# Dangerous command
# pacman -Qttdq | pacmans -Rns -

