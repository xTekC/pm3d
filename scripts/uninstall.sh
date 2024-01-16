#!/bin/sh

##########################################
#        Copyright (c) xTekC.            #
#        Licensed under MPL-2.0.         #
#        See LICENSE for details.        #
# https://www.mozilla.org/en-US/MPL/2.0/ #
##########################################

set -e

RED='\033[0;31m'
NC='\033[0m' # No Color

red_printf() {
	printf '%b\n' "${RED}$1${NC}"
}

BIN_NAME="pm3d"

detect_architecture() {
	case "$(uname -s)" in
	Linux)
		case "$(uname -m)" in
		riscv64)
			# Check if it's Android
			if [ -f /system/bin/linker64 ]; then
				echo "riscv64-linux-android"
			else
				found_file=false
				for file in /lib*/ld-musl-*.so.1; do
					if [ -f "$file" ]; then
						found_file=true
						break
					fi
				done
				if [ "$found_file" = true ]; then
					echo "riscv64gc-unknown-linux-musl"
				else
					echo "riscv64gc-unknown-linux-gnu"
				fi
			fi
			;;
		aarch64)
			# Check if it's Android
			if [ -f /system/bin/linker64 ]; then
				echo "aarch64-linux-android"
			else
				found_file=false
				for file in /lib*/ld-musl-*.so.1; do
					if [ -f "$file" ]; then
						found_file=true
						break
					fi
				done
				if [ "$found_file" = true ]; then
					echo "aarch64-unknown-linux-musl"
				else
					echo "aarch64-unknown-linux-gnu"
				fi
			fi
			;;
		x86_64)
			found_file=false
			for file in /lib*/ld-musl-*.so.1; do
				if [ -f "$file" ]; then
					found_file=true
					break
				fi
			done
			if [ "$found_file" = true ]; then
				echo "x86_64-unknown-linux-musl"
			else
				echo "x86_64-unknown-linux-gnu"
			fi
			;;
		*)
			echo "Unsupported BIN_ARCH: $(uname -m)"
			exit 1
			;;
		esac
		;;
	FreeBSD)
		case "$(uname -m)" in
		riscv64)
			echo "riscv64-unknown-freebsd"
			;;
		aarch64)
			echo "aarch64-unknown-freebsd"
			;;
		x86_64)
			echo "x86_64-unknown-freebsd"
			;;
		*)
			echo "Unsupported BIN_ARCH: $(uname -m)"
			exit 1
			;;
		esac
		;;
	MacOS)
		case "$(uname -m)" in
		aarch64)
			echo "aarch64-apple-darwin"
			;;
		x86_64)
			echo "x86_64-apple-darwin"
			;;
		*)
			echo "Unsupported BIN_ARCH: $(uname -m)"
			exit 1
			;;
		esac
		;;
	*)
		echo "Unsupported operating system: $(uname -s)"
		exit 1
		;;
	esac
}

BIN_ARCH=$(detect_architecture)
BIN_DIR="$HOME/${BIN_NAME}"

detect_shell() {
  SHELL_PATH=$(which "$SHELL")
  case "$SHELL_PATH" in
    */shell) echo ".shrc" ;;
    */bash) echo ".bashrc" ;;
    */zsh) echo ".zshrc" ;;
    */fish) echo ".config/fish/config.fish" ;;
    */nushell) echo ".config/nushell/config.toml" ;;
    *) echo "unknown" ;;
  esac
}

remove_bin() {
	clear
	if [ -d $BIN_DIR ]; then
		#rm -rf $BIN_DIR

		if [ $BIN_ARCH = "riscv64-linux-android" ] || [ $BIN_ARCH = "aarch64-linux-android" ]; then
			red_printf "Removed ${NC}$BIN_NAME${RED} binary from ${NC}$BIN_DIR${RED}.\n"
			sed -i '/alias '$BIN_NAME'=".\/'$BIN_NAME'\/bin\/'$BIN_NAME'"/d' $HOME/.bashrc
			red_printf "Removed ${NC}$BIN_NAME${RED} binary alias."
		else
			red_printf "Remove ${NC}$BIN_NAME${RED} from \$HOME:\n"
			echo "cd \$HOME && rm -rf pm3d"
			echo ''
			red_printf "Shell config detected as: ${NC}$(detect_shell)"
			red_printf "Remove ${NC}$BIN_NAME${RED} bin dir from shell config file:\n"
			echo "sed -i '/export PATH=\"\$PATH:\$HOME\/pm3d\/bin\"/d' \"\$HOME/$(detect_shell)\""
			echo ''
		fi

	else
		red_printf "\n${NC}$BIN_NAME${RED} binary not found."
		echo ''
	fi
}

detect_shell
remove_bin
