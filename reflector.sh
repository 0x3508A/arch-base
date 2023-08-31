#!/usr/bin/env bash

sudo reflector --country Singapore,Japan,"South Korea","United States",Australia \
	--protocol https --threads 4 --age 6 \
	--sort rate --save /etc/pacman.d/mirrorlist
