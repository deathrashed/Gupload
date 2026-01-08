# File Format & Naming Standards

## Audio Formats

### Primary Format: MP3
**Current Standard**:
- **Codec**: MPEG-1 Audio Layer 3
- **Bitrate**: 320kbps CBR (Constant Bitrate) or V0 VBR (Variable Bitrate)
- **Sample Rate**: 44.1kHz
- **Channels**: Stereo (2.0)
- **ID3 Version**: v2.3 or v2.4

**When MP3 is Used**:
- Daily listening and portable device compatibility
- Space-constrained storage
- Streaming to various players
- Files named with `.mp3` extension

### Legacy Format: FLAC
**Historical Standard** (some albums still in FLAC):
- **Codec**: Free Lossless Audio Codec
- **Compression**: Level 5 (balance of size and speed)
- **Sample Rate**: 44.1kHz or higher (up to 96kHz for HD releases)
- **Bit Depth**: 16-bit minimum (24-bit for HD releases)
- **Tags**: Vorbis Comments

**When FLAC is Retained**:
- Archival copies of critical albums
- Albums with high dynamic range or audiophile value
- Pending conversion queue
- Preserving source for future format changes
- Files named with `.flac` extension

### Archive Format: MP3.zip
Some albums contain `MP3.zip` files:
- Alternative MP3 encodings (different bitrate, encoder)
- Backup of original rips before cleanup
- Alternate versions (e.g., censored vs. explicit)

## Filename Patterns

### Track Files
```
## - Track Title.ext
```

**Rules**:
- Two-digit track number (01-99)
- Space, hyphen, space separator (` - `)
- Track title exactly as tagged
- Extension matches actual format (.mp3, .flac, .m4a)

**Examples**:
```
01 - Infernal Death.mp3
02 - Zombie Ritual.mp3
12 - Scream Bloody Gore.mp3
```

**Multi-Disc Tracks**:
Within `Disc 1/`, `Disc 2/` subdirectories:
```
Disc 1/01 - First Track.mp3
Disc 2/01 - First Track of Disc Two.mp3
```

Track numbering resets per disc, not consecutive across discs.

### Album Folders
```
YYYY - Album Title
```

