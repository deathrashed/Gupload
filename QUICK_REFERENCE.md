# Gupload Quick Reference Guide

Fast reference for common tasks and features.

---

## 🚀 Quick Start

```bash
# Upload single file
./ghu /path/to/file.mp3

# Upload with custom name
./ghu --name "Custom Name.mp3" /path/to/file.mp3

# Open interactive menu
./scripts/gupload-menu.sh

# Upload from URL
./ghu https://example.com/cover.jpg
```

---

## 📋 Menu Navigation

```
Main Menu:
  1) Upload Files
  2) Browse Repo & Add Files
  3) Audio Tools
  4) Quick Access
  5) Advanced Tools          ← NEW power features
  6) Configure Options
  7) View Logs
  8) Stats & Info
```

---

## ⚡ Quick Access Features (Menu 4)

| Feature | Description | Shortcut |
|---------|-------------|----------|
| **Recent Uploads** | View last 50 uploads with fzf search | `4 → 1` |
| **Favorites** | Manage frequently-used paths | `4 → 2` |
| **Repeat Last** | Re-upload last file instantly | `4 → 3` |
| **Common Paths** | Quick access to Home/Downloads/Desktop | `4 → 4` |

---

## 🔥 Advanced Tools (Menu 5)

| Tool | Purpose | Path |
|------|---------|------|
| **Batch URL Upload** | Upload multiple URLs at once | `5 → 1` |
| **Duplicate Checker** | Check if file already uploaded | `5 → 2` |
| **Upload Templates** | Save/reuse upload configs | `5 → 3` |
| **Clipboard Monitor** | Auto-detect copied files/URLs | `5 → 4` |
| **File Preview** | View details before upload | `5 → 5` |
| **Search Uploads** | Find by name/category/date | `5 → 6` |
| **Export History** | Export to CSV/JSON/Markdown | `5 → 7` |
| **Bulk Operations** | Gallery, multi-URL copy, cleanup | `5 → 8` |

---

## 🎯 Common Workflows

### Upload Album Covers
```bash
# Method 1: Batch URL upload
Menu: 5 → 1
Paste Bandcamp URLs
Choose naming: Prefix → "Band Name - Album"

# Method 2: Use template
Menu: 5 → 3 → 4 (Use template)
Select: "Album Covers"
```

### Check for Duplicates
```bash
Menu: 5 → 2
Enter file path
If found: Copy existing URL or upload anyway
```

### Generate Image Gallery
```bash
Menu: 5 → 8 → 2 → 1
Number of images: 12
Output: ~/Desktop/gallery.md
```

### Search Previous Uploads
```bash
# By filename
Menu: 5 → 6 → 1
Search: "carnifex"

# By category
Menu: 5 → 6 → 2
Select: Audio

# By date
Menu: 5 → 6 → 3
Start: 2026-01-10
End: 2026-01-15
```

---

## 💾 File Locations

```
~/.config/ghuploader/
├── config.json           # Main configuration
└── data/
    ├── favorites.json    # Saved paths
    ├── recent.json       # Upload history (100 max)
    └── templates.json    # Upload templates
```

---

## 🎨 Output Modes

| Mode | Description | Example |
|------|-------------|---------|
| **markdown** | Markdown links with HTML | `![image.jpg](url)`<br>`<audio src="url">` |
| **url** | Raw URLs only | `https://raw.githubusercontent.com/...` |
| **both** | Both formats | Markdown + URL |

Change: Menu → 6 → 1

---

## 🎵 Audio-Specific Features

### Upload Artist Assets
```bash
./scripts/upload-artist-assets.sh "/path/to/Artist Name"
```
Uploads: `cover.jpg`, `logo.png`, `artist.jpg` for all albums

### Smart Audio Naming
```
02. Livin' Fat.mp3 → Fat Joe - Livin' Fat.mp3
```
(Removes track numbers, adds artist from path)

### Browse Artists
```bash
Menu: 3 → 1
```
Lists all artists in repo with fzf search

---

## 📊 Statistics & Info (Menu 8)

| Option | Shows |
|--------|-------|
| **Upload Stats** | Total uploads, breakdown by category, recent 10 |
| **Repo Info** | GitHub details, size, stars (if gh CLI) |
| **Config Summary** | All settings, file paths |
| **Help & Shortcuts** | Complete keyboard reference |

---

## ⌨️ Navigation (Hub Library Style)

Each screen now shows context-appropriate navigation at the bottom:

