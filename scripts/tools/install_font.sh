#!/bin/bash

install_nord_fonts() {
	declare -A font_packages=(
		["JetBrainsMonoNL Nerd Font"]="ttf-jetbrains-mono-nerd" # for kitty
		["0xProto Nerd Font"]="ttf-0xproto-nerd"                # below for nvim
		["Agave Nerd Font"]="ttf-agave-nerd"
		["3270 Nerd Font"]="ttf-3270-nerd"
	)

	for font_name in "${!font_packages[@]}"; do
		if fc-list | grep -q "$font_name"; then
			echo "$font_name installed"
		else
			package_name="${font_packages[$font_name]}"
			(
				set -x
				$PACMAN_INSTALL "$package_name"
			)
		fi
	done
}
