# dotfiles

This repository holds my personal dotfiles, which are configuration files for various applications and tools on my Linux system.

These files are managed using the `stow` tool to ensure proper linking and organization.

## Requirements

* Ubuntu Linux system
* Zsh shell
* `stow` package installed (`brew install stow`)

## Usage

1. Clone the repository

   ```bash
   cd ~ && gh repo clone dotfiles
   ```

2. Install dotfiles

   ```bash
   cd ~/dotfiles && stow -v -R dotfiles/
   ```

3. Setup VS Code (Cross-Platform)

   ```bash
   chmod +x ~/dotfiles/dotfiles/scripts/create_vscode_symlinks.zsh
   ~/dotfiles/dotfiles/scripts/create_vscode_symlinks.zsh
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
