default: init homebrew install nvm

init:
	sudo mkdir -p /usr/local/bin

homebrew:
	@if ! command -v brew > /dev/null; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

nvm:
	@if [ -z "$${NVM_DIR}" ]; then \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash; \
	fi

install:
	arch -arm64 brew bundle install

stow:
	stow --dotfiles -t ${HOME} home
