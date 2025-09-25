#!/bin/bash

export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

unset JAVA_HOME
echo "🧼 JAVA_HOME cleared"

echo "🚀 Launching VS-Client..."
./gradlew runClient
