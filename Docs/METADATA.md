# Metadata Standards

## File Tag Schema

All audio files contain comprehensive ID3v2/Vorbis tags populated from trusted sources.

### Core Tags (Required)

| Tag | Description | Example |
|-----|-------------|---------|
| **Title** | Track name, exactly as released | "Zombie Ritual" |
| **Artist** | Primary artist/band name | "Death" |
| **Album** | Album title | "Scream Bloody Gore" |
| **Date** | Release year (YYYY format) | "1987" |
| **Track** | Track number (##/## format) | "02/12" |
| **Genre** | Primary genre classification | "Death Metal" |

### Extended Tags (When Available)

| Tag | Description |
|-----|-------------|
| **Album Artist** | For compilations/various artists |
| **Disc Number** | For multi-disc releases (##/##) |
| **Comment** | Additional context (remaster info, edition notes) |
| **Composer** | Songwriter credits |
| **Label** | Record label |
| **Catalog Number** | Label catalog ID |
| **Artwork** | Embedded album cover (JPEG, 500-1000px square) |

## Genre Taxonomy

### Top-Level Genres
The six primary genre categories are mutually exclusive:
- **Electronic**
- **Hip-Hop**
- **Metal**
- **Miscellaneous**
- **Punk & Hardcore**
- **Rock & Grunge**

### Subgenre Tagging
Within file tags, use specific subgenres for better categorization:

**Metal subgenres**:
- Death Metal, Black Metal, Thrash Metal, Doom Metal
- Progressive Death Metal, Technical Death Metal
- Old School Death Metal, Melodic Death Metal
- Grindcore, Blackened Death Metal

**Electronic subgenres**:
- House, Techno, Drum and Bass, Ambient
- IDM, Breakcore, Industrial

**Punk & Hardcore subgenres**:
- Hardcore Punk, Crust Punk, D-Beat
- Powerviolence, Fastcore, Grindcore

Multiple subgenres acceptable when appropriate (e.g., "progressive death metal, technical death metal").

## Album Documentation Files

### album_info.md Format

Structured markdown with YAML frontmatter:

```markdown
---
title: Album Title (Edition/Note)
artist: Artist Name
tags:
  - primary-genre
  - subgenre
  - style-descriptor
  - location-tag
release_date: YYYY-MM-DD
url: https://bandcamp.com/album/link
---

# Album Title
## by Artist Name

| | |
|---|---|
| **Released** | Month Day, Year |
| **Genres** | genre, subgenre, tags |
| **Bandcamp** | [Link](url) |

## Track Listing

1. [Track Name](link) (MM:SS)
2. ...

## Gallery

![[path/to/image.jpg]]
```

### info.txt Format

Plain text version with minimal formatting:
```
Artist Name - Album Title (Year)
Released: Month Day, Year
Label: Record Label

Catalog: XXXX-###
Format: MP3/FLAC/etc.
Bitrate: ###kbps

Track Listing:
01. Track Name (MM:SS)
02. Track Name (MM:SS)
...
```

## Tagging Sources

### Trusted Sources (Priority Order)
1. **Official Artist Bandcamp** - Most reliable for metadata and artwork
2. **Discogs** - Comprehensive database for catalog info and credits
3. **MusicBrainz** - Open database with extensive metadata
4. **Metal Archives** (metal only) - Genre-specific authority
5. **Official Label Sites** - For catalog numbers and release details

### What Gets Tagged From Where
- **Track listings & times**: Bandcamp or official releases
- **Genre classification**: Combination of Metal Archives, RYM, and personal judgment
- **Credits & lineup**: Discogs, Metal Archives, or liner notes
- **Catalog numbers**: Discogs or label sites
- **Release dates**: Use original release date, note reissues in Comment tag

## Edge Cases & Standards

### Reissues and Remasters
- Use original release date in Date tag
- Note remaster info in Comment: "Remastered 2016"
- Album title includes edition when significant: "Album Title (Deluxe Edition)"

### Live Albums
- Tag genre as "Live [Genre]" in secondary tags
- Title includes venue/year: "Live at Venue YYYY" or "Live YYYY"
- Track titles preserve as-performed, not studio versions

### Demos and EPs
- Tag Type: "EP", "Demo", "Single"
- Date uses demo/EP release date, not later album version
- Comment field notes if later re-recorded

### Compilations
- Album Artist: "Various Artists" (for multi-artist)
- Artist tag: Individual track artist
- Album: Full compilation title
- Special handling in `-Compilations-/` folder

### Split Releases
- Both artists in Album Artist tag: "Band A / Band B"
- Individual track Artist tags for each band's tracks
- Album title: "Split" or specific split title if named

### Featured Artists
- Include feature in Track title: "Song Name (feat. Artist)"
- Primary artist in Artist tag
- Featured artist also in Artist tag (separated by semicolon or slash depending on tagger)

### Various Artists - Single Track
- For compilation appearances, tag with specific artist
- Album remains compilation name
- Use albumartist for "Various Artists"

## Artwork Standards

### Album Covers (cover.jpg)
- **Format**: JPEG
- **Minimum**: 500x500px
- **Preferred**: 1000x1000px or larger
- **Aspect**: Square (1:1 ratio)
- **Quality**: High quality, scan or official digital
- **Embedded**: Yes, in all audio files

### Artist Logos (logo.png/jpg)
- **Format**: PNG preferred (transparency), JPEG acceptable
- **Content**: Official band logo
- **Background**: Transparent when possible
- **Variants**: Historical logos noted with descriptors (oldlogo.png, etc.)

### Additional Imagery
- artist.jpg: Band photo, promo shot, or live image
- banner.jpg: Wide format imagery
- Gallery images: Referenced in album_info.md

## Consistency Rules

### Capitalization
- Follow official release capitalization
- Exception: Lowercase-only bands tagged as-is (e.g., "godspeed you! black emperor")
- All-caps bands: Use standard capitalization (AC/DC stays AC/DC, but "SLAYER" becomes "Slayer")

### Special Characters
- Preserve official punctuation and symbols
- Unicode characters allowed (e.g., "Motörhead", "Dødheimsgard")
- Replace filesystem-illegal characters in filenames: `/ \ : * ? " < > |`

### Multiple Artists
- Collaborations: "Artist A & Artist B"
- Features: Primary artist only, feature in title
- Splits: "Artist A / Artist B" in Album Artist

### Dates
- Always YYYY format for year in tags
- Full date (YYYY-MM-DD) in album_info.md when known
- Unknown specific dates: Use year only, note uncertainty in Comment

## Validation Checklist

Before considering an album "complete":

- [ ] All tracks properly numbered and titled
- [ ] Album, Artist, Date tags present on every file
- [ ] Genre tag appropriate and specific
- [ ] cover.jpg present and correct album
- [ ] Album artwork embedded in file tags
- [ ] Track times accurate
- [ ] Multi-disc albums properly tagged with disc numbers
- [ ] info.txt or album_info.md present with track listing
- [ ] Artist folder contains logo.png/jpg

## Migration Notes

### FLAC to MP3 Conversion
When converting from FLAC to MP3:
- Preserve all metadata tags
- Copy embedded artwork
- Maintain consistent bitrate (320kbps CBR or V0 VBR)
- Verify tag compatibility (ID3v2.3 or v2.4)
- Keep FLAC archives when space permits

### Legacy Collection Cleanup
Historical improvements made:
- Standardized filename formats (added "##. " track numbering)
- Unified genre classification
- Added artist logos to all artist folders
- Created album_info.md for key releases
- Embedded artwork in older files missing covers
- Normalized date formats to YYYY

## Tools Used

- **Tagging**: Mp3tag, MusicBrainz Picard, Kid3
- **Format Conversion**: dBpoweramp, FFmpeg
- **Artwork**: Album Art Downloader, manual sourcing from Bandcamp
- **Validation**: Custom scripts for consistency checking
- **Metadata Lookup**: MusicBrainz, Discogs API

---

*Last updated: January 2026*
