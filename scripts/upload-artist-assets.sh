#!/usr/bin/env bash

# Upload Artist Assets Script
# Finds and uploads all cover.jpg, logo.png, and artist.jpg files for an artist
#
# Usage:
#   ./upload-artist-assets.sh "/Volumes/Eksternal/Audio/Metal/C/Cold Steel"
#   Or run without arguments to be prompted for path

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get script directory (works even when symlinked)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
GHU="$REPO_ROOT/ghu"

# Check if ghu exists
if [[ ! -x "$GHU" ]]; then
    echo -e "${RED}Error: Gupload script not found at: $GHU${NC}" >&2
    exit 1
fi

# Get artist path
ARTIST_PATH="${1:-}"

if [[ -z "$ARTIST_PATH" ]]; then
    echo -e "${CYAN}${BOLD}Upload Artist Assets${NC}\n"
    echo -e "${BLUE}Enter the artist path (e.g., /Volumes/Eksternal/Audio/Metal/C/Cold Steel):${NC}"
    read -p "Path: " ARTIST_PATH
    echo
fi

# Expand tilde and resolve path
ARTIST_PATH="${ARTIST_PATH/#\~/$HOME}"
ARTIST_PATH="$(cd "$(dirname "$ARTIST_PATH")" 2>/dev/null && pwd)/$(basename "$ARTIST_PATH")"

# Validate path
if [[ ! -d "$ARTIST_PATH" ]]; then
    echo -e "${RED}Error: Directory not found: $ARTIST_PATH${NC}" >&2
    exit 1
fi

ARTIST_NAME="$(basename "$ARTIST_PATH")"
echo -e "${CYAN}${BOLD}Uploading assets for: ${ARTIST_NAME}${NC}\n"
echo -e "${BLUE}Path: ${ARTIST_PATH}${NC}\n"

# Find all relevant image files
FILES=()
COVERS=()
LOGOS=()
ARTISTS=()

echo -e "${BLUE}Scanning for assets...${NC}"

# Find cover.jpg files (in album subdirectories)
while IFS= read -r -d '' file; do
    COVERS+=("$file")
done < <(find "$ARTIST_PATH" -type f -name "cover.jpg" -print0 2>/dev/null)

# Find logo.png files (in artist directory)
while IFS= read -r -d '' file; do
    LOGOS+=("$file")
done < <(find "$ARTIST_PATH" -maxdepth 1 -type f -name "logo.png" -print0 2>/dev/null)

# Find artist.jpg files (in artist directory)
while IFS= read -r -d '' file; do
    ARTISTS+=("$file")
done < <(find "$ARTIST_PATH" -maxdepth 1 -type f -name "artist.jpg" -print0 2>/dev/null)

# Combine all files
FILES=("${COVERS[@]}" "${LOGOS[@]}" "${ARTISTS[@]}")

# Display found files
echo -e "\n${BOLD}Found assets:${NC}"
echo -e "  ${GREEN}Covers:${NC} ${#COVERS[@]}"
for cover in "${COVERS[@]}"; do
    rel_path="${cover#$ARTIST_PATH/}"
    echo -e "    - ${rel_path}"
done

echo -e "  ${GREEN}Logos:${NC} ${#LOGOS[@]}"
for logo in "${LOGOS[@]}"; do
    echo -e "    - $(basename "$logo")"
done

echo -e "  ${GREEN}Artist images:${NC} ${#ARTISTS[@]}"
for artist in "${ARTISTS[@]}"; do
    echo -e "    - $(basename "$artist")"
done

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo -e "\n${YELLOW}No assets found to upload.${NC}"
    exit 0
fi

echo -e "\n${BOLD}Total files to upload: ${#FILES[@]}${NC}\n"

# Confirm before uploading
read -p "$(echo -e ${YELLOW}Upload these ${#FILES[@]} files? [y/N]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Cancelled.${NC}"
    exit 0
fi

echo -e "\n${BLUE}Uploading files...${NC}\n"

# Upload all files
"$GHU" "${FILES[@]}"

EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "\n${GREEN}✓ Successfully uploaded ${#FILES[@]} files!${NC}"
else
    echo -e "\n${RED}✗ Some files failed to upload (exit code: $EXIT_CODE)${NC}" >&2
    exit $EXIT_CODE
fi
