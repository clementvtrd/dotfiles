.PHONY: default init dependencies chezmoi install fonts-cascadia wallpaper

default: init dependencies install chezmoi fonts-cascadia wallpaper

init:
	@if [ ! -d /usr/local/bin ]; then \
		sudo mkdir -p /usr/local/bin; \
	fi

chezmoi: ~/.config/chezmoi/chezmoi.toml
	chezmoi apply

dependencies:
	@if ! command -v brew >/dev/null 2>&1; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

install:
	@if command -v brew >/dev/null 2>&1; then \
		brew bundle --global check || brew bundle --global install; \
	fi
	@if command -v rtk >/dev/null 2>&1; then \
		rtk init -g; \
	fi

fonts-cascadia:
	@bash ./bin/install-cascadia-macos.sh

wallpaper:
	@osascript -e 'tell application "Finder" to set desktop picture to POSIX file "$(PWD)/assets/wallpaper.heic"'

~/.config/chezmoi/chezmoi.toml:
	mkdir -p $(dir $@)
	echo 'sourceDir = "~/dotfiles"' > $@