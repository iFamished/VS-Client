#!/bin/bash
read -p "⚠️ This will delete mods/ and run/. Are you sure? (y/N): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  rm -rf mods run
  mkdir mods run
  echo "✅ Reset complete"
else
  echo "❌ Reset cancelled"
fi
