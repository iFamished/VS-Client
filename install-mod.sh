#!/bin/bash

MOD_NAME="$1"
if [ -z "$MOD_NAME" ]; then
  echo "❌ Please provide a mod name. Example: install-mod sodium"
  exit 1
fi

echo "🔍 Searching Modrinth for '$MOD_NAME' (Fabric 1.21.8)..."

# Get project ID
MOD_ID=$(curl -s "https://api.modrinth.com/v2/search?query=$MOD_NAME" | grep -o '"project_id":"[^"]*"' | head -1 | cut -d':' -f2 | tr -d '"')

if [ -z "$MOD_ID" ]; then
  echo "❌ Mod '$MOD_NAME' not found on Modrinth"
  exit 1
fi

# Get version info filtered by loader and game version
VERSION_URL="https://api.modrinth.com/v2/project/$MOD_ID/version"
MOD_URL=$(curl -s "$VERSION_URL" | jq -r '.[] | select(.loaders[] == "fabric") | select(.game_versions[] == "1.21.8") | .files[0].url' | head -1)

if [ -z "$MOD_URL" ]; then
  echo "❌ No Fabric 1.21.8 version found for '$MOD_NAME'"
  exit 1
fi

MOD_FILE=$(basename "$MOD_URL")
echo "🧩 Found mod: $MOD_FILE"

# ✅ Confirmation prompt
read -p "⬇️ Do you want to install '$MOD_FILE' into your mods folder? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Installation cancelled"
  exit 0
fi

# Proceed with download
curl -L "$MOD_URL" -o "mods/$MOD_FILE"
echo "✅ Installed mod: $MOD_FILE"
