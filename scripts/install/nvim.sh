#!/bin/bash

source "$DOTS_ROOT"/scripts/tools/install_font.sh

install_requirements() {
	(
		set -x
		$PACMAN_INSTALL \
			neovim neovide \
			tree-sitter-cli \
			xclip wl-clipboard \
			ripgrep lazygit nodejs
	)
}

# clean neovim folders
backup_old_conf() {
	echo "Cleaning up old nvim config folders ..."

	local backup_dir="/tmp/nvim"
	declare -A directories=(
		["$HOME/.config/nvim"]="$backup_dir/nvim.bak"
		["$HOME/.local/share/nvim"]="$backup_dir/share.bak"
		["$HOME/.local/state/nvim"]="$backup_dir/state.bak"
		["$HOME/.local/cache/nvim"]="$backup_dir/cache.bak"
	)

	if [ ! -d "$backup_dir" ]; then
		mkdir -p "$backup_dir"
	else
		rm -rf "${backup_dir:?}"
		mkdir -p "$backup_dir"
	fi

	for source_dir in "${!directories[@]}"; do
		destination_dir="${directories[$source_dir]}"
		if [ -d "$source_dir" ]; then
			mv "$source_dir" "$destination_dir"
		fi
	done
}

clone_astronvim_repo() {
	backup_old_conf

	(
		set -x
		git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
	)
	(
		set -x
		git clone --depth 1 https://github.com/siuolyppah/astronvim_config.git ~/.config/nvim/lua/user
	)
}

install() {
	install_nord_fonts
	install_requirements
	clone_astronvim_repo
}
