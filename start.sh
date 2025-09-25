#!/bin/bash
echo "alias start='unset JAVA_HOME && ./gradlew runClient'" >> ~/.zshrc
source ~/.zshrc
echo "Custom 'start' command added. You can now type: start"
