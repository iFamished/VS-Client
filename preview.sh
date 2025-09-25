#!/bin/bash
echo "📦 Mods:"
ls mods/*.jar 2>/dev/null || echo "  (none)"

echo "📁 Run folders:"
ls run 2>/dev/null || echo "  (none)"
