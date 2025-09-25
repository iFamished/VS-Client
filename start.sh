#!/bin/bash

# Detect OS and set Downloads path
if [[ "$OS" == "Windows_NT" ]] || grep -q Microsoft /proc/version 2>/dev/null; then
  DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"
else
  DOWNLOADS="$HOME/Downloads"
fi

MODS="./mods"

# Move Fabric 1.21.8 mods into ./mods
echo "🔍 Scanning $DOWNLOADS for Fabric 1.21.8 mods..."
find "$DOWNLOADS" -maxdepth 1 -iname "*fabric*1.21.8*.jar" -exec mv {} "$MODS" \;

echo "✅ Mods moved to $MODS"

# Clear JAVA_HOME and launch client
unset JAVA_HOME
echo "🧼 JAVA_HOME cleared"
echo "🚀 Launching VS-Client..."
./gradlew runClient
