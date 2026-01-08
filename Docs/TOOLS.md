# Tools & Scripts

Automation and maintenance utilities for the collection.

## Overview

This collection is maintained through a combination of:
- Commercial tagging software for bulk operations
- Custom scripts for validation and organization
- macOS Shortcuts and Automator workflows
- Command-line tools for format conversion

## Core Tools

### Metadata Management

**Mp3tag** (Primary tagger)
- Bulk tagging and renaming
- Tag source integration (MusicBrainz, Discogs)
- Powerful filename ↔ tag conversion
- Action groups for standardization

**MusicBrainz Picard**
- Automated metadata lookup
- Acoustic fingerprinting (AcoustID)
- Release matching and verification
- Best for unknown/poorly tagged files

**Kid3** (macOS)
- Cross-platform tagging
- Batch operations
- Export/import tag formats
- Cover art management

### Format Conversion

**dBpoweramp Reference**
- High-quality FLAC → MP3 conversion
- Batch processing
- Metadata preservation
- ReplayGain calculation

**FFmpeg** (Command-line)
- Universal format conversion
- Lossless and lossy codecs
- Scriptable for automation
- Extensive format support

**XLD (X Lossless Decoder)**
- macOS native lossless conversion
- Accurate CD ripping
- Format preservation
- Checksum verification

### Image Processing

**ImageMagick** (Command-line)
- Batch image conversion and resizing
- Format standardization
- Quality optimization
- Automated artwork processing

**Album Art Downloader**
- Automated cover art fetching
- Multiple source integration
- Batch downloading
- Resolution filtering

## Custom Scripts

### Collection Statistics

**stats.py** - Generate collection statistics
```python
#!/usr/bin/env python3
# See: /Volumes/Eksternal/Audio/tools/stats.py
# Generates counts of artists, albums, tracks, and storage usage
```

**Genre Breakdown**:
- Artists per genre
- Albums per genre
- Total track count
- Storage used per genre

### Validation Scripts

**validate-structure.sh** - Check directory organization
- Verify naming conventions
- Find misplaced files
- Identify missing covers/logos
- Report inconsistencies

**check-metadata.py** - Audit file tags
- Find untagged files
- Verify required fields
- Check date formats
- Report missing artwork

**find-duplicates.py** - Detect duplicate albums
- Compare by artist + album title
- Identify different editions
- Flag potential merges

### Maintenance Scripts

**normalize-filenames.sh** - Standardize naming
- Add track numbers to files missing them
- Correct "## - Title" format
- Rename covers to cover.jpg
- Fix common naming issues

**artwork-extractor.py** - Extract embedded artwork
- Save embedded covers to cover.jpg
- Verify image dimensions
- Report low-quality artwork
- Mass extraction for collection audit

**tag-cleaner.py** - Clean up metadata
- Remove unnecessary tags
- Standardize genre names
- Fix capitalization inconsistencies
- Trim whitespace

### Organization Tools

