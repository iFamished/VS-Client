#!/bin/bash

DOWNLOADS="$HOME/Downloads"
OS=$(cat .osinfo)
[[ "$OS" == "windows" ]] && DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"

RUN="./run"

echo "🔍 Searching for .mrpack files in $DOWNLOADS..."
find "$DOWNLOADS" -maxdepth 1 -iname "*.mrpack" | while read -r PACK; do
  echo "📦 Unpacking $PACK..."
  TEMP="./run/temp_unpack"
  mkdir -p "$TEMP"
  unzip -o "$PACK" -d "$TEMP"

  # Move known folders to run/
  for folder in mods resourcepacks shaderpacks config; do
    if [ -d "$TEMP/$folder" ]; then
      mkdir -p "$RUN/$folder"
      mv "$TEMP/$folder"/* "$RUN/$folder/"
      echo "✅ Imported $folder to $RUN/$folder/"
    fi
  done

  rm -rf "$TEMP"
done
