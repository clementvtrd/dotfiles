export GPG_TTY=$(tty)

export PATH=$PATH:${HOME}/go/bin

# Homebrew
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin

# Android
export ANDROID_SDK_ROOT=$HOME/Library/Android/Sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/platforms
export PATH=$PATH:/opt/gradle/gradle-7.5.1/bin
export PATH=$PATH:/opt/android-studio/bin

# Java
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
