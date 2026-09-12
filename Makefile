.PHONY: default init dependencies submodules chezmoi install fonts-cascadia wallpaper claude sandbox

default: init claude dependencies install chezmoi fonts-cascadia wallpaper

init:
	@if [ ! -d /usr/local/bin ]; then \
		sudo mkdir -p /usr/local/bin; \
	fi

# home/private_dot_copilot templates include ../private/pass/ids.toml, so the
# submodule must be checked out at its pinned commit before chezmoi renders.
submodules:
	@git submodule sync --quiet --recursive
	@git submodule update --init --recursive || { \
		echo "error: cannot fetch the private submodule - check SSH access to github.com"; \
		exit 1; \
	}

chezmoi: ~/.config/chezmoi/chezmoi.toml submodules
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
# GitHub Spec Kit: released specify-cli from PyPI, not git main
	@if command -v uv >/dev/null 2>&1; then \
		uv tool install --upgrade specify-cli; \
	fi

fonts-cascadia:
	@bash ./bin/install-cascadia-macos.sh

wallpaper:
	@osascript -e 'tell application "Finder" to set desktop picture to POSIX file "$(PWD)/assets/wallpaper.heic"'

claude:
	@curl -fsSL https://claude.ai/install.sh | bash

~/.config/chezmoi/chezmoi.toml:
	mkdir -p $(dir $@)
	echo 'sourceDir = "~/dotfiles"' > $@

sandbox:
	@sbx skills import -f
