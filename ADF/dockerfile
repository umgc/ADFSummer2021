# The ADF is based on an existing Docker image. In our case start with Ubuntu 20.04, which is the current LTS version. 
FROM ubuntu:20.04

# Set several environmental variables and constants. 
ENV UID=1000
ENV GID=1000
ENV USER="developer"
ENV PASSWORD="password"
# Use Java version 8. Version 11 crashes the emulator creation process.
ENV JAVA_VERSION="8"
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"
ENV ANDROID_VERSION="29"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV ANDROID_ARCHITECTURE="x86_64"
ENV ANDROID_SDK_ROOT="/home/$USER/android"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="2.2.1"
ENV FLUTTER_DOWNLOAD_FILE="flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_CHANNEL/linux/$FLUTTER_DOWNLOAD_FILE"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV FLUTTER_WEB_PORT="8090"
ENV FLUTTER_DEBUG_PORT="42000"
ENV FLUTTER_EMULATOR_NAME="flutter_emulator"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH"

# This next line prevents Code from showing a dialog asking if you want to run VS Code locally when on a Windows host. 
ENV DONT_PROMPT_WSL_INSTALL=True

# Enable the source repositories in sources.list. This allows apt-get to download sources so you can build locally. It is needed when building the XRDP sound module. 
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# Setting this to non-interactive prevents CLI applications from requiring user input while building the image. This would freeze the build. 
ENV DEBIAN_FRONTEND noninteractive

# Download the latest repository info, and install the window system. 
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        apt-utils xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils supervisor sudo wget \
    && apt-get autoclean -y \
    && apt-get autoremove -y
    
# Install PulseAudio
RUN apt-get install -y pavucontrol pulseaudio pulseaudio-utils xfce4-pulseaudio-plugin
RUN apt-get install git libpulse-dev autoconf m4 intltool build-essential dpkg-dev -y
RUN apt-get build-dep pulseaudio -y

WORKDIR /tmp
RUN apt-get source pulseaudio && pulsever=$(pulseaudio --version | awk '{print $2}') && cd /tmp/pulseaudio-${pulsever} && ./configure

# Build xrdp sound modules. Up to Ubuntu 16 you could just apt-get this, but for unknown reason we now have to build this. 
# This clones the source for the modules, then uses make to configure, build, and install. 
WORKDIR /tmp
RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /tmp/pulseaudio-module-xrdp/
WORKDIR /tmp/pulseaudio-module-xrdp/
RUN ./bootstrap
RUN pulsever=$(pulseaudio --version | awk '{print $2}') && ./configure PULSE_DIR="/tmp/pulseaudio-$pulsever" && make install

# Install qemu, which is needed for the Android emulator. 
RUN apt-get install -y qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Install XRDP, the remote desktop server. 
RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
        systemctl xrdp xorgxrdp

# Make sure root can start the XRDP server on startup. 
RUN sudo adduser xrdp ssl-cert

# Install JDK and several required utilities. 
RUN apt-get install --yes --no-install-recommends openjdk-$JAVA_VERSION-jdk curl unzip sed git bash xz-utils libglvnd0 ssh xauth x11-xserver-utils libpulse0 libxcomposite1 libgl1-mesa-glx

# Allow password-less sudo 
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set default password to 'password'
RUN groupadd --gid $GID $USER \
  && useradd -s /bin/bash --uid $UID --gid $GID -m $USER -p "$(openssl passwd -1 ${PASSWORD})"

RUN usermod -aG sudo developer

WORKDIR /home/$USER

# Set default terminal t xfce4-terminal, so button at bottom works
RUN update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper

# Install VS Code
RUN wget "https://go.microsoft.com/fwlink/?LinkID=760868" -O vscode.deb
RUN sudo apt-get install -y ./vscode.deb

# Install .Net
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN sudo dpkg -i packages-microsoft-prod.deb

RUN sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0

RUN sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-5.0

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb

# Install NodeJS
RUN apt-get install -y nodejs

# Install Android SDK and CLI tools 
RUN mkdir -p $ANDROID_SDK_ROOT \
  && mkdir -p /home/$USER/.android \
  && touch /home/$USER/.android/repositories.cfg \
  && curl -o android_tools.zip $ANDROID_TOOLS_URL \
  && unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
  && rm android_tools.zip \
  && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
  && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
  && yes "y" | sdkmanager "platform-tools" \
  && yes "y" | sdkmanager "emulator" \
  && yes "y" | sdkmanager --install "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE"

