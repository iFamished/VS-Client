# VSClient

## Setup

**Important!! Use the built-in bash terminal in VSCode to run all the below commands.**
- Install [Visual Studio Code](https://code.visualstudio.com/download)
- Install [Java 21 (JDK)](https://www.oracle.com/java/technologies/javase/jdk21-archive-downloads.html) from the link or by using this command:
```
curl -L -o jdk21.tar.gz https://download.oracle.com/java/21/latest/jdk-21_macos-x64_bin.tar.gz && \
mkdir -p ~/java/jdk-21 && \
tar -xzf jdk21.tar.gz -C ~/java/jdk-21 --strip-components=1 && \
rm jdk21.tar.gz && \
echo 'export JAVA_HOME=~/java/jdk-21' >> ~/.zshrc && \
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc && \
source ~/.zshrc
```

Once you have met all the requirements, run this command:
```
git clone https://github.com/iFamished/VS-Client.git && cd VS-Client
```
After the repository is cloned, you can launch the game. Launch using this command:
```
./gradlew runClient
```
And you're good to go. To add mods, drop mods into the Mod Menu.


## Credits and license

Huge thank you to everyone who has developed and built the mods and resourcepacks pre-installed in this modpack.

This template is available under the CC0 license. Feel free to learn from it and incorporate it in your own projects.
