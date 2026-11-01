#!/usr/bin/env bash
# update-packages.sh - Diff locally installed packages vs dotfiles and propose additions
set -euo pipefail

# ANSI color codes
BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
GRAY='\033[90m'
NC='\033[0m' # No Color

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Compare packages installed locally on Arch/Omarchy against those tracked in dotfiles,
display a diff, and interactively prompt to add new packages to dotfiles.

OPTIONS:
  -d, --diff         Show the diff only without prompting
  -a, --all          Include Omarchy base ISO and hardware/firmware packages in diff
  -y, --yes          Non-interactive: automatically accept and add all candidate packages
  -f, --file PATH    Specify custom packages.txt path (default: auto-detected in dotfiles)
  -h, --help         Show this help message

EXAMPLES:
  $(basename "$0")              # Interactive prompt for user-installed packages
  $(basename "$0") --diff       # Just inspect differences
  $(basename "$0") --all        # Include base system packages in inspection
EOF
    exit 0
}

# Defaults
MODE="interactive"
INCLUDE_BASE=false
CUSTOM_FILE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--diff)
            MODE="diff"
            shift
            ;;
        -a|--all)
            INCLUDE_BASE=true
            shift
            ;;
        -y|--yes)
            MODE="auto"
            shift
            ;;
        -f|--file)
            CUSTOM_FILE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}" >&2
            usage
            ;;
    esac
done

# Locate packages.txt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "$CUSTOM_FILE" ]]; then
    PACKAGES_FILE="$CUSTOM_FILE"
elif [[ -f "$SCRIPT_DIR/packages.txt" ]]; then
    PACKAGES_FILE="$SCRIPT_DIR/packages.txt"
elif [[ -f "$SCRIPT_DIR/../omarchy/packages.txt" ]]; then
    PACKAGES_FILE="$SCRIPT_DIR/../omarchy/packages.txt"
elif [[ -f "$HOME/dev/.dotfiles/omarchy/packages.txt" ]]; then
    PACKAGES_FILE="$HOME/dev/.dotfiles/omarchy/packages.txt"
elif [[ -f "$HOME/.dotfiles/omarchy/packages.txt" ]]; then
    PACKAGES_FILE="$HOME/.dotfiles/omarchy/packages.txt"
else
    echo -e "${RED}Error: Could not locate omarchy/packages.txt.${NC}" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "$PACKAGES_FILE")/.." && pwd)"

echo -e "${BOLD}${CYAN}=== Dotfiles Package Synchronizer ===${NC}"
echo -e "${GRAY}Target list: ${PACKAGES_FILE}${NC}"

