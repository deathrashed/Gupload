#!/usr/bin/env bash

# Gupload Interactive Menu
# Interactive terminal menu for Gupload operations

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get script directory (works even when symlinked)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
GHU="$REPO_ROOT/ghu"
PYTHON_SCRIPT="$REPO_ROOT/scripts/ghuploader.py"
LIST_ARTISTS_SCRIPT="$SCRIPT_DIR/list-repo-artists.py"
UPLOAD_ASSETS_SCRIPT="$SCRIPT_DIR/upload-artist-assets.sh"
LOG="/tmp/gupload.log"
CONFIG="$HOME/.config/ghuploader/config.json"

# Helper functions
print_header() {
    clear
    echo -e "\n${CYAN}${BOLD}═══════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}           Gupload - File Upload Tool${NC}"
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════${NC}\n"
}

print_menu() {
    echo -e "${BOLD}Main Menu:${NC}\n"
    echo -e "  ${GREEN}1)${NC}  Upload Files"
    echo -e "  ${GREEN}2)${NC}  Browse Repo & Add Files"
    echo -e "  ${GREEN}3)${NC}  Audio Tools"
    echo -e "  ${GREEN}4)${NC}  Configure Options"
    echo -e "  ${GREEN}5)${NC}  View Logs"
    echo -e "  ${GREEN}0)${NC}  Exit\n"
    echo -e "${YELLOW}Press 'q' in submenus to go back${NC}\n"
}

confirm() {
    local prompt="$1"
    local response
    read -p "$(echo -e ${YELLOW}"$prompt [y/N]: "${NC})" -n 1 -r response
    echo
    [[ $response =~ ^[Yy]$ ]]
}

wait_for_q() {
    echo -e "\n${CYAN}Press 'q' + Enter to go back...${NC}"
    local response
    read -r response
    [[ "$response" != "q" ]]
}

check_ghu() {
    if [[ ! -x "$GHU" ]]; then
        echo -e "${RED}Error: Gupload script not found at: $GHU${NC}" >&2
        return 1
    fi
    return 0
}

check_fzf() {
    if ! command -v fzf &> /dev/null; then
        return 1
    fi
    return 0
}

get_config_value() {
    local key="$1"
    python3 -c "import json, sys, os; config = json.load(open('$CONFIG')) if os.path.exists('$CONFIG') else {}; print(config.get('$key', ''))" 2>/dev/null || echo ""
}

set_config_value() {
    local key="$1"
    local value="$2"
    python3 <<PYTHON
import json
import os

config_file = '$CONFIG'
os.makedirs(os.path.dirname(config_file), exist_ok=True)

if os.path.exists(config_file):
    with open(config_file, 'r') as f:
        config = json.load(f)
else:
    config = {}

config['$key'] = $value

with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)
PYTHON
}

# Upload Files Submenu
upload_files_submenu() {
    while true; do
        print_header
        echo -e "${BOLD}Upload Files${NC}\n"
        echo -e "  ${GREEN}1)${NC}  Single file (fzf search)"
        echo -e "  ${GREEN}2)${NC}  Single file (manual path)"
        echo -e "  ${GREEN}3)${NC}  Multiple files"
        echo -e "  ${GREEN}4)${NC}  From Finder selection"
        echo -e "  ${GREEN}5)${NC}  Folder/archive"
        echo -e "  ${GREEN}q)${NC}  Back to main menu\n"
        
        read -p "Choose option: " option
        echo
        
        case $option in
            1)
                upload_with_fzf
                ;;
            2)
                upload_single_manual
                ;;
            3)
                upload_multiple_files
                ;;
            4)
                upload_finder_selection
                ;;
            5)
                upload_folder
                ;;
            q)
                return 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# Upload with fzf
