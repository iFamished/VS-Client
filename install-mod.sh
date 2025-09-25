#!/bin/bash

MOD_INPUT="$1"
CONFIG_FILE="config.json"
MC_VERSION="${2:-$(jq -r '.default_version' "$CONFIG_FILE")}"
LOADER="${3:-$(jq -r '.default_loader' "$CONFIG_FILE")}"

if [ -z "$MOD_INPUT" ]; then
  echo "❌ Usage: install-mod <mod> [version] [loader]"
  exit 1
fi

decode_filename() {
  printf '%b' "${1//%/\\x}"
}

if [[ "$MOD_INPUT" == https://modrinth.com/mod/* ]]; then
  MOD_SLUG=$(echo "$MOD_INPUT" | cut -d'/' -f5)
  VERSION_SLUG=$(echo "$MOD_INPUT" | cut -d'/' -f7)
  DATA=$(curl -s "https://api.modrinth.com/v2/project/$MOD_SLUG/version/$VERSION_SLUG")
else
  MOD_ID=$(curl -s "https://api.modrinth.com/v2/search?query=$MOD_INPUT" | jq -r '.hits[0].project_id')
  DATA=$(curl -s "https://api.modrinth.com/v2/project/$MOD_ID/version" | jq -r ".[] | select(.loaders[] == \"$LOADER\") | select(.game_versions[] == \"$MC_VERSION\")" | head -c -1)
fi

MOD_URL=$(echo "$DATA" | jq -r '.files[0].url')
MOD_FILE=$(decode_filename "$(basename "$MOD_URL")")
DEPENDENCIES=$(echo "$DATA" | jq -r '.dependencies[]?.project_id')

if [ -z "$MOD_URL" ]; then
  echo "❌ No matching version found"
  exit 1
fi

echo "🧩 Found mod: $MOD_FILE"
read -p "⬇️ Install '$MOD_FILE'? (y/N): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "❌ Cancelled" && exit 0

curl -L "$MOD_URL" -o "mods/$MOD_FILE"
echo "✅ Installed: $MOD_FILE"

for dep in $DEPENDENCIES; do
  echo "📦 Dependency: $dep"
  read -p "⬇️ Install '$dep'? (y/N): " dep_confirm
  [[ "$dep_confirm" == "y" || "$dep_confirm" == "Y" ]] && bash install-mod.sh "$dep" "$MC_VERSION" "$LOADER"
done