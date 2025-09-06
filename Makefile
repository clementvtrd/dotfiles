# Dotfiles Bootstrap System
# Enhanced with error handling, logging, and safety mechanisms

# Default target with enhanced logging
default: init dependencies stow install
	@echo "\033[32m[SUCCESS]\033[0m Dotfiles bootstrap completed successfully!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Restart your terminal or run: source ~/.zshrc"
	@echo "  2. Configure your Git user details if needed"
	@echo "  3. Run 'make validate' to verify installation"

# Initialize system with error checking
init:
	@echo "\033[34m[INFO]\033[0m Initializing dotfiles bootstrap..."
	@if [ ! -d /usr/local/bin ]; then \
		echo "\033[34m[INFO]\033[0m Creating /usr/local/bin directory..."; \
		sudo mkdir -p /usr/local/bin || { echo "\033[31m[ERROR]\033[0m Failed to create /usr/local/bin"; exit 1; }; \
		echo "\033[32m[SUCCESS]\033[0m Created /usr/local/bin directory"; \
	fi
	@echo "\033[34m[INFO]\033[0m Updating git submodules..."
	@git pull --recurse-submodules || { echo "\033[31m[ERROR]\033[0m Failed to update git submodules"; exit 1; }
	@echo "\033[32m[SUCCESS]\033[0m Git submodules updated"

