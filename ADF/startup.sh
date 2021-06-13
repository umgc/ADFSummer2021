#!/bin/bash

# Set env
echo UID=1000 >> /etc/environment
echo GID=1000 >> /etc/environment
echo USER="developer" >> /etc/environment
echo JAVA_VERSION="11" >> /etc/environment
echo ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip" >> /etc/environment
echo ANDROID_VERSION="29" >> /etc/environment
echo ANDROID_BUILD_TOOLS_VERSION="29.0.3" >> /etc/environment
echo ANDROID_ARCHITECTURE="x86_64" >> /etc/environment
echo ANDROID_SDK_ROOT="/home/$USER/android" >> /etc/environment
echo FLUTTER_CHANNEL="stable" >> /etc/environment
echo FLUTTER_VERSION="2.2.1" >> /etc/environment
echo FLUTTER_DOWNLOAD_FILE="flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz" >> /etc/environment
echo FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_CHANNEL/linux/$FLUTTER_DOWNLOAD_FILE" >> /etc/environment
echo FLUTTER_HOME="/home/$USER/flutter" >> /etc/environment
echo FLUTTER_WEB_PORT="8090" >> /etc/environment
echo FLUTTER_DEBUG_PORT="42000" >> /etc/environment
echo FLUTTER_EMULATOR_NAME="flutter_emulator" >> /etc/environment
echo PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH" >> /etc/environment

# Start pulseaudio as system wide daemon; for debugging it helps to start in non-daemon mode
pulseaudio -D --verbose --exit-idle-time=-1 --system --disallow-exit

# Setup RDP Session
systemctl enable xrdp
service xrdp restart
cd /home/$USER
code --install-extension dart-code.flutter --user-data-dir /home/$USER
systemctl status xrdp

/bin/bash
