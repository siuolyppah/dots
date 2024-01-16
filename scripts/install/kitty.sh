#!/bin/bash

install() {
	(
		set -x
		cp -r "$DOT_CONF_DIR/kitty" "$HOME/.config/"
	)
}
