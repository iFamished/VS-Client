#!/bin/bash
MOD_NAME="$1"
echo "🔍 Searching Modrinth for $MOD_NAME..."

MOD_ID=$(curl -s "https://api.modrinth.com/v2/search?query=$MOD_NAME" | grep -o '"project_id":"[^"]*"' | head -1 | cut -d':' -f2 | tr -d '"')

if [ -z "$MOD_ID" ]; then
  echo "❌ Mod not found"
  exit 1
fi

VERSION_URL="https://api.modrinth.com/v2/project/$MOD_ID/version"
MOD_URL=$(curl -s "$VERSION_URL" | grep -o '"url":"[^"]*\.jar"' | head -1 | cut -d':' -f2- | tr -d '"')

if [ -z "$MOD_URL" ]; then
  echo "❌ No downloadable version found"
  exit 1
fi

echo "⬇️ Downloading mod..."
curl -L "$MOD_URL" -o "mods/$(basename "$MOD_URL")"
echo "✅ Installed mod: $(basename "$MOD_URL")"
