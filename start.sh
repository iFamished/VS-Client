#!/bin/bash

unset JAVA_HOME
echo "🧼 JAVA_HOME cleared"

echo "🚀 Launching VS-Client..."
./gradlew runClient
