#!/usr/bin/env bash

pacstrap -K /mnt base linux-lts linux-firmware vim nano git \
 	bash-completion intel-ucode

# pacstrap -K /mnt base linux-lts linux-firmware vim nano git \
# 	bash-completion amd-ucode

genfstab -U /mnt >> /mnt/etc/fstab