### Main Menu Footer
```
────────────────────────────────────────────────────────────────
  1-9  Select option  │  0  Exit  │  Ctrl+C  Quick exit
────────────────────────────────────────────────────────────────
```

### Submenu Footer
```
────────────────────────────────────────────────────────────────
  1-9  Select option  │  b/0  ← Back  │  q  Quit
────────────────────────────────────────────────────────────────
```

### History Pagination Footer
```
────────────────────────────────────────────────────────────────
  n  Next page  │  p  Previous  │  c  Copy URL  │  b  ← Back  │  q  Quit
────────────────────────────────────────────────────────────────
```

### Upload Queue Footer
```
────────────────────────────────────────────────────────────────
  1-6  Queue actions  │  b/0  ← Back  │  q  Quit
────────────────────────────────────────────────────────────────
```

### fzf Help Footer
```
────────────────────────────────────────────────────────────────
  Ctrl+/  Preview  │  /text  Search  │  ↑↓  Navigate  │  Enter  Select  │  Esc  Cancel
────────────────────────────────────────────────────────────────
```

---

## 🔧 Configuration Options

### Essential Settings
```json
{
  "owner": "your-username",
  "repo": "your-repo",
  "branch": "main",
  "organize_by_artist": false,
  "use_image_subfolders": true,
  "output_mode": "markdown"
}
```

### File Size Handling
- `< 95MB`: Contents API (stored in repo)
- `95MB - 2GB`: Releases API (attached to release)

---

## 🎬 Example Sessions

### Session 1: Quick Single Upload
```bash
./ghu ~/Pictures/band-logo.png
# → Automatically categorized, named, uploaded
# → URL copied to clipboard
```

### Session 2: Batch Album Upload
```bash
./scripts/gupload-menu.sh
# Menu: 5 → 1 (Batch URL upload)
# Paste 10 Bandcamp cover URLs
# Choose: Prefix → "Deeds Of Flesh - Discography"
# Result: All covers uploaded with sequential names
```

### Session 3: Template-Based Workflow
```bash
./scripts/gupload-menu.sh
# Menu: 5 → 3 → 1 (Create template)
# Name: "Metal Logos"
# Config: category=Images, naming=artist-logo
# Later: 5 → 3 → 4 (Use template)
# Upload 20 logos with consistent naming
```

### Session 4: Find & Export
```bash
./scripts/gupload-menu.sh
# Menu: 5 → 6 → 2 (Search by category)
# Select: Audio
# Shows all audio files
# Menu: 5 → 7 → 3 (Export to markdown)
# Result: Full audio catalog in markdown table
```

---

## 🔍 Troubleshooting

### "Bad credentials"
```bash
# Re-authenticate
gh auth login
```

### "No recent uploads"
```bash
# Upload a file first
./ghu ~/test.txt

# Or check file exists
ls ~/.config/ghuploader/data/recent.json
```

### "Template not found"
```bash
# List templates
cat ~/.config/ghuploader/data/templates.json

# Or create new template
Menu: 5 → 3 → 1
```

### "Clipboard monitor not working"
```bash
# macOS only
# Copy as plain text
# Use absolute paths
```

---

## 💡 Pro Tips

1. **Install fzf**: `brew install fzf` for fuzzy searching
2. **Save common paths** as favorites (Menu 4 → 2)
3. **Use templates** for repeated workflows
4. **Check duplicates** before uploading (Menu 5 → 2)
5. **Export history** monthly for backup
6. **Monitor clipboard** for instant uploads
7. **Preview large files** before uploading (Menu 5 → 5)
8. **Generate galleries** for documentation
9. **Search by date** for reports
10. **Use batch operations** for multiple files

---

## 📚 Full Documentation

- **Advanced Features**: `ADVANCED_FEATURES.md`
- **Menu Improvements**: `MENU_IMPROVEMENTS.md`
- **Main README**: `README.md`
- **Help in Menu**: Menu → 8 → 4

---

## 🚦 Most Common Tasks

### Upload a File
```bash
./ghu /path/to/file.ext
```

### Upload from URL
```bash
./ghu https://example.com/file.ext
```

### Open Menu
```bash
./scripts/gupload-menu.sh
```

### Check Recent Uploads
```bash
Menu: 4 → 1
```

### Create Upload Template
```bash
Menu: 5 → 3 → 1
```

### Search Uploads
```bash
Menu: 5 → 6 → 1
```

### Export History
```bash
Menu: 5 → 7 → 1 (CSV)
```

---

**Quick Reference v2.0** | January 2026 | For Gupload Advanced Features
