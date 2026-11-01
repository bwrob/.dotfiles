#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$HOME/.local/state/omarchy/current/theme"
ZEN_CSS_TARGET="$THEME_DIR/zen-userChrome.css"
ZEN_DIR="$HOME/.config/zen"

if [[ ! -f "$ZEN_CSS_TARGET" ]]; then
    exit 0
fi

if [[ ! -d "$ZEN_DIR" ]]; then
    exit 0
fi

pref_line='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'

for profile_dir in "$ZEN_DIR"/*/; do
    if [[ -d "$profile_dir" && ( "$profile_dir" == *"Default"* || -f "$profile_dir/prefs.js" ) ]]; then
        chrome_dir="${profile_dir}chrome"
        mkdir -p "$chrome_dir"
        
        # Link userChrome.css to dynamic theme
        ln -sf "$ZEN_CSS_TARGET" "$chrome_dir/userChrome.css"
        
        # Ensure user.js enables custom stylesheets
        user_js="${profile_dir}user.js"
        if [[ ! -f "$user_js" ]] || ! grep -qF "$pref_line" "$user_js"; then
            echo "$pref_line" >> "$user_js"
        fi
    fi
done
