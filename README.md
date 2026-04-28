# DOTFILES

A comprehensive dotfiles setup for macOS with enhanced bootstrap system.

## Quick Installation

```zsh
# First, install dev tools (such as make)
$ xcode-select --install

# Then install all dependencies and dotfiles
$ make
```

## Fonts

- **Cascadia Code:** Install the Cascadia Code fonts on macOS with:

```
# Install for current user
$ make fonts-cascadia

# Or install system-wide (requires sudo)
$ bash ./home/bin/install-cascadia-macos.sh --system
```
