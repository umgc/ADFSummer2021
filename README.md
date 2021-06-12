# ADFSummer2021

Docker image for Flutter/Dart dev in VS Code.

# Use (local):
* Install Docker
* Install image with following commandline -p 3389:63389 --privileged
* If on Linux/Mac, you can also use -p 3389:3389 to have it run on the default RDP port. In Windows, this port might not be available due to the built-in RDP server.
* The --privileged is needed for Chrome to run in Docker. The only alternaitve is running Chrome with the --no-sandbox flag. This requires more research, as there are security implications.
* Connect via RDP @ localhost:63389
* Clone repository
* From repository run command code .

# TODO:
* Pass developer password
* Test sound
* Test Emulator
* Create user manual
* Add Flutter/Dart to path (in .rcbash or startup.sh???)


# Changelog:
* Removed version A as X11 pass a no-go due to no sound, and difficulty on Windows.
* Renamed version B dir to ADF
* Set default password ('password') for developer, as passwordless login was not working on Linux.
* Set right terminal in update-alternatives so terminal button works.
* Added PulseAudio (does not seem to work yet)
* Added chmod 777 to start-up script. When built on Linux, the script on the local file system, and thus in the container is not executable.
* Commented out line that sets mirrors. Some mirrors were outdated, and this would halt the build.
* Updated readme, including comment about --privileged.