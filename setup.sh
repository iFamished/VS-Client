#!/bin/bash

# Step 1: Unset JAVA_HOME
unset JAVA_HOME
echo "🧼 JAVA_HOME cleared"

# Step 2: Install SDKMAN if missing
if [ ! -d "$HOME/.sdkman" ]; then
  echo "📦 Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
else
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Step 3: Install Java 21 and activate it
echo "☕ Installing Java 21..."
sdk install java 21.0.1-tem
sdk use java 21.0.1-tem

# Step 4: Set JAVA_HOME and PATH
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

# Step 5: Persist to shell config
CONFIG="$HOME/.zshrc"
grep -qxF "export JAVA_HOME=\"$JAVA_HOME\"" "$CONFIG" || echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$CONFIG"
grep -qxF "export PATH=\"\$JAVA_HOME/bin:\$PATH\"" "$CONFIG" || echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\"" >> "$CONFIG"

echo "✅ Java 21 installed and JAVA_HOME set"

# Step 6: Detect OS and save to .osinfo
if [[ "$OS" == "Windows_NT" ]] || grep -q Microsoft /proc/version 2>/dev/null; then
  echo "windows" > .osinfo
else
  echo "unix" > .osinfo
fi
echo "💻 OS detected and saved to .osinfo"

# Step 7: Create aliases
echo "alias start='bash $(pwd)/start.sh'" >> "$CONFIG"
echo "alias import-mods='bash $(pwd)/import-mods.sh'" >> "$CONFIG"
echo "alias import-mrpack='bash $(pwd)/import-mrpack.sh'" >> "$CONFIG"
source "$CONFIG"

echo "✅ Setup complete. You can now use: start, import-mods, import-mrpack"
