#!/bin/bash

cur_shell_name() {
	current_shell=$(basename "$SHELL")

	if [ "$current_shell" = "zsh" ]; then
		if [ "$ZSH_NAME" = "zsh" ]; then
			echo "zsh"
		else
			echo "fish"
		fi
	else
		echo "$current_shell"
	fi
}
