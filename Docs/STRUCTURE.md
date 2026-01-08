# Collection Structure

## Directory Hierarchy

```
/Volumes/Eksternal/Audio/
├── Electronic/
├── Hip-Hop/
├── Metal/
├── Miscellaneous/
├── Punk & Hardcore/
└── Rock & Grunge/
```

## Genre Organization

Each genre follows the same three-level structure:

### Level 1: Genre Category
Top-level directories group music by broad genre. Genres are mutually exclusive—each artist lives in exactly one category.

### Level 2: Alphabetical Subdivision
Within each genre, artists are organized alphabetically:

```
Metal/
├── #/                    # Artists starting with numbers or symbols
├── A/
├── B/
├── C/
...
├── Z/
├── -Compilations-/       # Genre-spanning compilation albums
└── -Splits-/             # Split releases (Metal & Punk only)
```

**Special Folders**:
- `#/` - Numeric and symbol-starting names (e.g., "7 Horns 7 Eyes", "$uicideboy$")
- `-Compilations-/` - Multi-artist compilations specific to the genre
- `-Splits-/` - Split releases between multiple bands (Metal & Punk & Hardcore only)
- `-Singles-/` - Standalone single releases (Miscellaneous only)

### Level 3: Artist Folder
```
Metal/D/Death/
├── 1987 - Scream Bloody Gore/
├── 1988 - Leprosy/
├── 1991 - Human/
├── artist.jpg                # Primary artist photo
├── logo.png                  # Band logo (primary)
├── oldlogo.png              # Historical logo variants
├── banner.jpg               # Wide format artwork
├── backdrop3.jpg            # Live/promo photos
├── Death.md                 # Artist documentation (when present)
└── Death.pdf                # Additional docs/liner notes
```

**Artist-Level Files**:
- `artist.jpg` - Primary artist photo or press image
- `logo.png` / `logo.jpg` - Official band logo (required)
- Additional logos with descriptors (`oldlogo.png`, `old-new-logo.png`)
- Banners, backdrops, and promotional imagery
- Optional markdown/PDF documentation for significant artists

### Level 4: Album Folder

Album folders follow strict naming: `YYYY - Album Title`

```
1987 - Scream Bloody Gore/
├── 01. Track Name.flac
├── 02. Track Name.flac
├── ...
├── cover.jpg                 # Album artwork (required)
├── info.txt                  # Plain text album info
├── album_info.md            # Structured markdown with metadata
└── MP3.zip                   # Alternative format archive (optional)
```

**Album Naming Rules**:
- Year first: `1987 - Album Name`
- Space-dash-space separator
- Preserve official capitalization and punctuation
- Disc sets: `YYYY - Album Name/Disc 1/`, `Disc 2/`, etc.

## File Naming Conventions

### Audio Files
```
01. Track Name.mp3
02. Track Name.flac
```

- Two-digit track number
- Period, space, then track title
- Extension reflects actual format (.mp3 for MP3, .flac for FLAC)
- Track titles match official releases (preserve capitalization, features, etc.)

### Artwork Files

**Required**:
- `cover.jpg` - Album cover in every album folder
- `logo.png` or `logo.jpg` - Band logo in every artist folder

**Common Optional**:
- `artist.jpg` - Artist photo in artist folders
- `banner.jpg`, `backdrop.jpg` - Supplementary imagery
- `info.txt`, `album_info.md` - Album documentation

## Edge Cases

### Compilations vs. Artist Albums
- Various Artists compilations → `-Compilations-/`
- Single-artist best-ofs/compilations → Artist's folder

### Split Releases
Splits live in `-Splits-/` folders in Metal and Punk & Hardcore:
```
Metal/-Splits-/
└── Artist A & Artist B - Split Title/
```

### Disambiguation
When multiple artists share a name, append location or descriptor:
```
Metal/D/
├── Dark (Germany)/
├── Darkness/
└── Devastation (Belgium)/
```

### Symbol-Starting Artists
Artists starting with symbols or numbers go in `#/`:
- "7 Horns 7 Eyes" → `#/`
- "$uicideboy$" → `#/`
- "...And Oceans" → `#/`

### Multi-Disc Albums
```
1998 - The Sound of Perseverance/
├── Disc 1/
│   ├── 01. Track.flac
│   └── ...
├── Disc 2/
│   ├── 01. Track.flac
│   └── ...
├── cover.jpg
└── album_info.md
```

## Why This Structure Works

**Genre-First**: Browsing by mood beats alphabetical soup. When you want metal, you want ALL the metal.

**Alphabetical Subdivision**: Prevents directories with 500+ artists. The A-Z split keeps navigation fast.

**Consistent Depth**: Every album is exactly 4 levels deep. Your brain learns the rhythm: Genre → Letter → Artist → Album.

**Artwork at Every Level**: Logos and artist photos at the artist level, covers at the album level. Every view is beautiful.

**Special Folders First**: Dashes sort before letters, so `-Compilations-` and `-Splits-` appear at the top of each genre directory.
