#!/bin/bash

install() {

	(
		set -x
		$PACMAN_INSTALL kitty
	)

	(
		set -x
		cp -r "$DOT_CONF_DIR/dunst" "$HOME/.config/"
	)
}
