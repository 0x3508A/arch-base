#!/usr/bin/env bash

sudo reflector --country India,Singapore,Japan,"South Korea","United States" \
	--protocol https --threads 4 --age 6 --latest 10 \
	--sort rate --save /etc/pacman.d/mirrorlist
