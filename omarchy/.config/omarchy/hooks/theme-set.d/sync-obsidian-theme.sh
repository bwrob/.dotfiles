#!/usr/bin/env bash
# Sync active Omarchy theme to Obsidian vaults
set -euo pipefail

if command -v omarchy &>/dev/null; then
    omarchy theme set obsidian 2>/dev/null || true
fi
