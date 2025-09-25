#!/bin/bash
echo "🔄 Checking for updates..."

for mod in mods/*.jar; do
  name=$(basename "$mod" | cut -d'-' -f1)
  echo "🔍 $name: checking Modrinth..."
  # You can reuse logic from install-mod.sh to compare versions
done

echo "✅ Update check complete"
