#!/bin/sh

##########################################
#        Copyright (c) xTekC.            #
#        Licensed under MPL-2.0.         #
#        See LICENSE for details.        #
# https://www.mozilla.org/en-US/MPL/2.0/ #
##########################################

set -e

ORANGE='\033[0;33m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

AUTHOR_NAME="xTekC"
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
BIN_VERSION=$(curl -sSL https://api.github.com/repos/${AUTHOR_NAME}/${BIN_NAME}/releases/latest | grep 'tag_name' | cut -d'"' -f4)
BIN_URL="https://github.com/$AUTHOR_NAME/$BIN_NAME/releases/download/$BIN_VERSION/$BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz"
BIN_HASH_URL="https://github.com/$AUTHOR_NAME/$BIN_NAME/releases/download/$BIN_VERSION/$BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz.sha512"

orange_printf() {
	printf '%b\n' "${ORANGE}$1${NC}"
}

purple_printf() {
	printf '%b\n' "${PURPLE}$1${NC}"
}

purple_printf_nnl() {
	printf '%b' "${PURPLE}$1${NC}"
}

green_printf() {
	printf '%b\n' "${GREEN}$1${NC}"
}

cyan_printf() {
	printf '%b\n' "${CYAN}$1${NC}"
}

red_printf() {
	printf '%b\n' "${RED}$1${NC}"
}

ensure() {
	if ! "$@"; then
		echo "Command failed: $*"
		exit 1
	fi
}

download_files() {
	clear
	orange_printf "\n\n$BIN_NAME $BIN_VERSION\n\n"

	BIN_URL="https://github.com/$AUTHOR_NAME/$BIN_NAME/releases/download/$BIN_VERSION/$BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz"
	BIN_HASH_URL="https://github.com/$AUTHOR_NAME/$BIN_NAME/releases/download/$BIN_VERSION/$BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz.sha512"

	purple_printf "Downloading..."
	purple_printf "$BIN_ARCH binary."
	curl -LO "$BIN_URL"

	purple_printf "Downloading..."
	purple_printf "$BIN_ARCH.sha512 hash."
	curl -LO "$BIN_HASH_URL"
}

verify_hash() {
	purple_printf "Verifying binary hash..."
	if sha512sum -c $BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz.sha512 --quiet; then
		printf "#################################\n"
		green_printf "Hash verification succeeded."
		printf "#################################\n"
		purple_printf "Extracting binary..."
		tar -xzvf $BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz -C $HOME
		rm $BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz $BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz.sha512
		purple_printf "Installation complete."

		if [ $BIN_ARCH = "riscv64-linux-android" ] || [ $BIN_ARCH = "aarch64-linux-android" ]; then
			echo "alias $BIN_NAME=\"./$BIN_NAME/bin/$BIN_NAME\"" >>$HOME/.bashrc
			purple_printf "\nTo use the binary, exit the terminal and re-open.\n"
			purple_printf "Type ${PURPLE}'${NC}exit${PURPLE}'${PURPLE} and press ${NC}Enter${PURPLE}.\n"
		else
			manual
		fi

	else
		printf "#################################\n"
		red_printf "Hash verification failed."
		printf "#################################\n"
		red_printf "The binary integrity cannot be guaranteed."
		rm $BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz $BIN_NAME-$BIN_VERSION-$BIN_ARCH.tar.gz.sha512
		purple_printf "Cleanup complete."
		sleep 2
		clear
	fi
}

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

manual() {
  purple_printf "Shell config detected as: ${NC}$(detect_shell)"
  purple_printf "Append ${NC}$BIN_NAME${PURPLE} bin dir to shell config file:\n"
  SHELL_CONFIG_FILE=$(detect_shell)
  if [ "$SHELL_CONFIG_FILE" != "unknown" ]; then
    echo "echo 'export PATH=\"\$PATH:\$HOME/pm3d/bin\"' >> \$HOME/$SHELL_CONFIG_FILE"
    purple_printf "\nSource the shell config file:\n"
    echo "source \$HOME/$SHELL_CONFIG_FILE"
  else
    echo "Shell config file not found or shell unknown."
  fi
  echo ''
}

BIN_ARCH=$(detect_architecture)
download_files
verify_hash
SHELL_CONFIG_FILE=$(detect_shell)
