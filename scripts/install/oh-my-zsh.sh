#!/bin/bash

source "$DOTS_ROOT"/scripts/tools/log.sh

install_plugins() {
	(
		set -x
		paru -S --needed \
			zsh-syntax-highlighting-git \
			zsh-autosuggestions-git
	)
}

install() {
	(
		set -x
		# ruby: for some plugin functionality
		# oh-my-zsh-powerline-theme-git: great theme
		# bullet-train-oh-my-zsh-theme-git: better powerline theme
		paru -S --needed \
			zsh oh-my-zsh-git \
			ruby \
			oh-my-zsh-powerline-theme-git \
			bullet-train-oh-my-zsh-theme-git \
			zsh-syntax-highlighting-git \
			zsh-autosuggestions-git
	)

	# cp "/usr/share/oh-my-zsh/zshrc" "$HOME/.zshrc"
	(
		set -x
		cp -r "$DOT_CONF_DIR/oh-my-zsh/.zshrc" "$HOME/.zshrc"
	)

	current_shell=$(basename "$SHELL")
	if [ "$current_shell" != "zsh" ]; then
		(
			set -x
			chsh -s "$(which zsh)" # Change the default shell to Zsh
		)
		info "Default shell has been changed to Zsh."
	else
		info "The current user's default shell is already Zsh. No changes needed."
	fi

	info ".zshrc changed, please run \"\e[4msource \$HOME/.zshrc\e[0m\" to reload!"
}
