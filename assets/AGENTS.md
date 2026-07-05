<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# assets

## Purpose
Static assets used during machine bootstrap. The Makefile references this directory to set the desktop wallpaper and the iTerm2 color schemes are imported manually.

## Key Files

| File | Description |
|------|-------------|
| `wallpaper.heic` | Primary wallpaper (set by `make wallpaper` via osascript) |
| `wallpaper_dark.png` | Dark-mode wallpaper variant |
| `wallpaper_light.png` | Light-mode wallpaper variant |
| `catppuccin-macchiato.itermcolors` | Catppuccin Macchiato iTerm2 color scheme |
| `catppuccin-latte.itermcolors` | Catppuccin Latte (light) iTerm2 color scheme |

## For AI Agents

### Working In This Directory
- Wallpaper files are referenced by absolute path in the Makefile — keep filenames stable
- `.itermcolors` files are XML property lists; import them via iTerm2 > Preferences > Profiles > Colors > Import

### Common Patterns
- Catppuccin theme is used across the whole environment (iTerm2, Neovim) for consistency

<!-- MANUAL: -->
