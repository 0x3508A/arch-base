# Arch Installation Script

This is personal repository non-working Arch install scripts.

## Artifacts

- **[Fast Mirror list](./mirrorlist.txt)** - Useful for quick mirrorlist updates.

## References

- Latest reference
	
	Arch Linux Monthly Install: April 2022
	<https://www.youtube.com/watch?v=HIXnT178TgI>

- Ermanno Ferrari - [Arch Basic Install Public](https://gitlab.com/eflinux/arch-basic)

- Resetting Arch Linux <https://www.youtube.com/watch?v=2vbrFZiq2Hc>

- XFCE

	- Arch Linux Full install on BIOS/MBR with Xfce4 and visual guide
		<https://www.youtube.com/watch?v=FudOL0-B9Hs>
	
	- XFCE Customization
		<https://www.youtube.com/watch?v=29ARF14InaU>

## Scripts

- Thinking what to add.

## Notes

- Font setting
	
	```sh
	setfont ter-132n
	```

- WiFi connection
	
	```sh
	iwctl
	# In The Shell
	station wlan0 connect "SSID"
	
	# Exit
	exit
	```

- Setup Time and date settings
	
	```sh
	timedatectl set-timezone "Asia/Kolkata"
	timedatectl set-local-rtc 1
	timedatectl set-ntp true
	```
	
	To Check Status:
	
	```sh
	timedatectl status
	```
	
- Normal `ext4` format command

	```sh
	mkfs.ext4 -L ArchRoot /dev/....
	```

- Boot Partition `FAT32` format command

	```sh
	mkfs.fat -F32 -n ARCHROOT /dev/....
	```

- Swap partition format command

	```sh
	mkswap -L ArchSwap /dev/....
	```

- Partition codes in `gdisk`

	```
	EFI Partition 			: ef00
	Swap Partition			: 8200
	Linux Partition/btrfs 	: 8300
	```

- `btrfs` Creation steps

	```sh
	mkfs.btrfs -f /dev/sda1
	# Mount a Linux Partition
	mount /dev/sda1 /mnt
	cd mnt
	# Create the Sub-Volumes
	btrfs subvolume create @
	btrfs subvolume create @home
	# Exit the mount
	cd
	umount /mnt
	# Mount the Sub-volumes with special attibutes
	mount -o noatime,ssd,space_cache=v2,compress=zstd,discard=async,subvol=@ /mnt /dev/sda1
	mkdir -p /mnt/{home,boot}
	mount -o noatime,ssd,space_cache=v2,compress=zstd,discard=async,subvol=@home /mnt/home /dev/sda1
	```

- `pacstrap` Packages list

	Intel System:

	```sh
	pacstrap -K /mnt base linux linux-firmware vim git \
		bash-completion intel-ucode
	```

	AMD System:

	```sh
	pacstrap -K /mnt base linux linux-firmware vim git \
		bash-completion amd-ucode
	```

- `genfstab` Command

	```sh
	genfstab -U /mnt >> /mnt/etc/fstab
	```

- Reset Arch Linux
	
	- Remove the Display Manger
	
		For Gnome:
		
		```sh
		sudo systemctl disable gdm
		```
		
		For XFCE:
		
		```sh
		sudo systemctl disable lightdm
		# or 
		sudo systemctl disable lxdm
		```
		
		For KDE:
		
		```sh
		sudo systemctl disable sddm
		```
	
	- Mark all packages as **Dependencies**
		
		```sh
		sudo pacman -D --asdeps $(pacman -Qqe)
		```
	
	- Set only the `pacstrap` Packages as **Explicit**
	
		For Intel System:
		
		```sh
		sudo pacman -D --asexplicit base linux linux-firmware \
			vim git bash-completion intel-ucode
		```
		
		For AMD System:
		
		```sh
		sudo pacman -D --asexplicit base linux linux-firmware \
			vim git bash-completion amd-ucode
		```
	
	- Remove all Dependencies
	
		```sh
		# Take into Root user as otherwise it would not work
		su -
		# Dangerous command
		pacman -Qttdq | pacmans -Rns -
		```

## License

```
(C) Copyright (C) 2023 Abhijit Bose - All Rights Reserved
This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or
send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
```

All software, documents, artifacts, files of any type and articles
found in this repository are governed by the following license -

**Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)**

<https://creativecommons.org/licenses/by-nc-nd/4.0/>

[LICENSE.txt file](./LICENSE.txt)

`SPDX: CC-BY-NC-ND-4.0`

Contents have been shared under the following terms specified by the above license:

- **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

- **NonCommercial** — You may not use the material for commercial purposes.

- **NoDerivatives** — If you remix, transform, or build upon the material, you may not distribute the modified material.

- **No additional restrictions** — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
