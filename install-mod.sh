#!/bin/bash

MOD_INPUT="$1"
MC_VERSION="${2:-1.21.8}"
LOADER="${3:-fabric}"

if [ -z "$MOD_INPUT" ]; then
  echo "❌ Usage: install-mod <mod> [version] [loader]"
  echo "Example: install-mod sodium 1.21.8 fabric"
  exit 1
fi

# Function to decode URL-encoded filenames
decode_filename() {
  printf '%b' "${1//%/\\x}"
}

# Handle direct Modrinth URL
if [[ "$MOD_INPUT" == https://modrinth.com/mod/* ]]; then
  echo "🔗 Direct Modrinth URL detected"
  MOD_SLUG=$(echo "$MOD_INPUT" | cut -d'/' -f5)
  VERSION_SLUG=$(echo "$MOD_INPUT" | cut -d'/' -f7)

  VERSION_DATA=$(curl -s "https://api.modrinth.com/v2/project/$MOD_SLUG/version/$VERSION_SLUG")
  MOD_URL=$(echo "$VERSION_DATA" | jq -r '.files[0].url')
  MOD_FILE=$(decode_filename "$(basename "$MOD_URL")")
  DEPENDENCIES=$(echo "$VERSION_DATA" | jq -r '.dependencies[]?.project_id')
else
  echo "🔍 Searching Modrinth for '$MOD_INPUT'..."
  MOD_ID=$(curl -s "https://api.modrinth.com/v2/search?query=$MOD_INPUT" | jq -r '.hits[0].project_id')

  if [ -z "$MOD_ID" ] || [ "$MOD_ID" == "null" ]; then
    echo "❌ Mod '$MOD_INPUT' not found"
    exit 1
  fi

  VERSION_DATA=$(curl -s "https://api.modrinth.com/v2/project/$MOD_ID/version")

  MATCHED=$(echo "$VERSION_DATA" | jq -r ".[] | select(.loaders[] == \"$LOADER\") | select(.game_versions[] == \"$MC_VERSION\")")

  if [ -z "$MATCHED" ]; then
    echo "❌ No matching version found for '$MOD_INPUT'"
    exit 1
  fi

  MOD_URL=$(echo "$MATCHED" | jq -r '.files[0].url')
  MOD_FILE=$(decode_filename "$(basename "$MOD_URL")")
  DEPENDENCIES=$(echo "$MATCHED" | jq -r '.dependencies[]?.project_id')
fi

if [ -z "$MOD_URL" ]; then
  echo "❌ No downloadable file found"
  exit 1
fi

echo "🧩 Found mod: $MOD_FILE"
read -p "⬇️ Install '$MOD_FILE' into your mods folder? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Installation cancelled"
  exit 0
fi

curl -L "$MOD_URL" -o "mods/$MOD_FILE"
echo "✅ Installed mod: $MOD_FILE"

# 🔄 Auto-install dependencies
if [ -n "$DEPENDENCIES" ]; then
  echo "📦 Dependencies detected:"
  for dep in $DEPENDENCIES; do
    echo "  - $dep"
    read -p "⬇️ Install dependency '$dep'? (y/N): " dep_confirm
    if [[ "$dep_confirm" == "y" || "$dep_confirm" == "Y" ]]; then
      bash install-mod.sh "$dep" "$MC_VERSION" "$LOADER"
    else
      echo "❌ Skipped dependency: $dep"
    fi
  done
fi