# Install dependencies with better error handling
dependencies:
	@echo "\033[34m[INFO]\033[0m Installing system dependencies..."
	@if ! command -v brew > /dev/null; then \
		echo "\033[34m[INFO]\033[0m Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "\033[31m[ERROR]\033[0m Failed to install Homebrew"; exit 1; }; \
		echo "\033[32m[SUCCESS]\033[0m Homebrew installed successfully"; \
	else \
		echo "\033[32m[SUCCESS]\033[0m Homebrew already installed"; \
	fi

	@if [ -z "$${NVM_DIR}" ]; then \
		echo "\033[34m[INFO]\033[0m Installing NVM..."; \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash || { echo "\033[31m[ERROR]\033[0m Failed to install NVM"; exit 1; }; \
		echo "\033[32m[SUCCESS]\033[0m NVM installed successfully"; \
	else \
		echo "\033[32m[SUCCESS]\033[0m NVM already installed"; \
	fi

# Create backup and install dotfiles
backup:
	@echo "\033[34m[INFO]\033[0m Creating backup of existing dotfiles..."
	@BACKUP_DIR="$$HOME/.dotfiles_backup_$$(date +%Y%m%d_%H%M%S)"; \
	mkdir -p "$$BACKUP_DIR"; \
	for file in .zshrc .zshenv .gitconfig .ssh/config; do \
		if [ -f "$$HOME/$$file" ] && [ ! -L "$$HOME/$$file" ]; then \
			echo "\033[34m[INFO]\033[0m Backing up $$file..."; \
			mkdir -p "$$BACKUP_DIR/$$(dirname $$file)"; \
			cp "$$HOME/$$file" "$$BACKUP_DIR/$$file"; \
		fi; \
	done; \
	if [ -n "$$(ls -A $$BACKUP_DIR 2>/dev/null)" ]; then \
		echo "\033[32m[SUCCESS]\033[0m Backup created at $$BACKUP_DIR"; \
	else \
		echo "\033[34m[INFO]\033[0m No existing dotfiles to backup"; \
		rmdir "$$BACKUP_DIR"; \
	fi

# Install GNU Stow and apply dotfiles
stow: backup
	@echo "\033[34m[INFO]\033[0m Installing and configuring dotfiles..."
	@if ! command -v stow > /dev/null; then \
		echo "\033[34m[INFO]\033[0m Installing GNU Stow..."; \
		brew install stow || { echo "\033[31m[ERROR]\033[0m Failed to install GNU Stow"; exit 1; }; \
		echo "\033[32m[SUCCESS]\033[0m GNU Stow installed"; \
	else \
		echo "\033[32m[SUCCESS]\033[0m GNU Stow already installed"; \
	fi
	
	@echo "\033[34m[INFO]\033[0m Applying dotfiles to home directory..."
	@stow --dotfiles -t ${HOME} home || { echo "\033[31m[ERROR]\033[0m Failed to stow home dotfiles"; exit 1; }
	@echo "\033[32m[SUCCESS]\033[0m Home dotfiles applied"
	
	@echo "\033[34m[INFO]\033[0m Applying Übersicht configuration..."
	@if [ -d "${HOME}/Library/Application Support/Übersicht" ]; then \
		stow -t "${HOME}/Library/Application Support/Übersicht" ubersicht || { echo "\033[31m[ERROR]\033[0m Failed to stow Übersicht config"; exit 1; }; \
		echo "\033[32m[SUCCESS]\033[0m Übersicht configuration applied"; \
	else \
		echo "\033[33m[WARNING]\033[0m Übersicht not found, skipping widget configuration"; \
	fi

# Install packages with validation
install:
	@echo "\033[34m[INFO]\033[0m Installing packages via Homebrew..."
	@if command -v brew > /dev/null; then \
		arch -arm64 brew bundle --global || { echo "\033[31m[ERROR]\033[0m Failed to install packages"; exit 1; }; \
		echo "\033[32m[SUCCESS]\033[0m All packages installed successfully"; \
	else \
		echo "\033[31m[ERROR]\033[0m Homebrew not found, run 'make dependencies' first"; \
		exit 1; \
	fi

# Validation target to check installation
validate:
	@echo "\033[34m[INFO]\033[0m Validating dotfiles installation..."
	@echo ""
	@echo "Checking core tools:"
	@command -v brew > /dev/null && echo "\033[32m[SUCCESS]\033[0m ✓ Homebrew" || echo "\033[31m[ERROR]\033[0m ✗ Homebrew"
	@command -v git > /dev/null && echo "\033[32m[SUCCESS]\033[0m ✓ Git" || echo "\033[31m[ERROR]\033[0m ✗ Git"
	@command -v stow > /dev/null && echo "\033[32m[SUCCESS]\033[0m ✓ GNU Stow" || echo "\033[31m[ERROR]\033[0m ✗ GNU Stow"
	@[ -f "${HOME}/.zshrc" ] && echo "\033[32m[SUCCESS]\033[0m ✓ Zsh config" || echo "\033[31m[ERROR]\033[0m ✗ Zsh config"
	@[ -f "${HOME}/.gitconfig" ] && echo "\033[32m[SUCCESS]\033[0m ✓ Git config" || echo "\033[31m[ERROR]\033[0m ✗ Git config"
	@[ -d "${HOME}/.nvm" ] && echo "\033[32m[SUCCESS]\033[0m ✓ NVM" || echo "\033[33m[WARNING]\033[0m ⚠ NVM (may need terminal restart)"

# Clean target to remove installed dotfiles (with confirmation)
clean:
	@echo "\033[33m[WARNING]\033[0m This will remove all stowed dotfiles from your home directory"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "\033[34m[INFO]\033[0m Removing stowed dotfiles..."; \
		stow --dotfiles -D -t ${HOME} home || true; \
		if [ -d "${HOME}/Library/Application Support/Übersicht" ]; then \
			stow -D -t "${HOME}/Library/Application Support/Übersicht" ubersicht || true; \
		fi; \
		echo "\033[32m[SUCCESS]\033[0m Dotfiles removed"; \
	else \
		echo "\033[34m[INFO]\033[0m Operation cancelled"; \
	fi

# Help target
help:
	@echo "Dotfiles Bootstrap System"
	@echo ""
	@echo "Available targets:"
	@echo "  make          - Full bootstrap (init + dependencies + stow + install)"
	@echo "  make init     - Initialize system (create dirs, update submodules)"
	@echo "  make dependencies - Install Homebrew and NVM"
	@echo "  make backup   - Create backup of existing dotfiles"
	@echo "  make stow     - Install GNU Stow and apply dotfiles"
	@echo "  make install  - Install packages via Homebrew"
	@echo "  make validate - Validate installation"
	@echo "  make clean    - Remove stowed dotfiles (with confirmation)"
	@echo "  make help     - Show this help message"

.PHONY: default init dependencies backup stow install validate clean help
