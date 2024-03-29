#!/bin/bash

source "$DOTS_ROOT"/scripts/tools/cur_shell.sh

install() {

	(
		set -x
		$PACMAN_INSTALL \
			fish fisher
	)

	# current_shell=$(basename "$SHELL")
	current_shell=$(cur_shell_name)
	echo "shell: $current_shell"
	if [ "$current_shell" != "fish" ]; then
		(
			set -x
			chsh -s "$(which fish)" # Change the default shell to Zsh
		)
		info "Default shell has been changed to fish."
	else
		info "The current user's default shell is already fish. No changes needed."
	fi

	# theme
	(
		set -x

		fish -c '
			fisher install catppuccin/fish
			fish_config theme save "Catppuccin Mocha"
		'
	)

	# plugins recommendation:
	# https://www.rockyourcode.com/fish-plugins-i-like/
	# https://github.com/jorgebucaran/awsm.fish
	(
		set -x
		fish -c '
			fisher install jethrokuan/z
			fisher install franciscolourenco/done
			fisher install gazorby/fish-abbreviation-tips
		'
	)

	cp -r "$DOT_CONF_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
}
