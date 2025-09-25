#!/bin/bash
DOWNLOADS=~/Downloads
MODS=./mods

# Move all .jar files from Downloads to mods/
find "$DOWNLOADS" -maxdepth 1 -name "*.jar" -exec mv {} "$MODS" \;

echo "✅ Mods imported from Downloads to ./mods/"
