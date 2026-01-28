#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate Bookmarklet
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon /Users/rd/.config/raycast/script-commands/active commands/icons/bookmarklet-generator.png
# @raycast.argument1 { "type": "text", "placeholder": "URL with %Search% or %s" }

# Documentation:
# @raycast.description Generate bookmarklet from URL with placeholder
# @raycast.author Riley
# @raycast.authorURL https://github.com/yourusername

set -euo pipefail

URL="$1"

# Extract domain for prompt text
DOMAIN=$(echo "$URL" | sed -E 's|https?://([^/]+).*|\1|' | sed -E 's|www\.||' | cut -d. -f1)

# Replace placeholders with JS template
CLEAN_URL=$(echo "$URL" | sed "s/%Search%/'+encodeURIComponent(q)+'/g" | sed "s/%s/'+encodeURIComponent(q)+'/g")

# Build bookmarklet
BOOKMARKLET="javascript:(function(){var q=prompt('Search ${DOMAIN}:');if(q)window.location.href='${CLEAN_URL}';})();"

# Copy to clipboard
echo -n "$BOOKMARKLET" | pbcopy

echo "✓ Bookmarklet copied to clipboard!"
echo ""
echo "Site: $DOMAIN"
echo ""
echo "Bookmarklet:"
echo "$BOOKMARKLET"