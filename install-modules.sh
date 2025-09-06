#!/bin/bash

# Modular Dotfiles Installer Script
# This script demonstrates how the bootstrap system can be extended with modular installation

set -e

# Color definitions
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Usage function
usage() {
    echo "Modular Dotfiles Installer"
    echo ""
    echo "Usage: $0 [OPTIONS] [MODULES...]"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help          Show this help message"
    echo "  -l, --list          List available modules"
    echo "  -a, --all           Install all modules (default)"
    echo "  -v, --validate      Validate installation only"
    echo "  --dry-run           Show what would be done without executing"
    echo ""
    echo "MODULES:"
    echo "  shell              Shell configuration (zsh, aliases)"
    echo "  git                Git configuration and tools"
    echo "  dev                Development tools (homebrew packages)"
    echo "  ui                 UI enhancements (aerospace, ubersicht)"
    echo "  security           Security tools (1password, ssh)"
    echo ""
    echo "Examples:"
    echo "  $0                 # Install all modules"
    echo "  $0 shell git       # Install only shell and git modules"
    echo "  $0 --dry-run dev   # Show what dev module would do"
    echo "  $0 --validate      # Validate current installation"
}

# List available modules
list_modules() {
    echo "Available modules:"
    echo ""
    echo "  shell     - Zsh configuration with Powerlevel10k theme"
    echo "              - Custom aliases and environment variables"
    echo "              - NVM for Node.js version management"
    echo ""
    echo "  git       - Git configuration with 1Password SSH signing"
    echo "              - Custom Git aliases and hooks"
    echo "              - Global gitignore patterns"
    echo ""
    echo "  dev       - Homebrew and essential development packages"
    echo "              - Command-line tools (bat, gh, lazygit, neovim)"
    echo "              - Language runtimes and development utilities"
    echo ""
    echo "  ui        - AeroSpace tiling window manager"
    echo "              - Übersicht system monitoring widgets"
    echo "              - Custom application workspace assignments"
    echo ""
    echo "  security  - 1Password SSH agent configuration"
    echo "              - SSH key management and Git signing"
    echo "              - Secure credential handling"
}

# Validate installation
validate_installation() {
    log_info "Validating modular dotfiles installation..."
    echo ""
    
    local errors=0
    
    # Check shell module
    echo "Shell Module:"
    if [ -f "$HOME/.zshrc" ]; then
        log_success "  ✓ Zsh configuration"
    else
        log_error "  ✗ Zsh configuration"
        ((errors++))
    fi
    
    if [ -d "$HOME/.nvm" ]; then
        log_success "  ✓ NVM"
    else
        log_warning "  ⚠ NVM (may need terminal restart)"
    fi
    
    echo ""
    echo "Git Module:"
    if [ -f "$HOME/.gitconfig" ]; then
        log_success "  ✓ Git configuration"
    else
        log_error "  ✗ Git configuration"
        ((errors++))
    fi
    
    if command -v git > /dev/null; then
        log_success "  ✓ Git binary"
    else
        log_error "  ✗ Git binary"
        ((errors++))
    fi
    
    echo ""
    echo "Development Module:"
    if command -v brew > /dev/null; then
        log_success "  ✓ Homebrew"
    else
        log_error "  ✗ Homebrew"
        ((errors++))
    fi
    
    if command -v stow > /dev/null; then
        log_success "  ✓ GNU Stow"
    else
        log_error "  ✗ GNU Stow"
        ((errors++))
    fi
    
    echo ""
    echo "UI Module:"
    if [ -f "$HOME/.aerospace.toml" ]; then
        log_success "  ✓ AeroSpace configuration"
    else
        log_error "  ✗ AeroSpace configuration"
        ((errors++))
    fi
    
    if [ -d "$HOME/Library/Application Support/Übersicht/widgets" ]; then
        log_success "  ✓ Übersicht widgets"
    else
        log_warning "  ⚠ Übersicht widgets (app may not be installed)"
    fi
    
    echo ""
    echo "Security Module:"
    if [ -f "$HOME/.ssh/config" ]; then
        log_success "  ✓ SSH configuration"
    else
        log_error "  ✗ SSH configuration"
        ((errors++))
    fi
    
    echo ""
    if [ $errors -eq 0 ]; then
        log_success "All critical components validated successfully!"
        return 0
    else
        log_warning "Found $errors issues. Run 'make' to fix missing components."
        return 1
    fi
}

