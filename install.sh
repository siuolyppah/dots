#!/bin/bash

DOTS_ROOT=$(dirname "$(readlink -f "$0")")
export DOTS_ROOT
DOT_CONF_DIR="$DOTS_ROOT/dot-config"
export DOT_CONF_DIR

source scripts/tools/log.sh

# -s for skip nvim config
skip_nvim=false
while getopts ":s" opt; do
	case $opt in
	s)
		skip_nvim=true
		;;
	\?)
		error "Invalid option: -$OPTARG"
		;;
	esac
done

if [[ "$skip_nvim" == true ]]; then
	script_files=$(find "scripts/install" -type f -name "*.sh" | grep -v "nvim.sh")
else
	script_files=$(find "scripts/install" -type f -name "*.sh")
fi

echo "$script_files"

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
