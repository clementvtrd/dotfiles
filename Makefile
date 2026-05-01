.PHONY: default init dependencies stow install fonts-cascadia wallpaper

default: init dependencies stow install fonts-cascadia wallpaper vscodium

init:
	@if [ ! -d /usr/local/bin ]; then \
		sudo mkdir -p /usr/local/bin; \
	fi

dependencies:
	@if ! command -v brew >/dev/null 2>&1; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

stow:
	@if ! command -v stow >/dev/null 2>&1; then \
		brew install stow; \
	fi
	stow --dotfiles -t "${HOME}" home

install:
	@if command -v brew >/dev/null 2>&1; then \
		brew bundle --global check || brew bundle --global install; \
	fi
	@if command -v rtk >/dev/null 2>&1; then \
		rtk init -g; \
	fi

fonts-cascadia:
	@bash ./home/bin/install-cascadia-macos.sh

wallpaper:
	@osascript -e 'tell application "Finder" to set desktop picture to POSIX file "$(PWD)/assets/wallpaper.heic"'

vscodium:
	@mkdir -p "${HOME}/Library/Application Support/VSCodium/User"
	@ln -sf "$(PWD)/resources/vscodium/settings.json" "${HOME}/Library/Application Support/VSCodium/User/settings.json"
