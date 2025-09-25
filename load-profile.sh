#!/bin/bash
if [ -d "profiles/$1" ]; then
  rm -rf mods
  cp -r "profiles/$1" mods
  echo "✅ Loaded profile: $1"
else
  echo "❌ Profile not found: $1"
fi
