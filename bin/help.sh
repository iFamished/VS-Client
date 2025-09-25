#!/bin/bash

echo -e "\033[1;36m🆘 VS-Client Help Menu\033[0m"
echo

echo -e "\033[1;33mstart\033[0m"
echo "  Launches Minecraft with the current mod setup."

echo -e "\033[1;33minstall-mod <mod> [version] [loader]\033[0m"
echo "  Installs a mod from Modrinth by name or URL."
echo "  Uses config.json for defaults. Installs dependencies."

echo -e "\033[1;33minstall-modpack <modpackname/fullurl>\033[0m"
echo "  Installs a Modrinth modpack."
echo "  Prompts for full or selective overwrite of /run folder."

echo -e "\033[1;33muninstall-mod <modname>\033[0m"
echo "  Removes a mod from the mods folder by name (fuzzy match)."

echo -e "\033[1;33mlist-mods\033[0m"
echo "  Lists all installed mods in the mods folder."

echo -e "\033[1;33mupdate-mods\033[0m"
echo "  Checks for updates to installed mods and downloads newer versions."

echo -e "\033[1;33mreset\033[0m"
echo "  Clears the run folder and resets the mod environment."

echo -e "\033[1;33mclean\033[0m"
echo "  Removes duplicate mods from the mods folder, keeping the latest version."

echo -e "\033[1;33mhelp\033[0m"
echo "  Displays this help menu."

echo
echo -e "\033[1;32m🧩 config.json:\033[0m Stores default Minecraft version and loader used by install-mod."