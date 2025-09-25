#!/bin/bash

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

  # Validate Minecraft version using grep
  VERSION_LINE=$(grep -E '"gameVersions":\s*

\[.*\]

' "$TEMP/modrinth.index.json")
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
        if [ -f "$RUN/$folder/$BASENAME" ]; then
          echo "⚠️ Skipping duplicate: $BASENAME already exists in $RUN/$folder"
        else
          mv "$ITEM" "$RUN/$folder/"
          echo "✅ Imported: $BASENAME → $RUN/$folder/"
        fi
      done
    fi
  done

  rm -rf "$TEMP"
done
