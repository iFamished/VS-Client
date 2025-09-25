#!/bin/bash

# Detect OS and set Downloads path
if [[ "$OS" == "Windows_NT" ]] || grep -q Microsoft /proc/version 2>/dev/null; then
  DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"
else
  DOWNLOADS="$HOME/Downloads"
fi

MODS="./mods"

# Move only Fabric 1.21.8 mods (basic filter by filename)
find "$DOWNLOADS" -maxdepth 1 -name "*fabric*1.21.8*.jar" -exec mv {} "$MODS" \;

echo "✅ Fabric 1.21.8 mods imported from $DOWNLOADS to $MODS"

# Clear JAVA_HOME and launch client
unset JAVA_HOME
./gradlew runClient
