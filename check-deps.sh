#!/bin/bash
missing_deps=()
for dep in "fabric-api" "architectury"; do
  if ! ls mods | grep -iq "$dep"; then
    missing_deps+=("$dep")
  fi
done

if [ ${#missing_deps[@]} -gt 0 ]; then
  echo "⚠️ Missing dependencies:"
  for dep in "${missing_deps[@]}"; do echo "  - $dep"; done
else
  echo "✅ All core dependencies found"
fi
