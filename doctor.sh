#!/bin/bash
echo "🩺 Running VS-Client diagnostics..."

java -version 2>/dev/null || echo "❌ Java not found"
[ -d "mods" ] || echo "❌ Missing folder: mods"
[ -d "run" ] || echo "❌ Missing folder: run"
[ -f ".osinfo" ] || echo "❌ Missing .osinfo file"

bash check-deps.sh

echo "✅ Diagnostics complete"
