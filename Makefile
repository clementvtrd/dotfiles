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

install: python cask misc

python:
	arch -arm64 brew bundle --file modules/python/Brewfile
	pyenv install --skip-existing 3.12.4
	cd modules/python && pyenv exec pip install --upgrade pip
	cd modules/python && pyenv exec pip install -r requirements.txt

cask:
	arch -arm64 brew bundle --file modules/cask/Brewfile

misc:
	arch -arm64 brew bundle --file modules/misc/Brewfile

stow:
	stow --dotfiles -t ${HOME} home
