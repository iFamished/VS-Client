#!/bin/bash

echo -e "\033[1;36m🆘 VS-Client Help Menu\033[0m"
echo "Here are all available commands and what they do:"
echo

echo -e "\033[1;33mstart\033[0m"
echo "  Launches the Minecraft client with current mod profile."

echo -e "\033[1;33mimport-mods <folder>\033[0m"
echo "  Imports all .jar mods from the specified folder into ./mods."

echo -e "\033[1;33mimport-mrpack <file.mrpack>\033[0m"
echo "  Extracts and installs mods from a Modrinth .mrpack file."

echo -e "\033[1;33minstall-mod <mod> [version] [loader]\033[0m"
echo "  Installs a mod from Modrinth by name or direct URL."
echo "  - mod: name or Modrinth URL"
echo "  - version: optional Minecraft version (default: 1.21.8)"
echo "  - loader: optional mod loader (default: fabric)"
echo "  Automatically installs dependencies."

echo -e "\033[1;33mupdate-mods\033[0m"
echo "  Checks for updates to installed mods and downloads newer versions."

echo -e "\033[1;33mdoctor\033[0m"
echo "  Runs diagnostics to check for missing folders, Java setup, and core dependencies."

echo -e "\033[1;33mreset\033[0m"
echo "  Clears the run folder and resets the mod environment."

echo -e "\033[1;33mpreview\033[0m"
echo "  Shows a summary of the current mod setup and environment."

echo -e "\033[1;33msave-profile <name>\033[0m"
echo "  Saves the current mod list as a named profile."

echo -e "\033[1;33mload-profile <name>\033[0m"
echo "  Loads a saved mod profile into the mods folder."

echo -e "\033[1;33mhelp\033[0m"
echo "  Displays this help menu."

echo
echo -e "\033[1;32m✅ Tip:\033[0m You can run \033[1;33msource setup.sh\033[0m to refresh aliases anytime."
