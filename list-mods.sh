#!/bin/bash

echo "📦 Installed mods:"
ls mods/*.jar 2>/dev/null | sed 's/mods\///' || echo "❌ No mods found"