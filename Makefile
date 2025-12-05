.PHONY: default init dependencies stow install shell

default: init dependencies stow install shell

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
		arch -arm64 brew bundle --global check || arch -arm64 brew bundle --global install; \
	fi

shell:
	@sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells' || true
	@chsh -s $$(which fish)
