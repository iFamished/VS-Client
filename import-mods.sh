#!/bin/bash

OS=$(cat .osinfo)
DOWNLOADS="$HOME/Downloads"
[[ "$OS" == "windows" ]] && DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"

MODS="./mods"

echo "📦 Scanning $DOWNLOADS for Fabric 1.21.8 mods..."
find "$DOWNLOADS" -maxdepth 1 -iname "*fabric*1.21.8*.jar" -exec mv {} "$MODS" \;
echo "✅ Mods moved to $MODS"
