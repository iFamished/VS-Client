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

# Step 3: Create 'start' alias in shell config
ALIAS_CMD="alias start='bash $(pwd)/start.sh'"
if ! grep -Fxq "$ALIAS_CMD" ~/.zshrc; then
  echo "$ALIAS_CMD" >> ~/.zshrc
  echo "🔗 'start' alias added to ~/.zshrc"
fi

# Reload shell config
source ~/.zshrc
echo "✅ Setup complete. You can now type: start"
