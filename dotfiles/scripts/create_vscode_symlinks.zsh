#!/bin/bash

# Detect OS and set VS Code User directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VSCODE_USER_DIR="$HOME/.config/Code/User"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows (Git Bash / Cygwin)
    if command -v cygpath &>/dev/null && [[ -n "$APPDATA" ]]; then
        VSCODE_USER_DIR="$(cygpath "$APPDATA")/Code/User"
    else
        VSCODE_USER_DIR="$HOME/AppData/Roaming/Code/User"
    fi
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Ensure the directory exists
mkdir -p "$VSCODE_USER_DIR"

# Path to this dotfiles repository
DOTFILES_DIR="$HOME/.dotfiles"

# Files to link
files=("settings.json" "keybindings.json" "extensions.json" "launch.json")

echo "Linking VS Code configuration to: $VSCODE_USER_DIR"

for file in "${files[@]}"; do
    TARGET_FILE="$VSCODE_USER_DIR/$file"
    SOURCE_FILE="$DOTFILES_DIR/vscode/$file"

    if [[ -f "$SOURCE_FILE" ]]; then
        # Handle existing target
        if [[ -e "$TARGET_FILE" ]]; then
            if [[ -L "$TARGET_FILE" ]]; then
                # If it's already a symlink, just remove it
                rm "$TARGET_FILE"
            else
                # If it's a real file, back it up
                mv "$TARGET_FILE" "${TARGET_FILE}.bak"
                echo "  [!] Backed up existing $file to ${file}.bak"
            fi
        fi

        # Create the new symlink
        ln -s "$SOURCE_FILE" "$TARGET_FILE"

        if [[ $? -eq 0 ]]; then
            echo "  [✔] Linked $file"
        else
            echo "  [✘] Failed to link $file"
        fi
    else
        echo "  [ ] Skipping $file (not found in $DOTFILES_DIR/vscode/)"
    fi
done

echo "Done!"
