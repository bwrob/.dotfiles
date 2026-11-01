#!/usr/bin/env bash
# Automatically switches to power-saver profile and caps brightness on low battery
set -euo pipefail

PERCENT="${1:-}"

# Switch to power-saver profile
if command -v powerprofilesctl &>/dev/null; then
    powerprofilesctl set power-saver 2>/dev/null || true
fi

# Lower brightness to 30% if currently higher
if command -v brightnessctl &>/dev/null; then
    CURRENT=$(brightnessctl get)
    MAX=$(brightnessctl max)
    TARGET=$(( MAX * 30 / 100 ))
    if (( CURRENT > TARGET )); then
        brightnessctl set 30% 2>/dev/null || true
    fi
fi
