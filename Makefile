.PHONY: default init dependencies submodules chezmoi install fonts-cascadia wallpaper claude node skills skills-link

default: init claude dependencies install chezmoi node skills fonts-cascadia wallpaper

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

SKILL_AGENTS = -a claude-code -a github-copilot -a codex

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

skills: node
	@nvm_sh=""; \
	for candidate in $(NVM_SH_CANDIDATES); do \
		if [ -s "$$candidate" ]; then nvm_sh="$$candidate"; break; fi; \
	done; \
	if [ -n "$$nvm_sh" ]; then \
		NVM_SH="$$nvm_sh" bash -c 'export NVM_DIR="$$HOME/.nvm"; . "$$NVM_SH"; nvm use --lts; export DO_NOT_TRACK=1; cd "$(CURDIR)"; npx -y skills@1.7.0 remove -g --all -y || true; npx -y skills@1.7.0 add ./skills -g $(SKILL_AGENTS) -s "*" -y'; \
		$(MAKE) --no-print-directory skills-link; \
	else \
		echo "warning: nvm.sh not found - skipping skills install (brew install nvm)"; \
	fi

skills-link:
	@for agent_dir in $(HOME)/.copilot/skills $(HOME)/.codex/skills; do \
		mkdir -p "$$agent_dir"; \
		for skill in $(HOME)/.agents/skills/*/; do \
			[ -d "$$skill" ] || continue; \
			ln -sfn "$${skill%/}" "$$agent_dir/$$(basename "$$skill")"; \
		done; \
	done

~/.config/chezmoi/chezmoi.toml:
	mkdir -p $(dir $@)
	echo 'sourceDir = "~/dotfiles"' > $@
