#!/bin/bash

echo "🧹 Cleaning duplicates in mods/..."

MODS_DIR="mods"
cd "$MODS_DIR" || exit 1

# Group by base name (without version)
for base in $(ls *.jar 2>/dev/null | sed -E 's/-[0-9].*\.jar$//' | sort | uniq); do
  matches=($(ls "$base"-*.jar 2>/dev/null))
  if [ "${#matches[@]}" -gt 1 ]; then
    echo "🗑️ Found duplicates for $base:"
    for i in "${!matches[@]}"; do echo "  [$i] ${matches[$i]}"; done
    newest="${matches[-1]}"
    for file in "${matches[@]}"; do
      [[ "$file" != "$newest" ]] && rm "$file" && echo "❌ Removed: $file"
    done
    echo "✅ Kept: $newest"
  fi
done