**Rules**:
- Four-digit year first
- Space, hyphen, space separator (` - `)
- Album title with official capitalization
- No file extension (it's a directory)

**Special Cases**:
```
1987 - Scream Bloody Gore                  # Standard
1987 - Scream Bloody Gore (Reissue)       # Edition noted in parens
1991 - Human [Remastered]                  # Alternative notation
1998 - Live at Wacken                      # Live albums
2005 - Demo Collection                     # Compilation of demos
```

### Image Files

**Required**:
```
cover.jpg              # Album cover (in album folder)
logo.png / logo.jpg    # Band logo (in artist folder)
```

**Common Optional**:
```
artist.jpg             # Artist photo
banner.jpg             # Wide banner image
backdrop.jpg           # Stage/live photo
back.jpg               # Back cover artwork
booklet##.jpg          # Booklet pages (01, 02, etc.)
disc.jpg               # CD/vinyl disc image
```

**Historical/Variant Logos**:
```
oldlogo.png            # Previous logo design
old-new-logo.png       # Transitional logo
newlogo.jpg            # Updated logo
logo-variant.png       # Alternate version
```

### Documentation Files
```
info.txt               # Plain text album info
album_info.md          # Markdown with structured metadata
[Artist].md            # Artist biography/discography
[Artist].pdf           # Liner notes, scans, booklets
```

## Directory Naming

### Genre Folders
```
Metal/
Electronic/
Hip-Hop/
Punk & Hardcore/
Rock & Grunge/
Miscellaneous/
```

**Rules**:
- Title Case
- Preserve ampersands: "Punk & Hardcore" not "Punk and Hardcore"
- Hyphens for compound genres: "Hip-Hop", "Rock & Grunge"

### Alphabetical Subdivisions
```
A/
B/
...
Z/
#/
-Compilations-/
-Splits-/
-Singles-/
```

**Rules**:
- Single letter, uppercase
- Special folder names with dashes for sorting first
- Symbol/number folder uses `#`

### Artist Folders
```
Artist Name/
Artist Name (Location)/
Artist Name (Descriptor)/
```

**Rules**:
- Use official artist name and spelling
- Disambiguate with location or descriptor in parentheses
- Preserve unicode and special characters
- Replace filesystem-illegal characters

**Filesystem-Illegal Character Replacement**:
```
/ → ⧸ (or omit)
\ → ⧹ (or omit)
: → - (or omit)
* → ∗ (or omit)
? → [omit]
" → '' (smart quotes) or ' (or omit)
< → [omit]
> → [omit]
| → - (or omit)
```

**Examples**:
```
AC/DC          → AC⧸DC
...And Oceans  → ...And Oceans (filed under #/)
Type O Negative → Type O Negative (original)

Mötley Crüe  → Motley Crue or Mötley Crüe (unicode preserved)
D.R.I.       → D.R.I. (periods OK)
```

## Image Specifications

### Album Covers (cover.jpg)

**Technical Requirements**:
- **Format**: JPEG
- **Color Space**: RGB
- **Resolution**: 500x500px minimum, 1000x1000px preferred
- **Aspect Ratio**: 1:1 (square)
- **File Size**: 200KB - 2MB typically
- **Quality**: 90-95% JPEG quality

**Content Requirements**:
- Official album artwork only
- Front cover, not back or spine
- No watermarks or overlays
- Clean scan or official digital source
- Correct album/edition (not reissue art for original release)

**Sourcing Priority**:
1. Official Bandcamp release (highest res available)
2. Official label/artist website
3. High-quality fan scans (300+ DPI)
4. Discogs/MusicBrainz (verified releases)

### Artist Logos

**logo.png** (Preferred):
- **Format**: PNG
- **Transparency**: Yes, when possible
- **Background**: Transparent or black
- **Resolution**: Variable, typically 500-2000px width
- **Quality**: Crisp, no artifacts
- **Source**: Official press materials or vector conversions

**logo.jpg** (Acceptable):
- **Format**: JPEG
- **Background**: Black or white (consistent within artist)
- **Resolution**: 500-2000px width
- **Quality**: High, minimal compression

**Logo Variants**:
- Name consistently: `oldlogo.png`, `newlogo.png`, `logo-variant.jpg`
- Keep historical logos for documentation
- Note era/usage in filename if known

### Additional Artwork

**artist.jpg**:
- Artist photo, press shot, or band photo
- 500x500px minimum, any reasonable aspect ratio
- Official promotional imagery preferred

**banner.jpg**:
- Wide format (3:1 or 2:1 ratio)
- 1200x400px or larger
- Stage shots, landscapes, or promotional banners

**Gallery Images**:
- Referenced in album_info.md
- Stored in album folder or centralized attachments/
- Include in album folder when essential to release

## File Size Guidelines

### Realistic Expectations

**Per Track (MP3 320kbps)**:
- 3-minute track: ~7MB
- 5-minute track: ~12MB
- 10-minute track: ~24MB

**Per Album**:
- Short album (30 min, 10 tracks): ~70MB
- Standard album (45 min, 12 tracks): ~105MB  
- Long album (70 min, 15 tracks): ~165MB

**Per Artist** (varies wildly):
- Small discography (2-3 albums): ~300MB
- Medium discography (6-8 albums): ~800MB
- Large discography (15+ albums): 2GB+

**Genre Totals** (rough estimates):
- Active genre (Metal, Punk): 50-200GB
- Moderate genre: 20-50GB
- Niche genre: 5-20GB

### FLAC Comparison
FLAC files are typically 2-3x larger than 320kbps MP3:
- 3-minute track: ~15-20MB FLAC vs ~7MB MP3
- Standard album: ~300-400MB FLAC vs ~105MB MP3

## File Organization Best Practices

### What Goes Where

**In Album Folders**:
- Audio tracks (required)
- cover.jpg (required)
- info.txt or album_info.md (highly recommended)
- Disc subdirectories for multi-disc releases
- MP3.zip for alternate formats (optional)
- Additional artwork relevant to this specific release

**In Artist Folders**:
- Album directories (required)
- logo.png/jpg (required)
- artist.jpg (recommended)
- Banner, backdrop, gallery images (optional)
- Artist documentation (Artist.md, Artist.pdf) for notable acts
- Historical logo variants

**In Letter Folders** (A-Z, #):
- Artist directories only
- No loose files

**In Genre Folders**:
- Letter directories (A-Z, #)
- Special directories (-Compilations-, -Splits-, -Singles-)
- Optional: Icon file for macOS custom folder icons

**At Root** (/Volumes/Eksternal/Audio/):
- Genre directories
- Documentation (README.md, STRUCTURE.md, METADATA.md, FILES.md)
- tools/ directory for scripts
- Icon file for volume icon

### What NOT to Store

**Avoid in Collection**:
- .DS_Store files (macOS metadata) - .gitignore these
- Thumbs.db (Windows thumbnails)
- desktop.ini
- Temporary files (.tmp, .part)
- Duplicate covers with different names
- Low-quality artwork (<300px)
- Personal notes or ratings (use separate database/tags)
- Lyrics files (embed in tags instead, or use external lyrics source)

## Format Conversion Notes

### FLAC → MP3 Conversion

**Tools Used**:
- dBpoweramp Reference
- FFmpeg with libmp3lame
- XLD (X Lossless Decoder) on macOS

**Settings**:
```bash
# FFmpeg example
ffmpeg -i input.flac -codec:a libmp3lame -b:a 320k output.mp3

# Or for V0:
ffmpeg -i input.flac -codec:a libmp3lame -q:a 0 output.mp3
```

**Process**:
1. Convert FLAC to MP3 with chosen settings
2. Verify tag transfer (all metadata)
3. Confirm embedded artwork copied
4. Check file naming matches format
5. Validate playback quality
6. Archive or remove FLAC based on retention policy

### Preserving Metadata
When converting formats:
- All tags transfer (Title, Artist, Album, Date, etc.)
- Embedded artwork copies at appropriate resolution
- Track numbers and disc numbers preserved
- Comments and extended tags maintained
- ReplayGain values recalculated if used

## Naming Convention Evolution

### Historical Changes

**Early Collection** (pre-2018):
- Inconsistent track numbering
- Mixed capitalization
- No artist logos
- Random artwork file names
- Varied date formats

**Current Standard** (2018+):
- Standardized "## - Track Title.ext"
- Official capitalization preserved
- Logo required in every artist folder
- cover.jpg standardized
- YYYY date format

**Migration Scripts**:
Custom scripts used to normalize:
- Add "## - " prefix to tracks without numbers
- Rename "folder.jpg" to "cover.jpg"
- Standardize album folder format to "YYYY - Title"
- Extract and embed missing artwork
- Clean up duplicate/redundant image files

## Validation & Quality Control

### Pre-Commit Checks
Before considering an album "complete":

**File Structure**:
- [ ] Album folder named correctly (YYYY - Title)
- [ ] Tracks numbered sequentially (01, 02, ...)
- [ ] No gaps in track numbering
- [ ] cover.jpg present and correct
- [ ] All tracks same format (all MP3 or all FLAC)

**Audio Quality**:
- [ ] Consistent bitrate across all tracks
- [ ] No clipping or distortion
- [ ] Proper stereo imaging
- [ ] Complete tracks (no cutoffs)

**Metadata**:
- [ ] All tags present (Title, Artist, Album, Date, Track#)
- [ ] Genre tag appropriate
- [ ] Artwork embedded
- [ ] Track times reasonable

**Artwork**:
- [ ] cover.jpg minimum 500x500px
- [ ] Correct album (not wrong edition/reissue)
- [ ] Clean image, no watermarks
- [ ] Artist folder has logo.png/jpg

### Automated Checks
Scripts exist to validate:
- Missing cover.jpg files
- Albums without info.txt/album_info.md
- Artists without logos
- Tracks with incomplete metadata
- Incorrect filename formats
- Orphaned files in wrong locations

---

*Last updated: January 2026*
