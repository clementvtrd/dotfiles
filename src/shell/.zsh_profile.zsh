export GPG_TTY=$(tty)

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

export PATH=$PATH:${HOME}/go/bin

# Homebrew
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin

# Android
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/platforms
export PATH=$PATH:/opt/gradle/gradle-7.5.1/bin
export PATH=$PATH:/opt/android-studio/bin
