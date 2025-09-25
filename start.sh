#!/bin/bash

# Step 1: Ensure JAVA_HOME is set to SDKMAN Java 21
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

# Step 2: Clear JAVA_HOME for safety (optional redundancy)
unset JAVA_HOME
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"
echo "🧼 JAVA_HOME set to Java 21 via SDKMAN"

# Step 3: Launch the client
echo "🚀 Launching VS-Client..."
./gradlew runClient
