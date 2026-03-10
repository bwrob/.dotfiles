# -- TODO: Dotfiles Enhancements --

This document outlines the planned improvements to make these dotfiles more comprehensive, cohesive, and power-user friendly.

## 1. Modern Shell Architecture (Zsh Optimization)
**Goal:** Achieve near-instant shell startup and more manageable plugin handling.
- **Switch to Antidote:** Replace manual plugin sourcing with [Antidote](https://getantidote.github.io/), a static plugin manager that compiles plugins into a single, fast-loading script.
- **Centralized Plugin List:** Use a `.zsh_plugins.txt` file in the `shell/` directory to manage all Zsh plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`, etc.).
- **Lazy Loading:** Implement lazy loading for heavy tools like `nvm`, `pyenv`, or `rvm` if they are ever added.
- **Environment Caching:** Replace slow calls like `$(brew --prefix)` with static environment variables set during the initial installation.

## 2. Unified Theming (Dracula Cohesion)
**Goal:** Ensure every tool looks identical and follows the Dracula color palette.
- **Theming Tool:** Consider using a tool like [Base16](http://chriskempson.com/projects/base16/) or a shared color definition file.
- **Specific Targets:** 
    - **WezTerm:** Ensure it uses the exact same hex codes as the rest of the tools.
    - **Zellij:** Explicitly define a Dracula theme in `zellij/config.kdl`.
    - **Yazi:** Ensure the file manager theme aligns with the terminal's Dracula palette.
    - **LS_COLORS:** Use a Dracula-compatible `LS_COLORS` (often via `vivid`).

## 3. Smart Tool Integration
**Goal:** Create a "force multiplier" effect where tools work together.
- **Helix + Zellij:** Add scripts/aliases to open Helix files in a new Zellij pane or swap between them effortlessly.
- **Lazygit:** Add `lazygit` to the `Brewfile` and configure it with a Dracula theme to provide a powerful TUI for Git operations.
- **FZF Tab:** Integrate `fzf-tab` for Zsh to provide fuzzy completion for everything (paths, process IDs, git branches).

## 4. Automated Symlink Safety (Beyond Basic Stow)
**Goal:** Handle complex, platform-specific config paths without manual scripts.
- **XDG Compliance:** Move more configurations to follow the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) where possible.
- **Cross-Platform Mapping:** Use a more advanced tool like `chezmoi` if the differences between macOS, Linux, and Windows/WSL paths become too cumbersome for basic `stow`.

## 5. System Cleanup & Maintenance
**Goal:** Keep the system lean and reproducible.
- **Brew Cleanup:** Periodically run `brew bundle cleanup` to remove unlisted packages.
- **Dotfiles Doctor:** Create a `scripts/doctor.sh` to verify that all symlinks, dependencies, and environment variables are correctly set.
