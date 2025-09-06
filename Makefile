default: init dependencies stow install

init:
	@if [ ! -d /usr/local/bin ]; then \
	  sudo mkdir -p /usr/local/bin; \
	fi
	git pull --recurse-submodules

dependencies:
	@if ! command -v brew > /dev/null; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

	@if [ -z "$${NVM_DIR}" ]; then \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash; \
	fi

stow:
	@if ! command -v brew > /dev/null; then \
		brew install stow	; \
	fi
	stow --dotfiles -t ${HOME} home
	stow -t "${HOME}/Library/Application Support/Übersicht" ubersicht

install:
	arch -arm64 brew bundle --global
