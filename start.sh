#!/bin/bash

# Detect OS and set Downloads path
if [[ "$OS" == "Windows_NT" ]] || grep -q Microsoft /proc/version 2>/dev/null; then
  # Windows (Git Bash or WSL)
  DOWNLOADS="/mnt/c/Users/$USERNAME/Downloads"
else
  # macOS/Linux
  DOWNLOADS="$HOME/Downloads"
fi

MODS="./mods"

# Move all .jar files from Downloads to mods/
find "$DOWNLOADS" -maxdepth 1 -name "*.jar" -exec mv {} "$MODS" \;

echo "✅ Mods imported from $DOWNLOADS to $MODS"

# Clear JAVA_HOME and launch client
unset JAVA_HOME
./gradlew runClient