# Install specific module
install_module() {
    local module=$1
    local dry_run=${2:-false}
    
    case $module in
        shell)
            log_info "Installing shell module..."
            if [ "$dry_run" = true ]; then
                echo "  Would install: Zsh configuration, aliases, NVM"
                echo "  Would run: make dependencies (NVM portion)"
                echo "  Would stow: zshrc, zshenv, zaliases"
            else
                make dependencies
                log_success "Shell module installed"
            fi
            ;;
        git)
            log_info "Installing git module..."
            if [ "$dry_run" = true ]; then
                echo "  Would install: Git configuration and tools"
                echo "  Would stow: gitconfig, gitignore"
            else
                # Git is typically installed via development module
                log_success "Git module prepared (installed via dev module)"
            fi
            ;;
        dev)
            log_info "Installing development module..."
            if [ "$dry_run" = true ]; then
                echo "  Would install: Homebrew and packages"
                echo "  Would run: make dependencies && make install"
            else
                make dependencies
                make install
                log_success "Development module installed"
            fi
            ;;
        ui)
            log_info "Installing UI module..."
            if [ "$dry_run" = true ]; then
                echo "  Would install: AeroSpace and Übersicht configurations"
                echo "  Would stow: aerospace.toml, ubersicht widgets"
            else
                # UI components are stowed as part of the main stow target
                log_success "UI module prepared (configured via stow)"
            fi
            ;;
        security)
            log_info "Installing security module..."
            if [ "$dry_run" = true ]; then
                echo "  Would install: SSH and 1Password configurations"
                echo "  Would stow: ssh/config"
            else
                # Security configs are stowed as part of the main stow target
                log_success "Security module prepared (configured via stow)"
            fi
            ;;
        *)
            log_error "Unknown module: $module"
            echo "Run '$0 --list' to see available modules"
            return 1
            ;;
    esac
}

# Main execution
main() {
    local modules=()
    local dry_run=false
    local validate_only=false
    local install_all=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -l|--list)
                list_modules
                exit 0
                ;;
            -a|--all)
                install_all=true
                shift
                ;;
            -v|--validate)
                validate_only=true
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            shell|git|dev|ui|security)
                modules+=("$1")
                install_all=false
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Validate only mode
    if [ "$validate_only" = true ]; then
        validate_installation
        exit $?
    fi
    
    # Default to all modules if none specified
    if [ "$install_all" = true ] || [ ${#modules[@]} -eq 0 ]; then
        modules=("shell" "git" "dev" "ui" "security")
    fi
    
    # Show banner
    echo "=================================================="
    echo "     Modular Dotfiles Installation System"
    echo "=================================================="
    echo ""
    
    if [ "$dry_run" = true ]; then
        log_info "DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    log_info "Selected modules: ${modules[*]}"
    echo ""
    
    # Install each module
    for module in "${modules[@]}"; do
        install_module "$module" "$dry_run"
        echo ""
    done
    
    if [ "$dry_run" = false ]; then
        # Apply dotfiles if any module was installed
        log_info "Applying dotfiles configuration..."
        make stow
        
        echo ""
        log_success "Modular installation completed!"
        echo ""
        echo "Next steps:"
        echo "  1. Restart your terminal or run: source ~/.zshrc"
        echo "  2. Run '$0 --validate' to verify installation"
        echo "  3. Customize configurations as needed"
    fi
}

# Run main function with all arguments
main "$@"