#!/bin/bash

# Step 1: Read OS info
OS=$(cat .osinfo)

if [[ "$OS" == "windows" ]]; then
  DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"
else
  DOWNLOADS="$HOME/Downloads"
fi

MODS="./mods"

# Step 2: Move Fabric 1.21.8 mods
echo "📦 Scanning $DOWNLOADS for Fabric 1.21.8 mods..."
find "$DOWNLOADS" -maxdepth 1 -iname "*fabric*1.21.8*.jar" -exec mv {} "$MODS" \;
echo "✅ Mods moved to $MODS"

# Step 3: Clear JAVA_HOME
unset JAVA_HOME
echo "🧼 JAVA_HOME cleared"

# Step 4: Launch client
echo "🚀 Launching VS-Client..."
./gradlew runClient
