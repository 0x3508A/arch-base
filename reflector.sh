#!/usr/bin/env bash

sudo reflector --verbose \
	--country "United States" \
	--protocol https --age 6 --fastest 10 \
	--sort rate --save /etc/pacman.d/mirrorlist
echo
echo
cat /etc/pacman.d/mirrorlist | more
echo
