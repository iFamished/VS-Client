#!/bin/bash
echo "alias start='unset JAVA_HOME && ./gradlew runClient'" >> ~/.zshrc
source ~/.zshrc
echo "'start' command is now available. Type: start"
