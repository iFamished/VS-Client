#!/bin/bash

OS=$(cat .osinfo)
DOWNLOADS="$HOME/Downloads"
[[ "$OS" == "windows" ]] && DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"

MODS="./mods"

echo "📦 Scanning $DOWNLOADS for Fabric 1.21.8 mods..."

find "$DOWNLOADS" -maxdepth 1 -iname "*fabric*1.21.8*.jar" | while read -r FILE; do
  BASENAME=$(basename "$FILE")
  if [ -f "$MODS/$BASENAME" ]; then
    echo "⚠️ Skipping duplicate: $BASENAME already exists in $MODS"
  else
    mv "$FILE" "$MODS/"
    echo "✅ Imported: $BASENAME"
  fi
done
