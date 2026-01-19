# Gupload Advanced Features Guide

Complete guide to the advanced features available in the Gupload menu system (Option 5: Advanced Tools).

---

## Table of Contents

1. [Batch URL Upload](#1-batch-url-upload)
2. [Duplicate Checker](#2-duplicate-checker)
3. [Upload Templates](#3-upload-templates)
4. [Clipboard Monitor](#4-clipboard-monitor)
5. [File Preview](#5-file-preview)
6. [Search Uploaded Files](#6-search-uploaded-files)
7. [Export Upload History](#7-export-upload-history)
8. [Bulk File Operations](#8-bulk-file-operations)

---

## 1. Batch URL Upload

**Purpose**: Upload multiple files from URLs in one operation.

**Location**: Advanced Tools → Option 1

### Features:
- Paste multiple URLs at once (separated by spaces or newlines)
- Three naming strategies:
  1. **Default**: Use filename from URL
  2. **Prefix**: Common prefix with automatic numbering (e.g., "Album - 01", "Album - 02")
  3. **Individual**: Custom name for each URL

### Usage Example:

```bash
# Navigate to Batch URL Upload
Main Menu → 5 → 1

# Paste URLs:
https://example.com/cover1.jpg
https://example.com/cover2.jpg
https://example.com/cover3.jpg

# Choose naming strategy:
1) Default naming (cover1.jpg, cover2.jpg, cover3.jpg)
2) Prefix naming → Enter "Deteriorate" → Results: Deteriorate - 01.jpg, Deteriorate - 02.jpg, Deteriorate - 03.jpg
3) Individual naming → Prompted for each: "Front Cover.jpg", "Back Cover.jpg", "CD Disc.jpg"
```

### Use Cases:
- Download album covers from Bandcamp/Metal Archives
- Batch download logo images from multiple sources
- Quick download of documentation PDFs
- Grab multiple artist photos at once

---

## 2. Duplicate Checker

**Purpose**: Check if a file has already been uploaded before uploading again.

**Location**: Advanced Tools → Option 2

### Features:
- Searches upload history by exact filename match
- Shows existing upload details (URL, category, timestamp)
- Options:
  - Copy existing URL to clipboard (avoid re-upload)
  - Upload anyway (create duplicate)
  - Cancel operation

### Usage Example:

```bash
# Navigate to Duplicate Checker
Main Menu → 5 → 2

# Enter file path:
/Volumes/Audio/Metal/C/Carnifex/logo.png

# If already uploaded:
✓ File already uploaded!
  Filename: carnifex-logo.png
  URL: https://raw.githubusercontent.com/...
  Category: Images
  Uploaded: 2026-01-15T14:23:45

Options:
1) Copy existing URL to clipboard
2) Upload anyway (create duplicate)
3) Cancel
```

### Use Cases:
- Avoid duplicate uploads
- Verify if file was previously uploaded
- Retrieve URL of previously uploaded file
- Check upload history before batch operations

---

## 3. Upload Templates

**Purpose**: Save and reuse upload configurations for common workflows.

**Location**: Advanced Tools → Option 3

### Features:
- Save upload configurations as named templates
- Templates store:
  - Naming pattern (default, custom, artist-based)
  - Category override (optional)
  - Output mode (markdown, URL, both)
  - Custom notes
- View all templates
- Delete unwanted templates
- Use template for upload

### Usage Example:

```bash
# Create template for album covers
Main Menu → 5 → 3 → 1 (Create template)

Template name: Album Covers
Naming pattern: artist-album
Category: Images
Output mode: markdown
Notes: For album artwork uploads

# Later, use template:
Main Menu → 5 → 3 → 4 (Use template)
Select template: Album Covers
Enter file: /path/to/cover.jpg
→ Uploads with saved configuration
```

### Template Storage:
- Location: `~/.config/ghuploader/data/templates.json`
- Format: JSON with template configurations
- Portable: Can be backed up or shared

### Use Cases:
- Standardize band logo uploads
- Consistent naming for album covers
- Repeated workflows (scripts, docs, etc.)
- Team/shared configuration presets

---

## 4. Clipboard Monitor

**Purpose**: Automatically detect and upload files/URLs copied to clipboard.

**Location**: Advanced Tools → Option 4

### Features:
- Monitors clipboard for changes
- Detects:
  - Local file paths
  - HTTP/HTTPS URLs
- Prompts to upload when detected
- Option to use custom name
- Press `q` to stop monitoring

### Usage Example:

```bash
# Start clipboard monitor
Main Menu → 5 → 4

Monitoring clipboard... (Press 'q' to stop)

# In another app, copy a file path or URL:
# /Volumes/Audio/Metal/D/Deeds Of Flesh/logo.png

Detected file: /Volumes/Audio/Metal/D/Deeds Of Flesh/logo.png
Upload this file? (y/n/q): y
Use custom name? (y/n): n
→ Uploads with default naming

# Continue monitoring or press 'q' to exit
```

### Use Cases:
- Quick uploads while browsing files in Finder
- Upload files from other applications
- Instant upload from download notifications
- Workflow integration with other tools

### Tips:
- Leave monitor running in background terminal
- Use with Finder's "Copy as Pathname" (Cmd+Opt+C)
- Combine with templates for faster uploads
- Great for batch operations (copy multiple files sequentially)

---

## 5. File Preview

**Purpose**: View detailed file information before uploading.

**Location**: Advanced Tools → Option 5

### Features:
- Shows comprehensive file details:
  - Full filename and path
  - File size (human-readable)
  - File type and extension
  - Last modified date/time
  - Detected category
- Proceed with upload or cancel
- Option to use custom name

### Usage Example:

```bash
# Preview file before upload
Main Menu → 5 → 5

Enter file path: /Volumes/Audio/Metal/C/Carnifex/artist.jpg

=== File Preview ===

Filename:       artist.jpg
Full Path:      /Volumes/Audio/Metal/C/Carnifex/artist.jpg
Size:           2.4 MB
Type:           JPEG image
Modified:       2026-01-15 14:23:45
Category:       Images

Proceed with upload? (y/n): y
Use custom name? (y/n): y
Custom name: Carnifex artist photo.jpg
→ Uploads with custom name
```

### Use Cases:
- Verify file details before large uploads
- Check file size for API method (Contents vs Releases)
- Confirm category detection
- Ensure correct file before upload

---

## 6. Search Uploaded Files

**Purpose**: Search upload history by multiple criteria.

**Location**: Advanced Tools → Option 6

### Search Methods:

#### 1. Search by Filename
- Substring match (case-insensitive)
- Searches all uploaded filenames
- Shows matching files with URLs

#### 2. Search by Category
- Select from: Audio, Images, Video, Scripts, Documents, Docs, Data, Archives, Other
- Lists all files in that category
- Option to copy URLs

#### 3. Search by Date Range
- Enter start date (YYYY-MM-DD)
- Enter end date (YYYY-MM-DD)
- Shows uploads within range

### Usage Example:

```bash
# Search by filename
Main Menu → 5 → 6 → 1

Enter search term: carnifex

Found 5 matches:

1. carnifex-logo.png
   URL: https://raw.githubusercontent.com/.../carnifex-logo.png
   Category: Images
   Uploaded: 2026-01-15T14:23:45

2. Carnifex - Die Without Hope.mp3
   URL: https://raw.githubusercontent.com/.../Carnifex%20-%20Die%20Without%20Hope.mp3
   Category: Audio
   Uploaded: 2026-01-15T14:30:12

[Copy URLs? (y/n)]
```

```bash
# Search by date range
Main Menu → 5 → 6 → 3

Start date (YYYY-MM-DD): 2026-01-10
End date (YYYY-MM-DD): 2026-01-15

Found 12 uploads between 2026-01-10 and 2026-01-15
[Shows all uploads with details]
```

### Use Cases:
- Find previously uploaded files
- Generate reports of uploads
- Verify uploads from specific time period
- Locate files by category
- Bulk URL retrieval for documentation

---

## 7. Export Upload History

**Purpose**: Export upload history to various formats for backup or analysis.

**Location**: Advanced Tools → Option 7

### Export Formats:

#### 1. CSV (Spreadsheet)
```csv
Filename,Category,URL,Timestamp
carnifex-logo.png,Images,https://raw.githubusercontent.com/...,2026-01-15T14:23:45
Carnifex - Die Without Hope.mp3,Audio,https://raw.githubusercontent.com/...,2026-01-15T14:30:12
```

#### 2. JSON (Full Data)
```json
[
  {
    "filepath": "/Volumes/Audio/Metal/C/Carnifex/logo.png",
    "filename": "carnifex-logo.png",
    "url": "https://raw.githubusercontent.com/...",
    "category": "Images",
    "timestamp": "2026-01-15T14:23:45"
  }
]
```

#### 3. Markdown Table
```markdown
| Filename | Category | URL | Timestamp |
|----------|----------|-----|-----------|
| carnifex-logo.png | Images | [Link](https://raw.githubusercontent.com/...) | 2026-01-15 14:23 |
| Carnifex - Die Without Hope.mp3 | Audio | [Link](https://raw.githubusercontent.com/...) | 2026-01-15 14:30 |
```

### Usage Example:

```bash
# Export to CSV
Main Menu → 5 → 7 → 1

Enter output file: ~/Desktop/gupload-history.csv
✓ Export complete: 47 uploads exported

# Export to Markdown
Main Menu → 5 → 7 → 3

Enter output file: ~/Desktop/uploads.md
✓ Export complete: 47 uploads exported
```

### Use Cases:
- Backup upload history
- Generate documentation with upload links
- Analyze upload patterns in Excel/Sheets
- Share upload lists with team
- Create weekly/monthly reports
- Import into other systems (CSV/JSON)

---

## 8. Bulk File Operations

**Purpose**: Perform operations on multiple uploaded files at once.

**Location**: Advanced Tools → Option 8

### Operations:

#### 1. Copy Multiple URLs
- Select multiple files from recent uploads
- All URLs copied to clipboard at once
- Paste into documentation, emails, etc.

#### 2. Generate Gallery
Three gallery formats:
- **Image Gallery**: Markdown image grid (3 columns)
- **Audio Playlist**: HTML5 audio players with controls
- **Generic Gallery**: Links with file info

#### 3. Clear Upload History
- Creates automatic backup before clearing
- Backup location: `~/.config/ghuploader/data/recent_backup_<timestamp>.json`
- Confirms before clearing
- Option to restore from backup

### Usage Example:

```bash
# Generate image gallery
Main Menu → 5 → 8 → 2 → 1

How many recent images? 12
Enter output file: ~/Desktop/album-gallery.md

✓ Gallery generated: 12 images
→ Creates:
| ![img1](url1) | ![img2](url2) | ![img3](url3) |
| ![img4](url4) | ![img5](url5) | ![img6](url6) |
...
```

```bash
# Clear history with backup
Main Menu → 5 → 8 → 3

Current history: 47 uploads
Backup will be created automatically.

Clear history? (y/n): y
✓ Backup created: recent_backup_2026-01-15T14-30-12.json
✓ History cleared (47 uploads)
```

### Gallery Formats:

**Image Gallery**:
```markdown
| ![Image 1](url1) | ![Image 2](url2) | ![Image 3](url3) |
| ![Image 4](url4) | ![Image 5](url5) | ![Image 6](url6) |
```

**Audio Playlist**:
```html
<audio controls src="url1">Track 1</audio>
<audio controls src="url2">Track 2</audio>
```

**Generic Gallery**:
```markdown
1. [Filename 1](url1) - Category - 2026-01-15
2. [Filename 2](url2) - Category - 2026-01-15
```

### Use Cases:
- Create album artwork galleries
- Build audio playlists for README
- Generate file indexes
- Documentation with multiple links
- Backup before reorganization
- Clean up old upload data

---

## Data Storage

All advanced features use persistent JSON storage:

```
~/.config/ghuploader/data/
├── favorites.json       # Saved favorite paths
├── recent.json         # Upload history (last 100)
└── templates.json      # Upload templates
```

### Backup Recommendations:
1. **Regular backups**: Export upload history monthly
2. **Template sharing**: Copy `templates.json` for team use
3. **Version control**: Consider tracking data/ folder (if not sensitive)
4. **Automatic backups**: Created when clearing history

---

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `q` or `0` | Exit submenu / Go back |
| `1-9` | Select menu option |
| `Ctrl+C` | Exit program (anywhere) |
| `y` / `n` | Confirm / Decline prompts |
| `Tab` | Autocomplete file paths |
| `~` | Home directory shortcut |

### In fzf (fuzzy finder):
| Key | Action |
|-----|--------|
| `Ctrl+/` | Toggle preview |
| `/text` | Search/filter |
| `↑` `↓` | Navigate results |
| `Enter` | Select item |
| `Esc` | Cancel |

---

## Performance Tips

1. **Use fzf**: Install with `brew install fzf` for faster searching
2. **Template workflows**: Save common operations as templates
3. **Clipboard monitor**: Keep running for instant uploads
4. **Batch operations**: Use batch URL upload for multiple files
5. **Export regularly**: Keep backup of upload history
6. **Search first**: Check duplicates before uploading

---

## Troubleshooting

### "No recent uploads found"
- Upload at least one file first
- Check `~/.config/ghuploader/data/recent.json` exists
- Verify uploads are being logged

### "Template not found"
- Check `~/.config/ghuploader/data/templates.json`
- Recreate template if corrupted
- Verify JSON formatting

### "Clipboard monitor not detecting"
- macOS only (uses `pbpaste`)
- Copy as plain text (not rich text)
- Ensure file paths are absolute
- URLs must start with `http://` or `https://`

### "Export failed"
- Check write permissions on output directory
- Verify output path is valid
- Check disk space
- Try different format (CSV vs JSON vs Markdown)

### "Gallery generation incomplete"
- Not enough recent uploads of selected type
- Check recent uploads with: Main Menu → 4 → 1
- Upload more files of the desired type

---

## Integration with Other Tools

### With fzf:
```bash
# Search and upload in one command
find ~/Music -type f -name "*.mp3" | fzf | xargs ./ghu
```

### With gh CLI:
```bash
# Check repo stats before upload
gh repo view --json diskUsage,stargazerCount
```

### With jq (JSON manipulation):
```bash
# Extract URLs from history
cat ~/.config/ghuploader/data/recent.json | jq -r '.[].url'

# Filter by category
cat ~/.config/ghuploader/data/recent.json | jq '.[] | select(.category == "Audio")'
```

---

## Advanced Workflows

### Workflow 1: Album Upload Pipeline
```bash
1. Use template: "Album Covers"
2. Batch URL upload: Paste Bandcamp URLs
3. Preview files before upload
4. Check duplicates
5. Generate image gallery
6. Export markdown to README
```

### Workflow 2: Documentation Assets
```bash
1. Create template: "Documentation Images"
2. Use clipboard monitor
3. Copy screenshots as you work
4. Monitor auto-uploads each
5. Generate gallery at end
6. Export to markdown for docs
```

### Workflow 3: Audio Library Management
```bash
1. Search by category: Audio
2. Export to CSV for spreadsheet
3. Analyze in Excel/Numbers
4. Generate audio playlist
5. Add playlist to README
```

### Workflow 4: Weekly Cleanup
```bash
1. Search by date range: Last 7 days
2. Review uploads
3. Export weekly report (markdown)
4. Generate galleries for albums
5. Update documentation
```

---

## Future Enhancement Ideas

Potential additions to consider:

1. **Scheduled uploads**: Cron integration for automatic uploads
2. **Watch folders**: Auto-upload files dropped into folder
3. **Cloud sync**: Sync templates across devices
4. **Webhook support**: Trigger actions on upload
5. **File conversion**: Auto-convert before upload (resize images, transcode audio)
6. **Metadata editing**: Edit upload metadata after upload
7. **Tagging system**: Add custom tags to uploads
8. **Smart collections**: Auto-group related uploads

---

## Best Practices

1. **Use templates** for repeated workflows
2. **Check duplicates** before batch uploads
3. **Export history** monthly for backup
4. **Preview large files** before uploading
5. **Use descriptive names** for templates
6. **Monitor clipboard** for quick uploads
7. **Generate galleries** for documentation
8. **Search by category** to find files
9. **Clear history** periodically (with backup)
10. **Use batch URL** for multiple downloads

---

## Support & Documentation

- **Main README**: `/Volumes/Eksternal/Projects/Gupload/README.md`
- **Menu Improvements**: `/Volumes/Eksternal/Projects/Gupload/MENU_IMPROVEMENTS.md`
- **Help in Menu**: Main Menu → 8 → 4 (Stats & Info → Help)
- **Logs**: `/tmp/gupload.log`
- **Configuration**: `~/.config/ghuploader/config.json`

---

**Version**: 2.0 Advanced Features
**Date**: January 2026
**Status**: Production Ready ✨

Made with ❤️ for power users who need advanced file hosting capabilities.