# 1. Read tracked packages from dotfiles
TRACKED_PKGS=()
if [[ -f "$PACKAGES_FILE" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        if [[ -n "$line" && ! "$line" =~ ^# ]]; then
            TRACKED_PKGS+=("$line")
        fi
    done < "$PACKAGES_FILE"
fi

# 2. Get explicitly installed local packages (for candidate additions)
# and all installed packages (for checking if tracked packages exist)
if ! command -v pacman &>/dev/null; then
    echo -e "${RED}Error: pacman not found. This tool requires Arch Linux / Omarchy.${NC}" >&2
    exit 1
fi

mapfile -t INSTALLED_PKGS < <(pacman -Qqe | sort -u)
mapfile -t ALL_INSTALLED_PKGS < <(pacman -Qq | sort -u)

# 3. Discover Omarchy base / hardware packages to ignore by default
OMARCHY_BASE_PKGS=()
for base_file in /usr/share/omarchy/install/*.packages; do
    if [[ -f "$base_file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            line="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
            if [[ -n "$line" && ! "$line" =~ ^# ]]; then
                OMARCHY_BASE_PKGS+=("$line")
            fi
        done < "$base_file"
    fi
done

# Known hardware/kernel/base patterns
is_system_base() {
    local pkg="$1"
    if [[ "$INCLUDE_BASE" == true ]]; then
        return 1
    fi
    # Check in omarchy base packages
    for b in "${OMARCHY_BASE_PKGS[@]}"; do
        if [[ "$b" == "$pkg" ]]; then
            return 0
        fi
    done
    # Regex match for kernel/firmware/distro essentials
    if [[ "$pkg" =~ ^(linux-asahi.*|uboot-asahi.*|m1n1.*|asahi-.*|speakersafetyd.*|archlinuxarm-keyring|omarchy-keyring|omarchy-mac-keyring|omarchy-dev|omarchy-settings-dev|base|base-devel|netctl|dhcpcd|grub|sudo|which)$ ]]; then
        return 0
    fi
    return 1
}

# 4. Compute differences
CANDIDATES=()
BASE_SKIPPED=0
MISSING_ON_SYSTEM=()

# Convert arrays to associative map for fast lookup
declare -A TRACKED_MAP
for p in "${TRACKED_PKGS[@]}"; do
    TRACKED_MAP["$p"]=1
done

declare -A ALL_INSTALLED_MAP
for p in "${ALL_INSTALLED_PKGS[@]}"; do
    ALL_INSTALLED_MAP["$p"]=1
done

for p in "${INSTALLED_PKGS[@]}"; do
    if [[ -z "${TRACKED_MAP[$p]:-}" ]]; then
        if is_system_base "$p"; then
            ((BASE_SKIPPED++)) || true
        else
            CANDIDATES+=("$p")
        fi
    fi
done

for p in "${TRACKED_PKGS[@]}"; do
    # Also handle aliases like mise -> mise-bin
    if [[ -z "${ALL_INSTALLED_MAP[$p]:-}" && -z "${ALL_INSTALLED_MAP["${p}-bin"]:-}" ]]; then
        MISSING_ON_SYSTEM+=("$p")
    fi
done

# 5. Display Status / Diff Summary
echo ""
echo -e "${BOLD}Status Summary:${NC}"
echo -e "  Tracked in dotfiles:   ${GREEN}${#TRACKED_PKGS[@]}${NC}"
echo -e "  Installed locally:     ${GREEN}${#INSTALLED_PKGS[@]}${NC}"
echo -e "  New local additions:   ${YELLOW}${#CANDIDATES[@]}${NC} candidates"
if [[ "$BASE_SKIPPED" -gt 0 ]]; then
    echo -e "  Base system packages:  ${GRAY}${BASE_SKIPPED} omitted (run with --all to inspect)${NC}"
fi

if [[ ${#MISSING_ON_SYSTEM[@]} -gt 0 ]]; then
    echo -e "  Tracked but not on OS: ${RED}${#MISSING_ON_SYSTEM[@]}${NC} (${MISSING_ON_SYSTEM[*]})"
fi
echo ""

if [[ ${#CANDIDATES[@]} -eq 0 ]]; then
    echo -e "${GREEN}✓ All installed user packages are already tracked in dotfiles!${NC}"
    exit 0
fi

# If diff mode only, list and exit
if [[ "$MODE" == "diff" ]]; then
    echo -e "${BOLD}Candidate packages not yet in dotfiles:${NC}"
    for pkg in "${CANDIDATES[@]}"; do
        info=""
        if command -v expac &>/dev/null; then
            info="$(expac -Q "%v: %d" "$pkg" 2>/dev/null || true)"
        fi
        if [[ -n "$info" ]]; then
            echo -e "  ${YELLOW}+${NC} ${BOLD}${pkg}${NC} (${info})"
        else
            echo -e "  ${YELLOW}+${NC} ${BOLD}${pkg}${NC}"
        fi
    done
    exit 0
fi

# 6. Interactive / Auto Addition
APPROVED=()
ADD_ALL_REMAINING=false

echo -e "${BOLD}Proposing additions to ${PACKAGES_FILE}:${NC}"
echo -e "${GRAY}(Options: [y]es, [n]o, [a]ll remaining, [q]uit)${NC}"
echo ""

for pkg in "${CANDIDATES[@]}"; do
    # Get package info
    ver=""
    desc=""
    if command -v expac &>/dev/null; then
        ver="$(expac -Q "%v" "$pkg" 2>/dev/null || true)"
        desc="$(expac -Q "%d" "$pkg" 2>/dev/null || true)"
    fi
    if [[ -z "$desc" ]]; then
        desc="$(pacman -Qi "$pkg" 2>/dev/null | grep -E '^Description' | cut -d: -f2- | sed 's/^[[:space:]]*//' || true)"
        ver="$(pacman -Qi "$pkg" 2>/dev/null | grep -E '^Version' | cut -d: -f2- | sed 's/^[[:space:]]*//' || true)"
    fi

    if [[ "$MODE" == "auto" || "$ADD_ALL_REMAINING" == true ]]; then
        echo -e "  ${GREEN}+ Adding${NC} ${BOLD}${pkg}${NC} (${ver:-installed})"
        APPROVED+=("$pkg")
        continue
    fi

    echo -e "${CYAN}------------------------------------------------------------${NC}"
    echo -e "Package: ${BOLD}${GREEN}${pkg}${NC} ${GRAY}(${ver})${NC}"
    if [[ -n "$desc" ]]; then
        echo -e "Summary: ${desc}"
    fi

    while true; do
        read -r -p "Add '$pkg' to dotfiles? [y/n/a/q]: " choice
        case "${choice,,}" in
            y|yes)
                APPROVED+=("$pkg")
                break
                ;;
            n|no|"")
                break
                ;;
            a|all)
                APPROVED+=("$pkg")
                ADD_ALL_REMAINING=true
                break
                ;;
            q|quit)
                echo -e "\n${YELLOW}Quitting early.${NC}"
                break 2
                ;;
            *)
                echo -e "Please answer 'y' (yes), 'n' (no), 'a' (add all remaining), or 'q' (quit)."
                ;;
        esac
    done
