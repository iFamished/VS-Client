#!/bin/bash

MOD_INPUT="$1"
MC_VERSION="$2"
LOADER="$3"

if [ -z "$MOD_INPUT" ]; then
  echo "❌ Usage: install-mod <mod> [version] [loader]"
  echo "Example: install-mod sodium 1.21.8 fabric"
  exit 1
fi

# Check if input is a Modrinth URL
if [[ "$MOD_INPUT" == https://modrinth.com/mod/* ]]; then
  echo "🔗 Direct Modrinth URL detected"
  MOD_SLUG=$(echo "$MOD_INPUT" | cut -d'/' -f5)
  VERSION_SLUG=$(echo "$MOD_INPUT" | cut -d'/' -f7)

  VERSION_DATA=$(curl -s "https://api.modrinth.com/v2/project/$MOD_SLUG/version/$VERSION_SLUG")

  MOD_URL=$(echo "$VERSION_DATA" | grep -o '"url":"[^"]*\.jar"' | cut -d'"' -f4)
  MOD_FILE=$(basename "$MOD_URL")

  DEPENDENCIES=$(echo "$VERSION_DATA" | grep -o '"project_id":"[^"]*"' | cut -d'"' -f4 | tail -n +2)
else
  echo "🔍 Searching Modrinth for '$MOD_INPUT'..."
  MOD_ID=$(curl -s "https://api.modrinth.com/v2/search?query=$MOD_INPUT" | grep -o '"project_id":"[^"]*"' | head -1 | cut -d':' -f2 | tr -d '"')

  if [ -z "$MOD_ID" ]; then
    echo "❌ Mod '$MOD_INPUT' not found"
    exit 1
  fi

  VERSION_DATA=$(curl -s "https://api.modrinth.com/v2/project/$MOD_ID/version")

  # Filter by loader and version if provided
  FILTERED=$(echo "$VERSION_DATA" | grep -o '{[^}]*"files":[^}]*}' | grep '\.jar' | head -1)

  if [ -n "$LOADER" ]; then
    echo "$FILTERED" | grep -q "$LOADER" || FILTERED=""
  fi
  if [ -n "$MC_VERSION" ]; then
    echo "$FILTERED" | grep -q "$MC_VERSION" || FILTERED=""
  fi

  MOD_URL=$(echo "$FILTERED" | grep -o '"url":"[^"]*\.jar"' | cut -d'"' -f4)
  MOD_FILE=$(basename "$MOD_URL")

  DEPENDENCIES=$(echo "$FILTERED" | grep -o '"project_id":"[^"]*"' | cut -d'"' -f4 | tail -n +2)
fi

if [ -z "$MOD_URL" ]; then
  echo "❌ No matching version found for '$MOD_INPUT'"
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
