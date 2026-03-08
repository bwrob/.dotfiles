#!/bin/zsh

# Get the repository name and settings flavor as arguments
echo "Enter a source file name:"
read repo_name
echo "Enter a settings flavor:"
read settings_flavour

src_settings="/home/bwrob/repos/dotfiles/.vscode.$settings_flavour/*.json"
dest_settings="/home/bwrob/repos/$repo_name/.vscode/"
echo "Creating symbolic links for $src_settings in $dest_settings"

# Create the .vscode folder if it doesn't exist
mkdir -p $dest_settings

# Create symbolic links for each JSON file
ln -Pf $src_settings $dest_settings
