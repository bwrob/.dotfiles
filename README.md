# dotfiles

This repository holds my personal dotfiles, which are configuration files for various applications and tools on my Linux system.

These files are managed using the `stow` tool to ensure proper linking and organization.

## Requirements

* Ubuntu Linux system
* Zsh shell
* `stow` package installed (`brew install stow`)

## Usage

1. **Clone the repository**

   ```bash
   cd ~ && git clone https://github.com/bwrob/dotfiles.git .dotfiles
   ```

2. **Run the setup script (macOS or Ubuntu/WSL)**

   This will install Homebrew, all dependencies via the `Brewfile`, and set up your shell.

   ```bash
   cd ~/.dotfiles
   chmod +x scripts/shell_setup.sh
   ./scripts/shell_setup.sh
   ```

3. **Install dotfiles using `stow`**

   ```bash
   # Link all packages (bat, helix, homebrew, etc.)
   stow -v -R bat fastfetch git helix micro shell vscode wezterm yazi zellij homebrew
   ```

4. **Setup VS Code Symlinks**

   ```bash
   chmod +x scripts/create_vscode_symlinks.zsh
   ./scripts/create_vscode_symlinks.zsh
   ```


**Updating dotfiles:**

1. **Pull changes from the remote repository:**

   ```bash
   cd ~/.dotfiles
   git pull
   ```

2. **Update links using `stow`:**

   ```bash
   stow -v -R  dotfiles/
   ```

**Uninstalling dotfiles:**

1. **Remove links using `stow`:**

   ```bash
   stow -v -R --delete dotfiles/
   ```

2. **Delete the repository:**

   ```bash
   rm -rf ~/.dotfiles
   ```
