#!/bin/bash

source "$DOTS_ROOT"/scripts/tools/log.sh

setup_nvidia() {

	(
		set -x
		sudo pacman -S --needed \
			nvidia-dkms
	)

	# add nitramfs & kernel parameters
	(
		set -x
		sudo cp /etc/default/grub /etc/default/grub.backup

		# Check if 'nvidia_drm.modeset=1' is already in the GRUB_CMDLINE_LINUX_DEFAULT line
		if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
			# It's not there, so append it
			sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ nvidia_drm.modeset=1"/' /etc/default/grub
		else
			(
				set +x
				info "nvidia_drm.modeset=1 is already set."
			)
		fi

		sudo grub-mkconfig -o /boot/grub/grub.cfg
	)
	(
		# Backup the original mkinitcpio.conf file
		(
			set -x
			sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
		)

		modules_to_add=("nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm")

		# Read the /etc/mkinitcpio.conf file and find the MODULES line
		modules_line=$(grep '^MODULES=' /etc/mkinitcpio.conf)

		# Check if each module already exists
		for module in "${modules_to_add[@]}"; do
			if ! grep -q "$module" <<<"$modules_line"; then
				# If the module does not exist, add it to the MODULES line
				(
					set -x
					sudo sed -i "/^MODULES=/ s/)/ $module)/" /etc/mkinitcpio.conf
				)
			fi
		done

		(
			set -x
			sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
		)
	)
	(
		file="/etc/modprobe.d/nvidia.conf"
		line="options nvidia-drm modeset=1"

		# check if file exists
		if [ ! -f "$file" ]; then
			(
				set -x
				echo "$line" | sudo tee "$file"
			)
		else
			# check if already contains line
			if ! grep -Fxq "$line" "$file"; then
				(
					set -x
					echo "$line" | sudo tee -a "$file"
				)
			else
				info "The line \"$line\" already exists in $file"
			fi
		fi
	)
}

install() {
	# setup_nvidia

	warn "unimplmented"
}
