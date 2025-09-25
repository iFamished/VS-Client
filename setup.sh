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

# Step 5: Persist to shell config (shell-agnostic)
for shellrc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.config/fish/config.fish"; do
  if [ -f "$shellrc" ]; then
    grep -qxF "export JAVA_HOME=\"$JAVA_HOME\"" "$shellrc" || echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$shellrc"
    grep -qxF "export PATH=\"\$JAVA_HOME/bin:\$PATH\"" "$shellrc" || echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\"" >> "$shellrc"

    echo "alias start='bash $(pwd)/start.sh'" >> "$shellrc"
    echo "alias import-mods='bash $(pwd)/import-mods.sh'" >> "$shellrc"
    echo "alias import-mrpack='bash $(pwd)/import-mrpack.sh'" >> "$shellrc"
    echo "alias reset='bash $(pwd)/reset.sh'" >> "$shellrc"
    echo "alias preview='bash $(pwd)/preview.sh'" >> "$shellrc"
    echo "alias update-mods='bash $(pwd)/update-mods.sh'" >> "$shellrc"
    echo "alias save-profile='bash $(pwd)/save-profile.sh'" >> "$shellrc"
    echo "alias load-profile='bash $(pwd)/load-profile.sh'" >> "$shellrc"
    echo "alias install-mod='bash $(pwd)/install-mod.sh'" >> "$shellrc"
  fi
done

echo "✅ Java 21 installed and aliases added"

# Step 6: Detect OS and save to .osinfo
if [[ "$OS" == "Windows_NT" ]] || grep -q Microsoft /proc/version 2>/dev/null; then
  echo "windows" > .osinfo
else
  echo "unix" > .osinfo
fi
echo "💻 OS detected and saved to .osinfo"

# Step 7: Ensure mods/ and run/ folders exist
mkdir -p mods run
echo "📁 Ensured mods/ and run/ folders exist"

echo "✅ Setup complete. You can now use: start, import-mods, import-mrpack, doctor, reset, preview, update-mods, save-profile, load-profile, install-mod"
