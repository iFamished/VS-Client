#!/bin/bash

# Detect OS and set Downloads path
OS=$(cat .osinfo)
DOWNLOADS="$HOME/Downloads"
[[ "$OS" == "windows" ]] && DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"

RUN="./run"
TEMP="./run/temp_unpack"

echo "🔍 Searching for .mrpack files in $DOWNLOADS..."

find "$DOWNLOADS" -maxdepth 1 -iname "*.mrpack" | while read -r PACK; do
  echo "📦 Unpacking $PACK..."
  mkdir -p "$TEMP"
  unzip -o "$PACK" -d "$TEMP" > /dev/null
  chmod -R u+rw "$TEMP"

  # Check if modrinth.index.json exists
  INDEX="$TEMP/modrinth.index.json"
  if [ ! -f "$INDEX" ]; then
    echo "❌ Skipping $PACK — missing modrinth.index.json"
    rm -rf "$TEMP"
    continue
  fi

  # Validate Minecraft version
  VERSION_LINE=$(grep -E '"gameVersions":\s*

\[.*\]

' "$INDEX")
  if ! echo "$VERSION_LINE" | grep -q "1.21.8"; then
    echo "❌ Skipping $PACK — incompatible Minecraft version"
    rm -rf "$TEMP"
    continue
  fi

  # Move known folders to run/
  for folder in mods resourcepacks shaderpacks config; do
    if [ -d "$TEMP/$folder" ]; then
      mkdir -p "$RUN/$folder"
      for ITEM in "$TEMP/$folder"/*; do
        BASENAME=$(basename "$ITEM")
        TARGET="$RUN/$folder/$BASENAME"
        if [ -f "$TARGET" ]; then
          echo "⚠️ Skipping duplicate: $BASENAME already exists in $RUN/$folder"
        else
          mv "$ITEM" "$TARGET"
          echo "✅ Imported: $BASENAME → $RUN/$folder/"
        fi
      done
    fi
  done

  rm -rf "$TEMP"
done