**sort-by-date.py** - Organize by release year
- Generate year-based views
- Useful for "new releases" browsing
- Symlink-based (doesn't move files)

**compilation-sorter.py** - Handle various artists
- Move compilations to -Compilations-/
- Preserve metadata
- Update file paths

## Keyboard Maestro Macros

### Quick Tagging
- Open selected album in Mp3tag
- Apply standard tag action group
- Embed artwork from cover.jpg
- Rename files to standard format

### Artwork Management
- Download covers from Bandcamp URL
- Resize and optimize for collection
- Embed in all album tracks
- Save as cover.jpg

### File Organization
- Move album to correct genre/letter
- Create artist folder if needed
- Copy artist logo from source
- Update info.txt with template

## AppleScript Utilities

### Swinsian Integration
Scripts for Swinsian music player automation:
- Add album to "Recently Added" playlist
- Rate albums after listening
- Export play counts
- Generate listening statistics

### Finder Actions
- Bulk tag visible folders with genre
- Create artist folders with templates
- Apply custom folder icons
- Open Terminal at album location

## Python Utilities

Located in `/Volumes/Eksternal/Audio/tools/`:

**collector_stats.py**
- Collection statistics generator
- Exports JSON and markdown reports
- Genre breakdowns, storage usage
- Year distribution charts

**metadata_validator.py**
- Comprehensive tag validation
- Check required fields
- Verify artwork presence
- Report missing data

**artwork_optimizer.py**
- Resize covers to standard dimensions
- Optimize JPEG quality vs size
- Convert PNG to JPG when appropriate
- Batch processing with progress

**duplicate_finder.py**
- Find duplicate albums
- Compare by audio fingerprint
- Identify different bitrates of same release
- Generate merge reports

**bandcamp_scraper.py**
- Fetch metadata from Bandcamp
- Generate album_info.md files
- Download album artwork
- Extract track listings

## Shell Scripts

Located in `/Volumes/Eksternal/Audio/tools/`:

**batch_convert.sh**
- FLAC to MP3 conversion
- Preserves directory structure
- Maintains metadata
- Parallel processing option

**find_missing_covers.sh**
- Scan for albums without cover.jpg
- Generate list for manual sourcing
- Check minimum dimensions
- Output CSV report

**cleanup_metadata.sh**
- Remove .DS_Store files
- Clean temp/cache files
- Fix permissions
- Optimize directory structure

## Installation & Setup

### Python Dependencies
```bash
pip install --break-system-packages \
  mutagen \           # Audio metadata
  Pillow \           # Image processing
  pandas \           # Data analysis
  matplotlib \       # Statistics visualization
  musicbrainzngs \   # MusicBrainz API
  discogs-client     # Discogs API
```

### FFmpeg Installation
```bash
# macOS (Homebrew)
brew install ffmpeg

# Include MP3 encoder
brew install ffmpeg --with-libmp3lame
```

### ImageMagick
```bash
brew install imagemagick
```

## Workflow Examples

### Adding a New Album

1. **Acquire** files (CD rip, purchase, etc.)
2. **Tag** using Mp3tag or Picard
   - Match to MusicBrainz/Discogs
   - Add genre classification
   - Embed artwork
3. **Validate** with validation scripts
4. **Organize** to correct genre/letter/artist
5. **Document** (create info.txt or album_info.md)
6. **Verify** with final checklist

### Converting Genre from FLAC to MP3

```bash
cd /Volumes/Eksternal/Audio/Metal
find . -name "*.flac" -type f > flac_files.txt
./tools/batch_convert.sh --input flac_files.txt \
  --format mp3 --bitrate 320 --delete-original
```

### Batch Artwork Update

```python
python3 tools/artwork_optimizer.py \
  --path "/Volumes/Eksternal/Audio/Metal" \
  --min-size 500 \
  --max-size 1000 \
  --quality 95 \
  --format jpg
```

### Metadata Cleanup

```bash
python3 tools/metadata_validator.py \
  --path "/Volumes/Eksternal/Audio" \
  --fix-common \
  --report validation_report.md
```

## Automation Triggers

### Hazel Rules (macOS)
- Watch Downloads folder for new music files
- Auto-import to "Unsorted" staging area
- Trigger Mp3tag for initial tagging
- Notify when ready for organization

### Keyboard Maestro Palettes
- ⌘K → Quick tag selected album
- ⌘⌥K → Validate album structure
- ⌘⇧K → Generate album_info.md

### Folder Actions
- New album folder created → Copy template files
- New artist folder created → Prompt for logo
- Cover.jpg added → Embed in all tracks

## Future Enhancements

**Planned Tools**:
- Web interface for collection browsing
- Automated Bandcamp album importer
- Machine learning genre classification
- Duplicate content detector (beyond filename)
- Playback statistics aggregator

**Wishlist**:
- Integration with streaming platforms for discovery
- Automated tour date tracking per artist
- Release calendar from followed labels
- Collaborative tagging with other collectors

---

*See `/Volumes/Eksternal/Audio/tools/` for implementation details*

*Last updated: January 2026*
