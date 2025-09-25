#!/bin/bash

CONFIG_FILE="config.json"

# Defaults
DEFAULT_LOADER="fabric"
DEFAULT_VERSION="1.21.8"

MOD_INPUT="$1"
LOADER="${2:-$DEFAULT_LOADER}"
MC_VERSION="${3:-$DEFAULT_VERSION}"

if [ -z "$MOD_INPUT" ]; then
  echo "❌ Usage: install-mod <mod> [loader] [version]"
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

  if [ -z "$MOD_ID" ] || [ "$MOD_ID" = "null" ]; then
    echo "❌ No matching mod found for '$MOD_INPUT'"
    exit 1
  fi

  DATA=$(curl -s "https://api.modrinth.com/v2/project/$MOD_ID/version" | \
    jq --arg loader "$LOADER" --arg mc "$MC_VERSION" \
    '[.[] | select(.loaders[] == $loader) | select(.game_versions[] == $mc)][0]')
fi

MOD_URL=$(echo "$DATA" | jq -r '.files[0].url')
MOD_FILE=$(decode_filename "$(basename "$MOD_URL")")
DEPENDENCIES=$(echo "$DATA" | jq -r '.dependencies[]?.project_id')

if [ -z "$MOD_URL" ] || [ "$MOD_URL" = "null" ]; then
  echo "❌ No matching version found for '$MOD_INPUT' with loader '$LOADER' and Minecraft '$MC_VERSION'"
  exit 1
fi

echo "🧩 Mod found"
read -p "⬇️ Proceed with installation? (y/N): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "❌ Cancelled" && exit 0

mkdir -p mods
curl -L "$MOD_URL" -o "mods/$MOD_FILE"
echo "✅ Installed: $MOD_FILE"

for dep in $DEPENDENCIES; do
  echo "📦 Dependency: $dep"
  read -p "⬇️ Install dependency '$dep'? (y/N): " dep_confirm
  [[ "$dep_confirm" == "y" || "$dep_confirm" == "Y" ]] && bash bin/install-mod.sh "$dep" "$LOADER" "$MC_VERSION"
done
