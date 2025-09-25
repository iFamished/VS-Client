#!/bin/bash

# Step 1: Unset JAVA_HOME
unset JAVA_HOME
echo "🧼 JAVA_HOME cleared"

# Step 2: Detect OS and save to .osinfo
if [[ "$OS" == "Windows_NT" ]] || grep -q Microsoft /proc/version 2>/dev/null; then
  echo "windows" > .osinfo
else
  echo "unix" > .osinfo
fi
echo "💻 OS detected and saved to .osinfo"

# Step 3: Create aliases
echo "alias start='bash $(pwd)/start.sh'" >> ~/.zshrc
echo "alias import-mods='bash $(pwd)/import-mods.sh'" >> ~/.zshrc
echo "alias import-mrpack='bash $(pwd)/import-mrpack.sh'" >> ~/.zshrc
source ~/.zshrc

echo "✅ Setup complete. You can now use: start, import-mods, import-mrpack"