# Install Flutter 
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME \
  && flutter config --no-analytics \
  && flutter precache \
  && yes "y" | flutter doctor --android-licenses \
  && flutter doctor \
  && flutter emulators --create \
  && flutter update-packages

# Install Iceweasal a.k.a. Firefox
RUN apt-get -y install iceweasel \
    && rm -rf /var/lib/apt/lists/*

# Set environment through /etc/profile. This means it will execute whenever anyone logs in 
RUN echo export UID=1000 >> /etc/profile
RUN echo export GID=1000 >> /etc/profile
RUN echo export JAVA_VERSION="11" >> /etc/profile
RUN echo export ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip" >> /etc/profile
RUN echo export ANDROID_VERSION="29" >> /etc/profile
RUN echo export ANDROID_BUILD_TOOLS_VERSION="29.0.3" >> /etc/profile
RUN echo export ANDROID_ARCHITECTURE="x86_64" >> /etc/profile
RUN echo export ANDROID_SDK_ROOT="/home/$USER/android" >> /etc/profile
RUN echo export FLUTTER_CHANNEL="stable" >> /etc/profile
RUN echo export FLUTTER_VERSION="2.2.1" >> /etc/profile
RUN echo export FLUTTER_DOWNLOAD_FILE="flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz" >> /etc/profile
RUN echo export FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_CHANNEL/linux/$FLUTTER_DOWNLOAD_FILE" >> /etc/profile
RUN echo export FLUTTER_HOME="/home/$USER/flutter" >> /etc/profile
RUN echo export FLUTTER_WEB_PORT="8090" >> /etc/profile
RUN echo export FLUTTER_DEBUG_PORT="42000" >> /etc/profile
RUN echo export FLUTTER_EMULATOR_NAME="flutter_emulator" >> /etc/profile
RUN echo export PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH" >> /etc/profile
RUN echo export HOME=/home/$USER >> /etc/profile
RUN echo export SHELL=/bin/bash >> /etc/profile
RUN echo export DONT_PROMPT_WSL_INSTALL=True >> /etc/profile
RUN echo 'pulseaudio &' >> /etc/profile
RUN echo 'adfwelcome &' >> /etc/profile

# Rob 06/28/2021 Re-Order to reduce cache invalidation of from sections that might get changed more frequently.
RUN chmod 777 -R /home/developer

# Flutter cache is in /root/ because dockerfile runs as root. Might have to reevaluate this, but since
# the system is a single user system and is reset every time the image is booted, it doesn't really
# matter to give everybody access to /root/.
RUN chmod 777 -R /root/

# Copy the startup.sh file into the container. 
COPY startup.sh /bin/startup.sh

# Copy wallpaper into the container 
COPY wallpaper.jpg /usr/share/backgrounds/xfce/
# Copy default desktop config file so default wallpaper will be the one we just copied.
COPY xfce4-desktop.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

# Make sure scripts have enough permission to run and start Pulse audio. 
RUN chmod 777 /bin/startup.sh 
RUN adduser root pulse-access
RUN adduser developer pulse-access
RUN gpasswd -a $USER kvm

# Add developer to group systemd-resolve so developer can access /dev/kvm
RUN adduser developer systemd-resolve 

# Make ports available outside container. 
EXPOSE 80
EXPOSE 3389

# Set additional environmental variables. 
ENV HOME=/home/$USER \
    SHELL=/bin/bash \
    DONT_PROMPT_WSL_INSTALL=True
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health

USER $USER

# Create emulator for developer
RUN flutter emulators --create

# Copy desktop launchers into container
COPY *.desktop /home/$USER/Desktop/

# Make them executable
RUN sudo chmod 777 /home/$USER/Desktop/*.desktop

# Install Dart/Flutter extensions for Code
RUN /usr/bin/code --install-extension dart-code.flutter --user-data-dir /home/$USER

# Install ADF welcome app 
RUN wget https://github.com/umgc/ADFWelcome/releases/download/1.0.0/adfwelcome_1.0.0_amd64.deb -O /tmp/adfwelcome_1.0.0_amd64.deb
RUN sudo dpkg -i /tmp/adfwelcome_1.0.0_amd64.deb

# Execute startup.sh when container starts. 
ENTRYPOINT ["/bin/startup.sh"]