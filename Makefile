default: init dependencies stow install

init:
  @if [ ! -d /usr/local/bin ]; then \
    sudo mkdir -p /usr/local/bin
  fi

dependencies:
  @if ! command -v brew > /dev/null; then \
    /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  fi

stow:
  @if ! command -v stow > /dev/null; then \
    brew install stow \
  fi

  @stow --dotfiles -t ${HOME} home

install:
  @if command -v brew > /dev/null; then \
    arch -arm64 brew bundle --global \
  fi

.PHONY: default init dependencies stow install