upload_with_fzf() {
    print_header
    echo -e "${BOLD}Upload File (fzf search)${NC}\n"
    
    if ! check_fzf; then
        echo -e "${RED}fzf is not installed.${NC}"
        echo -e "${BLUE}Install with: brew install fzf${NC}\n"
        wait_for_q
        return
    fi
    
    if ! check_ghu; then
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Searching files... (may take a moment)${NC}\n"
    echo -e "${YELLOW}Enter starting directory (or press Enter for $HOME):${NC}"
    read -e start_dir
    
    # Default to home directory
    [[ -z "$start_dir" ]] && start_dir="$HOME"
    start_dir="${start_dir/#\~/$HOME}"
    
    if [[ ! -d "$start_dir" ]]; then
        echo -e "${RED}Error: Directory not found: $start_dir${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Searching from: $start_dir${NC}\n"
    
    # Find all files and use fzf with better search
    local file_path
    file_path=$(find "$start_dir" -type f 2>/dev/null | \
        fzf \
        --height 40% \
        --border \
        --header="Select file to upload (Ctrl+C or ESC to cancel, '/' to search)" \
        --preview="file {} 2>/dev/null && echo && ls -lh {} 2>/dev/null" \
        --preview-window=down:5 \
        --bind="ctrl-/:toggle-preview" \
        2>&1 || echo "")
    
    if [[ -z "$file_path" ]]; then
        return 0
    fi
    
    upload_with_custom_naming "$file_path"
}

# Upload single file manual
upload_single_manual() {
    print_header
    echo -e "${BOLD}Upload File (manual path)${NC}\n"
    
    if ! check_ghu; then
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Enter file path:${NC}"
    read -e file_path
    
    if [[ -z "$file_path" ]] || [[ "$file_path" == "q" ]]; then
        return 0
    fi
    
    # Expand tilde
    file_path="${file_path/#\~/$HOME}"
    
    if [[ ! -f "$file_path" ]]; then
        echo -e "${RED}Error: File not found: $file_path${NC}\n"
        wait_for_q
        return
    fi
    
    upload_with_custom_naming "$file_path"
}

# Upload with custom naming options
upload_with_custom_naming() {
    local file_path="$1"
    
    print_header
    echo -e "${BOLD}Upload: $(basename "$file_path")${NC}\n"
    
    echo -e "${BLUE}File:${NC} $file_path"
    echo -e "${BLUE}Size:${NC} $(du -h "$file_path" | cut -f1)"
    echo
    
    echo -e "${BOLD}Naming Options:${NC}"
    echo -e "  ${GREEN}1)${NC}  Default (auto-generated from path/metadata)"
    echo -e "  ${GREEN}2)${NC}  Custom filename only"
    echo -e "  ${GREEN}3)${NC}  Custom path with folders"
    echo -e "  ${GREEN}q)${NC}  Cancel\n"
    
    read -p "Choose option: " option
    echo
    
    case $option in
        1)
            echo -e "${BLUE}Uploading with default naming...${NC}\n"
            "$GHU" "$file_path"
            echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
            wait_for_q
            ;;
        2)
            read -e -p "Enter custom filename (with extension): " custom_name
            if [[ -n "$custom_name" ]] && [[ "$custom_name" != "q" ]]; then
                local dir=$(dirname "$file_path")
                local temp_file="$(mktemp -t gupload-XXXXXXXXXX)_$custom_name"
                cp "$file_path" "$temp_file"
                echo -e "\n${BLUE}Uploading with custom name: $custom_name${NC}\n"
                "$GHU" "$temp_file"
                rm -f "$temp_file"
                echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
            fi
            wait_for_q
            ;;
        3)
            read -e -p "Enter custom path (e.g., Scripts/MyTool/script.sh or MyFolder/myfile.txt): " custom_path
            if [[ -n "$custom_path" ]] && [[ "$custom_path" != "q" ]]; then
                # For now, upload with custom name to approximate path structure
                # Full custom path support would need Python script modification
                local dir=$(dirname "$file_path")
                local filename=$(basename "$custom_path")
                local temp_file="$(mktemp -t gupload-XXXXXXXXXX)_$filename"
                cp "$file_path" "$temp_file"
                echo -e "\n${YELLOW}Note: Custom folder paths are approximated by filename${NC}"
                echo -e "${BLUE}Uploading to path: $custom_path${NC}\n"
                "$GHU" "$temp_file"
                rm -f "$temp_file"
                echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
            fi
            wait_for_q
            ;;
        q)
            return 0
            ;;
    esac
}

