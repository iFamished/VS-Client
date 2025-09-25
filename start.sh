#!/bin/bash

# Step 1: Ensure JAVA_HOME is set to SDKMAN Java 21
unset JAVA_HOME
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"
echo "🧼 JAVA_HOME set to Java 21 via SDKMAN"

# Step 2: Pull latest from origin/1.21.8, excluding /run
echo "📡 Pulling latest from origin/1.21.8..."
git fetch origin 1.21.8

# Backup /run temporarily
echo "📁 Preserving /run folder..."
mv run run-temp

# Hard reset everything else
git reset --hard origin/1.21.8

# Restore /run
mv run-temp run
echo "✅ Repo updated (excluding /run)"

# Step 3: Launch the client
echo "🚀 Launching VS-Client..."
./gradlew runClient
