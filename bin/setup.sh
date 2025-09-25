#!/bin/bash

unset JAVA_HOME
echo "🧼 JAVA_HOME cleared"

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
  echo "📦 Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
else
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install Java 21
echo "☕ Installing Java 21..."
sdk install java 21.0.1-tem
sdk use java 21.0.1-tem

# Set JAVA_HOME and PATH
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

# Install jq if missing
if ! command -v jq >/dev/null 2>&1; then
  echo "📦 Installing jq..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update && sudo apt install -y jq
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
      brew install jq
    else
      echo "❌ Homebrew not found. Please install jq manually."
    fi
  else
    echo "❌ Unsupported OS for auto-installing jq. Please install manually."
  fi
else
  echo "✅ jq is already installed"
fi

# Add aliases to shell configs
for shellrc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.config/fish/config.fish"; do
  [ -f "$shellrc" ] || continue

  echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$shellrc"
  echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\"" >> "$shellrc"

  echo "alias start='bash $(pwd)/bin/start.sh'" >> "$shellrc"
  echo "alias reset='bash $(pwd)/bin/reset.sh'" >> "$shellrc"
  echo "alias update-mods='bash $(pwd)/bin/update-mods.sh'" >> "$shellrc"
  echo "alias install-mod='bash $(pwd)/bin/install-mod.sh'" >> "$shellrc"
  echo "alias install-modpack='bash $(pwd)/bin/install-modpack.sh'" >> "$shellrc"
  echo "alias uninstall-mod='bash $(pwd)/bin/uninstall-mod.sh'" >> "$shellrc"
  echo "alias list-mods='bash $(pwd)/bin/list-mods.sh'" >> "$shellrc"
  echo "alias clean='bash $(pwd)/bin/clean.sh'" >> "$shellrc"
  echo "alias help='bash $(pwd)/bin/help.sh'" >> "$shellrc"
done

# Detect OS
[[ "$OS" == "Windows_NT" || $(grep -q Microsoft /proc/version 2>/dev/null) ]] && echo "windows" > .osinfo || echo "unix" > .osinfo

# Create folders
mkdir -p mods run
echo "📁 Ensured mods/ and run/ folders exist"

echo "✅ Setup complete. Run 'source ~/.bashrc' or 'source ~/.zshrc' to activate aliases."