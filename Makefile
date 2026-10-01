.PHONY: default init dependencies submodules chezmoi install fonts-cascadia wallpaper node sbx

default: init dependencies install chezmoi node fonts-cascadia wallpaper sbx

init:
	@if [ ! -d /usr/local/bin ]; then \
		sudo mkdir -p /usr/local/bin; \
	fi

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

fonts-cascadia:
	@bash ./bin/install-cascadia-macos.sh

wallpaper:
	@osascript -e 'tell application "Finder" to set desktop picture to POSIX file "$(PWD)/assets/wallpaper.heic"'

NVM_SH_CANDIDATES = "$$(brew --prefix nvm 2>/dev/null)/nvm.sh" /opt/homebrew/opt/nvm/nvm.sh /usr/local/opt/nvm/nvm.sh

node:
	@mkdir -p $(HOME)/.nvm
	@nvm_sh=""; \
	for candidate in $(NVM_SH_CANDIDATES); do \
		if [ -s "$$candidate" ]; then nvm_sh="$$candidate"; break; fi; \
	done; \
	if [ -n "$$nvm_sh" ]; then \
		NVM_SH="$$nvm_sh" bash -c 'export NVM_DIR="$$HOME/.nvm"; . "$$NVM_SH"; nvm install --lts'; \
	else \
		echo "warning: nvm.sh not found - skipping node (brew install nvm)"; \
	fi

sbx: sbx.policy sbx.settings

sbx.policy:
	-sbx policy init balanced

sbx.settings:
	sbx settings set sandbox.disk.dockerVolume 64g

~/.config/chezmoi/chezmoi.toml:
	mkdir -p $(dir $@)
	chezmoi init --source "$(HOME)/dotfiles"
