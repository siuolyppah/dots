#!/bin/bash

DOTS_ROOT=$(dirname "$(readlink -f "$0")")
export DOTS_ROOT

DOT_CONF_DIR="$DOTS_ROOT/dot-config"
export DOT_CONF_DIR

PACMAN_INSTALL="sudo pacman -S --needed --noconfirm"
export PACMAN_INSTALL

PARU_INSTALL="paru -S --needed --noconfirm"
export PARU_INSTALL

IS_NVIDIA=false
export IS_NVIDIA

IS_THINKPAD=false
export IS_THINKPAD

source scripts/tools/log.sh

default_shell="fish"
shell=$default_shell
default_skip_conf_list=("fisher" "oh-my-zsh") # added later
skip_conf_list=()

while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
	--nvidia)
		shift
		IS_NVIDIA=true
		;;
	--shell)
		shift
		shell="$1"
		;;
	--skip)
		shift
		while [[ $# -gt 0 && ! $1 == -* ]]; do
			skip_conf_list+=("$1")
			shift
		done
		continue
		;;
	--)
		shift
		break
		;;
	*)
		echo "Invalid option: $key"
		exit 1
		;;
	esac

	shift
done

script_files=$(find "scripts/install" -type f -name "*.sh")
# default skipped conf
for conf in "${default_skip_conf_list[@]}"; do
	script_files=$(echo "$script_files" | grep -v "$conf")
done

# add fisher or oh-my-zsh conf
if [[ "$shell" == "fish" ]]; then
	script_files+=$'\n'"scripts/install/fisher.sh"
elif [[ "$shell" == "zsh" ]]; then
	script_files+=$'\n'"scripts/install/oh-my-zsh.sh"
else
	warn "unregonized shell $shell, using default shell \"$default_shell\""
	shell=$default_shell
fi

# remove skipped conf
for conf in "${skip_conf_list[@]}"; do
	script_files=$(echo "$script_files" | grep -v "$conf")
done

confirm_before_install() {

	info "current options: IS_NVIDIA=$IS_NVIDIA"

	info "following configuration will be installed:"
	while IFS= read -r line; do
		echo "$line"
	done <<<"$script_files"
	echo

	echo "Continue?"
	while true; do
		read -p "Y/n: " option

		if [[ $option == "Y" || $option == "y" || $option == "" ]]; then
			break
		elif [[ $option == "n" ]]; then
			exit 0
		else
			echo -n "invalid input, please try input "
		fi
	done
}

confirm_before_install

for script_file in $script_files; do
	if [[ -f "$script_file" ]]; then
		unset install
		# shellcheck disable=1090
		source "$script_file"

		if declare -f install >/dev/null; then
			conf_name=$(basename "$script_file" .sh)

			info "----- configuring $conf_name -----"
			install
			info "configuring $conf_name done!"
		else
			error "No function named 'install' was found in $script_file. skipped!"
		fi
	fi

	echo
done
