#!/bin/bash

# Create mod import script
cat << 'EOF' > import-mods.sh
#!/bin/bash
DOWNLOADS=~/Downloads
MODS=./mods
find "$DOWNLOADS" -maxdepth 1 -name "*.jar" -exec mv {} "$MODS" \;
echo "✅ Mods imported from Downloads to ./mods/"
EOF

chmod +x import-mods.sh

# Add alias to .zshrc
echo "alias start='unset JAVA_HOME && ./import-mods.sh && ./gradlew runClient'" >> ~/.zshrc
source ~/.zshrc

echo "✅ 'start' command is now available. Type: start"
