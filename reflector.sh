#!/usr/bin/env bash

set -e
set +x

sudo reflector --verbose \
	--country "United States" \
	--protocol https --age 6 --fastest 10 \
	--sort rate --save /etc/pacman.d/mirrorlist
echo
echo
more < /etc/pacman.d/mirrorlist
echo
