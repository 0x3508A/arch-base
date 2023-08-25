#!/usr/bin/env bash

pacman -S reflector

reflector --country India,Singapore,Japan,"South Korea","United States" \
	--protocol https --threads 4 --age 6 \
	--connection-timeout 2 --download-timeout 10 \
	--sort rate --save /etc/pacman.d/mirrorlist
