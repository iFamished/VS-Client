#!/bin/bash

MOD_NAME="$1"
MODS_DIR="mods"

if [ -z "$MOD_NAME" ]; then
  echo "❌ Usage: uninstall-mod <modname>"
  exit 1
fi

MATCHES=$(ls "$MODS_DIR"/*.jar 2>/dev/null | grep -i "$MOD_NAME")

if [ -z "$MATCHES" ]; then
  echo "❌ No matching mod found for '$MOD_NAME'"
  exit 1
fi

echo "🗑️ Found matching mods:"
echo "$MATCHES"

read -p "⚠️ Remove all matching mods? (y/N): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "❌ Cancelled" && exit 0

echo "$MATCHES" | xargs rm
echo "✅ Removed mods matching '$MOD_NAME'"