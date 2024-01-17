#!/bin/bash

install() {

	(
		set -x
		sudo pacman -S --needed kitty
	)

	(
		set -x
		cp -r "$DOT_CONF_DIR/kitty" "$HOME/.config/"
	)
}
