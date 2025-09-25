#!/bin/bash

MODPACK_INPUT="$1"
CONFIG_FILE="config.json"
DEFAULT_VERSION=$(jq -r '.default_version' "$CONFIG_FILE")
DEFAULT_LOADER=$(jq -r '.default_loader' "$CONFIG_FILE")

if [ -z "$MODPACK_INPUT" ]; then
  echo "❌ Usage: install-modpack <modpackname/fullurl>"
  exit 1
fi

# Step 1: Resolve modpack ID
if [[ "$MODPACK_INPUT" == https://modrinth.com/modpack/* ]]; then
  MODPACK_SLUG=$(echo "$MODPACK_INPUT" | cut -d'/' -f5)
else
  MODPACK_SLUG="$MODPACK_INPUT"
fi

echo "🔍 Fetching modpack metadata for '$MODPACK_SLUG'..."
MODPACK_DATA=$(curl -s "https://api.modrinth.com/v2/project/$MODPACK_SLUG")

if [ -z "$MODPACK_DATA" ] || [ "$MODPACK_DATA" == "null" ]; then
  echo "❌ Modpack not found"
  exit 1
fi

# Step 2: Get latest compatible version
VERSION_DATA=$(curl -s "https://api.modrinth.com/v2/project/$MODPACK_SLUG/version")
MATCHED=$(echo "$VERSION_DATA" | jq -r ".[] | select(.game_versions[] == \"$DEFAULT_VERSION\") | select(.loaders[] == \"$DEFAULT_LOADER\")")

if [ -z "$MATCHED" ]; then
  echo "❌ No compatible version found for loader=$DEFAULT_LOADER and version=$DEFAULT_VERSION"
  exit 1
fi

MODPACK_URL=$(echo "$MATCHED" | jq -r '.files[0].url')
MODPACK_FILE=$(basename "$MODPACK_URL")
MODPACK_DIR="run/modpack-temp"

echo "🧩 Found compatible modpack: $MODPACK_FILE"
read -p "⚠️ Are you sure you want to install this modpack? (y/N): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "❌ Cancelled" && exit 0

read -p "🧨 This will overwrite your current settings. Rewrite EVERYTHING in /run? (y/N): " full_reset

# Step 3: Download and extract modpack
mkdir -p "$MODPACK_DIR"
curl -L "$MODPACK_URL" -o "$MODPACK_DIR/$MODPACK_FILE"
unzip -q "$MODPACK_DIR/$MODPACK_FILE" -d "$MODPACK_DIR"

# Step 4: Apply modpack
echo "⚙️ Applying modpack..."

if [[ "$full_reset" == "y" || "$full_reset" == "Y" ]]; then
  echo "🧨 Full reset confirmed"
  rm -rf run/*
  cp -r "$MODPACK_DIR"/overrides/* run/
else
  echo "🛠️ Selective merge"
  for file in "$MODPACK_DIR"/overrides/*; do
    name=$(basename "$file")
    if [[ "$name" == "options.txt" && -f run/options.txt ]]; then
      echo "✅ Keeping existing options.txt"
      continue
    fi
    if [[ "$name" == "config" ]]; then
      for cfg in "$file"/*; do
        cfgname=$(basename "$cfg")
        if [ ! -f "run/config/$cfgname" ]; then
          cp "$cfg" "run/config/$cfgname"
        else
          echo "⚠️ Skipping conflicting config: $cfgname"
        fi
      done
    else
      cp -r "$file" run/
    fi
  done
fi

echo "🧹 Cleaning up..."
rm -rf "$MODPACK_DIR"
echo "✅ Modpack installed successfully"