# Upload multiple files
upload_multiple_files() {
    print_header
    echo -e "${BOLD}Upload Multiple Files${NC}\n"
    
    if ! check_ghu; then
        wait_for_q
        return
    fi
    
    echo -e "${YELLOW}Enter file paths (one per line, empty line to finish, 'q' to cancel):${NC}\n"
    
    files=()
    while true; do
        read -e file_path
        if [[ -z "$file_path" ]]; then
            break
        fi
        if [[ "$file_path" == "q" ]]; then
            return 0
        fi
        
        file_path="${file_path/#\~/$HOME}"
        
        if [[ -f "$file_path" ]]; then
            files+=("$file_path")
            echo -e "${GREEN}✓ Added: $(basename "$file_path")${NC}"
        elif [[ -d "$file_path" ]]; then
            if confirm "Add all files from: $(basename "$file_path")?"; then
                while IFS= read -r -d '' f; do
                    files+=("$f")
                done < <(find "$file_path" -type f -print0)
            fi
        else
            echo -e "${RED}✗ Not found: $file_path${NC}"
        fi
    done
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "\n${YELLOW}No files to upload.${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "\n${BLUE}Uploading ${#files[@]} file(s)...${NC}\n"
    "$GHU" "${files[@]}"
    echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
    wait_for_q
}

# Upload folder
upload_folder() {
    print_header
    echo -e "${BOLD}Upload Folder/Archive${NC}\n"
    
    echo -e "${BLUE}Enter folder or archive path:${NC}"
    read -e folder_path
    
    if [[ -z "$folder_path" ]] || [[ "$folder_path" == "q" ]]; then
        return 0
    fi
    
    folder_path="${folder_path/#\~/$HOME}"
    
    if [[ ! -e "$folder_path" ]]; then
        echo -e "${RED}Error: Path not found: $folder_path${NC}\n"
        wait_for_q
        return
    fi
    
    if [[ -f "$folder_path" ]]; then
        upload_with_custom_naming "$folder_path"
        return
    fi
    
    if [[ ! -d "$folder_path" ]]; then
        echo -e "${RED}Error: Not a directory: $folder_path${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Scanning directory...${NC}\n"
    
    local files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$folder_path" -type f -print0)
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No files found.${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BOLD}Found ${#files[@]} files:${NC}\n"
    printf "  %s\n" "${files[@]}" | head -20
    [[ ${#files[@]} -gt 20 ]] && echo -e "  ${YELLOW}... and $(( ${#files[@]} - 20 )) more${NC}"
    echo
    
    if confirm "Upload all ${#files[@]} files?"; then
        echo -e "\n${BLUE}Uploading...${NC}\n"
        "$GHU" "${files[@]}"
        echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
    fi
    
    wait_for_q
}

# Browse Repo Submenu
browse_repo_submenu() {
    while true; do
        print_header
        echo -e "${BOLD}Browse Repo & Add Files${NC}\n"
        
        echo -e "${BOLD}Browse by:${NC}"
        echo -e "  ${GREEN}1)${NC}  Artists (Audio category)"
        echo -e "  ${GREEN}2)${NC}  All categories (Images, Docs, Scripts, etc.)"
        echo -e "  ${GREEN}q)${NC}  Back to main menu\n"
        
        read -p "Choose option: " browse_option
        echo
        
        case $browse_option in
            1)
                browse_artists_from_repo
                ;;
            2)
                browse_all_categories
                ;;
            q)
                return 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# Browse artists from repo
browse_artists_from_repo() {
    while true; do
        print_header
        echo -e "${BOLD}Browse Artists in Repo${NC}\n"
        
        echo -e "${BLUE}Loading artists from repo...${NC}\n"
        
        # List artists from repo
        local artists=()
        if [[ -x "$LIST_ARTISTS_SCRIPT" ]]; then
            while IFS= read -r artist; do
                [[ -n "$artist" ]] && artists+=("$artist")
            done < <("$LIST_ARTISTS_SCRIPT" 2>/dev/null || true)
        fi
        
        if [[ ${#artists[@]} -eq 0 ]]; then
            echo -e "${YELLOW}No artists found in repo yet.${NC}\n"
            echo -e "${BLUE}Enter artist path manually:${NC}\n"
            read -e -p "Artist path: " artist_path
            if [[ -n "$artist_path" ]] && [[ "$artist_path" != "q" ]]; then
                add_files_to_artist "$artist_path"
            fi
            wait_for_q
            return
        fi
        
        echo -e "${BOLD}Artists in repo:${NC}\n"
        for i in "${!artists[@]}"; do
            echo -e "  ${GREEN}$((i+1)))${NC}  ${artists[i]}"
        done
        echo -e "  ${GREEN}0)${NC}  Enter artist path manually"
        echo -e "  ${GREEN}q)${NC}  Back\n"
        
        read -p "Choose artist: " choice
        echo
        
        if [[ "$choice" == "q" ]]; then
            return 0
        fi
        
        if [[ "$choice" == "0" ]]; then
            read -e -p "Enter artist path: " artist_path
            if [[ -n "$artist_path" ]] && [[ "$artist_path" != "q" ]]; then
                add_files_to_artist "$artist_path"
            fi
            continue
        fi
        
        local idx=$((choice - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#artists[@]} ]]; then
            local artist_name="${artists[$idx]}"
            add_files_to_artist_menu "$artist_name"
        else
            echo -e "${RED}Invalid selection${NC}\n"
            sleep 1
        fi
    done
}

# Browse all categories
browse_all_categories() {
    print_header
    echo -e "${BOLD}Browse All Categories${NC}\n"
    
    echo -e "${BLUE}This feature lists all files in the repo by category.${NC}\n"
    echo -e "${BOLD}Categories:${NC}"
    echo -e "  ${GREEN}1)${NC}  Audio"
    echo -e "  ${GREEN}2)${NC}  Images"
    echo -e "  ${GREEN}3)${NC}  Docs"
    echo -e "  ${GREEN}4)${NC}  Scripts"
    echo -e "  ${GREEN}5)${NC}  Archives"
    echo -e "  ${GREEN}6)${NC}  Other"
    echo -e "  ${GREEN}q)${NC}  Back\n"
    
    read -p "Choose category: " category_choice
    echo
    
    if [[ "$category_choice" == "q" ]]; then
        return 0
    fi
    
    local category_map=("" "Audio" "Images" "Docs" "Scripts" "Archives" "Other")
    local category="${category_map[$category_choice]:-}"
    
    if [[ -z "$category" ]]; then
        echo -e "${RED}Invalid category${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Listing files in $category category...${NC}\n"
    echo -e "${YELLOW}Note: Full repo browsing coming soon. For now, use file upload options.${NC}\n"
    wait_for_q
}

# Add files to artist menu
add_files_to_artist_menu() {
    local artist_name="$1"
    
    while true; do
        print_header
        echo -e "${BOLD}Add Files to: $artist_name${NC}\n"
        
        # Try to find artist path locally
        local artist_path=$(find /Volumes/Eksternal/Audio -type d -name "$artist_name" -maxdepth 4 2>/dev/null | head -1)
        
        if [[ -z "$artist_path" ]]; then
            echo -e "${YELLOW}Artist path not found locally.${NC}"
            read -e -p "Enter artist path: " artist_path
            if [[ -z "$artist_path" ]] || [[ "$artist_path" == "q" ]]; then
                return 0
            fi
        fi
        
        if [[ ! -d "$artist_path" ]]; then
            echo -e "${RED}Error: Directory not found: $artist_path${NC}\n"
            wait_for_q
            return 1
        fi
        
        echo -e "${BLUE}Path: $artist_path${NC}\n"
        
        echo -e "${BOLD}Options:${NC}"
        echo -e "  ${GREEN}1)${NC}  Upload audio files (tracks)"
        echo -e "  ${GREEN}2)${NC}  Upload specific files"
        echo -e "  ${GREEN}3)${NC}  Upload all files in directory"
        echo -e "  ${GREEN}q)${NC}  Back\n"
        
        read -p "Choose option: " option
        echo
        
        case $option in
            1)
                upload_artist_audio "$artist_path"
                ;;
            2)
                upload_artist_files "$artist_path"
                ;;
            3)
                upload_directory "$artist_path"
                ;;
            q)
                return 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# Add files to artist (generic)
add_files_to_artist() {
    local artist_path="$1"
    add_files_to_artist_menu "$(basename "$artist_path")"
}

# Upload artist audio
upload_artist_audio() {
    local artist_path="$1"
    
    print_header
    echo -e "${BOLD}Upload Audio Files${NC}\n"
    echo -e "${BLUE}Artist: $(basename "$artist_path")${NC}\n"
    
    echo -e "${BLUE}Finding audio files...${NC}\n"
    
    local audio_files=()
    while IFS= read -r -d '' file; do
        audio_files+=("$file")
    done < <(find "$artist_path" -type f \( -name "*.mp3" -o -name "*.flac" -o -name "*.m4a" -o -name "*.wav" -o -name "*.aac" \) -print0 2>/dev/null)
    
    if [[ ${#audio_files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No audio files found.${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BOLD}Found ${#audio_files[@]} audio files:${NC}\n"
    printf "  %s\n" "${audio_files[@]}" | head -20
    [[ ${#audio_files[@]} -gt 20 ]] && echo -e "  ${YELLOW}... and $(( ${#audio_files[@]} - 20 )) more${NC}"
    echo
    
    if confirm "Upload all ${#audio_files[@]} audio files?"; then
        echo -e "\n${BLUE}Uploading...${NC}\n"
        "$GHU" "${audio_files[@]}"
        echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
    fi
    
    wait_for_q
}

# Upload artist files
upload_artist_files() {
    local artist_path="$1"
    
    print_header
    echo -e "${BOLD}Upload Specific Files${NC}\n"
    echo -e "${BLUE}Artist: $(basename "$artist_path")${NC}\n"
    
    if check_fzf; then
        echo -e "${BLUE}Select files with fzf...${NC}\n"
        local files=($(find "$artist_path" -type f -print0 2>/dev/null | fzf --multi --height 40% --border --bind="ctrl-/:toggle-preview" --preview="file {} 2>/dev/null && ls -lh {} 2>/dev/null" --preview-window=down:3 2>/dev/null || true))
    else
        echo -e "${YELLOW}Enter file paths (one per line, empty to finish):${NC}\n"
        local files=()
        while read -e file_path; do
            [[ -z "$file_path" ]] && break
            [[ "$file_path" == "q" ]] && return 0
            file_path="$artist_path/$file_path"
            [[ -f "$file_path" ]] && files+=("$file_path")
        done
    fi
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No files selected.${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "\n${BLUE}Uploading ${#files[@]} file(s)...${NC}\n"
    "$GHU" "${files[@]}"
    echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
    wait_for_q
}

# Upload directory
upload_directory() {
    local dir_path="$1"
    
    echo -e "${BLUE}Scanning directory...${NC}\n"
    
    local files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$dir_path" -type f -print0)
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No files found.${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BOLD}Found ${#files[@]} files:${NC}\n"
    printf "  %s\n" "${files[@]}" | head -20
    [[ ${#files[@]} -gt 20 ]] && echo -e "  ${YELLOW}... and $(( ${#files[@]} - 20 )) more${NC}"
    echo
    
    if confirm "Upload all ${#files[@]} files?"; then
        echo -e "\n${BLUE}Uploading...${NC}\n"
        "$GHU" "${files[@]}"
        echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
    fi
    
    wait_for_q
}

# Upload artist assets
upload_artist_assets() {
    print_header
    echo -e "${BOLD}Upload Artist Assets${NC}\n"
    
    if [[ ! -x "$UPLOAD_ASSETS_SCRIPT" ]]; then
        echo -e "${RED}Error: Upload artist assets script not found${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Enter artist path (e.g., /Volumes/Eksternal/Audio/Metal/C/Cold Steel):${NC}"
    read -e artist_path
    
    if [[ -z "$artist_path" ]] || [[ "$artist_path" == "q" ]]; then
        return 0
    fi
    
    echo
    "$UPLOAD_ASSETS_SCRIPT" "$artist_path"
    echo
    wait_for_q
}

# Upload from Finder
upload_finder_selection() {
    print_header
    echo -e "${BOLD}Upload from Finder Selection${NC}\n"
    
    if ! check_ghu; then
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Please select files in Finder, then press Enter...${NC}"
    read
    
    echo -e "\n${BLUE}Uploading selected files...${NC}\n"
    "$GHU"
    
    echo -e "\n${GREEN}✓ Upload complete!${NC}\n"
    wait_for_q
}

# Audio Tools Submenu
audio_tools_submenu() {
    while true; do
        print_header
        echo -e "${BOLD}Audio Tools${NC}\n"
        echo -e "  ${GREEN}1)${NC}  Browse artists & add files"
        echo -e "  ${GREEN}2)${NC}  Upload artist assets (covers, logos, artist images)"
        echo -e "  ${GREEN}3)${NC}  Upload audio files for artist"
        echo -e "  ${GREEN}q)${NC}  Back to main menu\n"
        
        read -p "Choose option: " option
        echo
        
        case $option in
            1)
                browse_artists_from_repo
                ;;
            2)
                upload_artist_assets
                ;;
            3)
                upload_audio_files_artist
                ;;
            q)
                return 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# Upload audio files for artist
upload_audio_files_artist() {
    print_header
    echo -e "${BOLD}Upload Audio Files for Artist${NC}\n"
    
    # List artists from repo
    echo -e "${BLUE}Loading artists from repo...${NC}\n"
    
    local artists=()
    if [[ -x "$LIST_ARTISTS_SCRIPT" ]]; then
        while IFS= read -r artist; do
            [[ -n "$artist" ]] && artists+=("$artist")
        done < <("$LIST_ARTISTS_SCRIPT" 2>/dev/null || true)
    fi
    
    if [[ ${#artists[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No artists found in repo yet.${NC}\n"
        read -e -p "Enter artist path: " artist_path
        if [[ -n "$artist_path" ]] && [[ "$artist_path" != "q" ]]; then
            upload_artist_audio "$artist_path"
        fi
        wait_for_q
        return
    fi
    
    echo -e "${BOLD}Artists in repo:${NC}\n"
    for i in "${!artists[@]}"; do
        echo -e "  ${GREEN}$((i+1)))${NC}  ${artists[i]}"
    done
    echo -e "  ${GREEN}0)${NC}  Enter artist path manually"
    echo -e "  ${GREEN}q)${NC}  Back\n"
    
    read -p "Choose artist: " choice
    echo
    
    if [[ "$choice" == "q" ]]; then
        return 0
    fi
    
    if [[ "$choice" == "0" ]]; then
        read -e -p "Enter artist path: " artist_path
        if [[ -n "$artist_path" ]] && [[ "$artist_path" != "q" ]]; then
            upload_artist_audio "$artist_path"
        fi
        wait_for_q
        return
    fi
    
    local idx=$((choice - 1))
    if [[ $idx -ge 0 ]] && [[ $idx -lt ${#artists[@]} ]]; then
        local artist_name="${artists[$idx]}"
        local artist_path=$(find /Volumes/Eksternal/Audio -type d -name "$artist_name" -maxdepth 4 2>/dev/null | head -1)
        
        if [[ -z "$artist_path" ]]; then
            read -e -p "Enter artist path: " artist_path
            [[ -z "$artist_path" ]] && return 0
        fi
        
        [[ -d "$artist_path" ]] && upload_artist_audio "$artist_path"
    else
        echo -e "${RED}Invalid selection${NC}\n"
        sleep 1
    fi
    
    wait_for_q
}

# Configure Options Submenu
configure_submenu() {
    while true; do
        print_header
        echo -e "${BOLD}Configure Options${NC}\n"
        
        local current_mode=$(get_config_value "output_mode" || echo "markdown")
        
        echo -e "  ${GREEN}1)${NC}  Clipboard/Output mode (current: $current_mode)"
        echo -e "  ${GREEN}q)${NC}  Back to main menu\n"
        
        read -p "Choose option: " option
        echo
        
        case $option in
            1)
                configure_clipboard_mode
                ;;
            q)
                return 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# Configure clipboard mode
configure_clipboard_mode() {
    while true; do
        print_header
        echo -e "${BOLD}Configure Output/Clipboard Mode${NC}\n"
        
        local current_mode=$(get_config_value "output_mode" || echo "markdown")
        
        echo -e "${BLUE}Current mode: ${BOLD}$current_mode${NC}\n"
        echo -e "${BLUE}This controls what gets copied to clipboard after upload${NC}\n"
        echo -e "${BOLD}Options:${NC}"
        echo -e "  ${GREEN}1)${NC}  Markdown only - [file.jpg](url)"
        echo -e "  ${GREEN}2)${NC}  URLs only - just the raw URLs"
        echo -e "  ${GREEN}3)${NC}  Both markdown and URLs"
        echo -e "  ${GREEN}q)${NC}  Back\n"
        
        read -p "Choose option: " option
        echo
        
        case $option in
            1)
                set_config_value "output_mode" "\"markdown\""
                echo -e "${GREEN}✓ Output mode set to: markdown${NC}\n"
                sleep 1
                return 0
                ;;
            2)
                set_config_value "output_mode" "\"url\""
                echo -e "${GREEN}✓ Output mode set to: url${NC}\n"
                sleep 1
                return 0
                ;;
            3)
                set_config_value "output_mode" "\"both\""
                echo -e "${GREEN}✓ Output mode set to: both${NC}\n"
                sleep 1
                return 0
                ;;
            q)
                return 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# View logs submenu
view_logs_submenu() {
    while true; do
        print_header
        echo -e "${BOLD}View Logs${NC}\n"
        
        echo -e "  ${GREEN}1)${NC}  Recent uploads (last 50 lines)"
        echo -e "  ${GREEN}2)${NC}  Live log (tail -f)"
        echo -e "  ${GREEN}q)${NC}  Back to main menu\n"
        
        read -p "Choose option: " option
        echo
        
        case $option in
            1)
                view_recent_log
                ;;
            2)
                view_log_tail
                ;;
            q)
                return 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# View recent log
view_recent_log() {
    print_header
    echo -e "${BOLD}Recent Uploads Log${NC}\n"
    
    if [[ ! -f "$LOG" ]]; then
        echo -e "${YELLOW}Log file not found: $LOG${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Last 50 lines:${NC}\n"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    tail -50 "$LOG" | sed 's/^/  /'
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    
    wait_for_q
}

# View live log
view_log_tail() {
    print_header
    echo -e "${BOLD}Upload Log (Live)${NC}\n"
    
    if [[ ! -f "$LOG" ]]; then
        echo -e "${YELLOW}Log file not found: $LOG${NC}\n"
        wait_for_q
        return
    fi
    
    echo -e "${BLUE}Following log (Ctrl+C to exit)...${NC}\n"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    tail -f "$LOG"
}

# Main menu loop
main() {
    while true; do
        print_header
        print_menu
        
        read -p "Choose an option [0-5]: " choice
        echo
        
        case $choice in
            1)
                upload_files_submenu
                ;;
            2)
                browse_repo_submenu
                ;;
            3)
                audio_tools_submenu
                ;;
            4)
                configure_submenu
                ;;
            5)
                view_logs_submenu
                ;;
            0)
                echo -e "${GREEN}Goodbye!${NC}\n"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}\n"
                sleep 1
                ;;
        esac
    done
}

# Run main function
main
