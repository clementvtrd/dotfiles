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

# Install GNU Stow and apply dotfiles
stow:
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


.PHONY: default init dependencies stow install