done

# 7. Write approved packages back to packages.txt
if [[ ${#APPROVED[@]} -eq 0 ]]; then
    echo -e "\n${YELLOW}No packages were selected for addition.${NC}"
    exit 0
fi

echo ""
echo -e "${BOLD}Saving ${#APPROVED[@]} new packages to ${PACKAGES_FILE}...${NC}"

# Read existing comments and packages
HEADER_COMMENTS=()
ALL_PKGS=()

if [[ -f "$PACKAGES_FILE" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^# ]]; then
            HEADER_COMMENTS+=("$line")
        else
            trimmed="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
            if [[ -n "$trimmed" ]]; then
                ALL_PKGS+=("$trimmed")
            fi
        fi
    done < "$PACKAGES_FILE"
fi

# Append approved
ALL_PKGS+=("${APPROVED[@]}")

# Sort unique case-insensitive
mapfile -t SORTED_PKGS < <(printf "%s\n" "${ALL_PKGS[@]}" | sort -u -f)

# Write out atomically
TMP_FILE="$(mktemp "${PACKAGES_FILE}.tmp.XXXXXX")"
if [[ ${#HEADER_COMMENTS[@]} -gt 0 ]]; then
    for c in "${HEADER_COMMENTS[@]}"; do
        echo "$c" >> "$TMP_FILE"
    done
else
    echo "# Omarchy & Arch packages managed by dotfiles" >> "$TMP_FILE"
fi

for p in "${SORTED_PKGS[@]}"; do
    echo "$p" >> "$TMP_FILE"
done

mv "$TMP_FILE" "$PACKAGES_FILE"

echo -e "${GREEN}✓ Successfully updated ${PACKAGES_FILE}!${NC}"
echo -e "Added packages: ${BOLD}${APPROVED[*]}${NC}"

if command -v git &>/dev/null && git -C "$REPO_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
    echo ""
    echo -e "${BOLD}Git diff preview:${NC}"
    git -C "$REPO_DIR" diff "$PACKAGES_FILE" || true
fi
