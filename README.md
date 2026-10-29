# .dotfiles

Personal dotfiles organized into a shared `common/` layer plus clean, per-OS Stow packages:

```text
.dotfiles/
├── common/     # Shared tool configs (VS Code, Helix, Yazi, Zellij, Bat, Lazygit, Tmux, RTK, Starship)
├── macos/      # macOS (Apple Silicon Homebrew, WezTerm, Zsh, Gitconfig)
├── ubuntu/     # Native Ubuntu Linux (Linuxbrew, WezTerm, Zsh, Bash, Gitconfig)
├── win-wsl/    # Windows + WSL2 Ubuntu (WSL Zsh/Linuxbrew + Windows-host WezTerm & Git Bash)
└── omarchy/    # Omarchy Arch/Hyprland desktop + custom Van Gogh "Almond Blossom" theme
```

## Quick Start

1. **Clone the repository:**

   ```bash
   git clone https://github.com/bwrob/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the setup script for your OS:**

   ```bash
   # macOS
   ./macos/setup.sh

   # Ubuntu
   ./ubuntu/setup.sh

   # Windows WSL (Ubuntu)
   ./win-wsl/setup.sh

   # Omarchy (Arch + Hyprland)
   ./omarchy/setup.sh
   ```

## Re-stowing Configs Only

Each setup stows `common` alongside the target OS folder:

```bash
stow -d ~/.dotfiles -t ~ -v -R common macos
stow -d ~/.dotfiles -t ~ -v -R common ubuntu
stow -d ~/.dotfiles -t ~ -v -R common win-wsl
stow -d ~/.dotfiles -t ~ -v -R common omarchy
```

Inside each shell environment, the `dotstow` alias re-stows `common` + the active OS profile automatically.
