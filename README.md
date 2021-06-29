# ADFSummer2021

Docker image for dev environment.

# Use (local):
* Install Docker
* Install image with following commandline -p 3389:63389 --privileged
* If on Linux/Mac, you can also use -p 3389:3389 to have it run on the default RDP port. In Windows, this port might not be available due to the built-in RDP server.
* The --privileged is needed for Chrome to run in Docker. The only alternative is running Chrome with the --no-sandbox flag. This requires more research, as there are security implications.
* Connect via RDP @ localhost:63389
* Clone repository
* From repository run command code .

# TODO:
* Test sound
* Test Emulator
* Create user manual
* Chrome crashes often
* GUI push/pull app

# Changelog:
Rob 6/28/2021
* Change build order to keep most things cached during build and only rebuild items likely to change
* Remove second Dart Install command
* Convert CRLF -> LF
* Allow passwords to be passed in via environment variable

Jeroen 6/26/2021
* Add Welcome Screen

Jeroen 06/14/2021
* Fixed sound

Jeroen 06/13/2021
* Removed version A as X11 pass a no-go due to no sound, and difficulty on Windows.
* Renamed version B dir to ADF
* Set default password ('password') for developer, as passwordless login was not working on Linux.
* Set right terminal in update-alternatives so terminal button works.
* Added PulseAudio (does not seem to work yet)
* Added chmod 777 to start-up script. When built on Linux, the script on the local file system, and thus in the container is not executable.
* Commented out line that sets mirrors. Some mirrors were outdated, and this would halt the build.
* Updated readme, including comment about --privileged.
