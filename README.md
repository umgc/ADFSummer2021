# ADFSummer2021

Docker image for Flutter/Dart dev in VS Code.

## Use:
* Install Docker
* Install and start an X11 server if on Windows (for example VcXsrv)
* Install VS Code
* Launch VS Code Quick Open (Ctrl+P), paste the following command, and press enter: ext install ms-vscode-remote.remote-containers
* Clone repository
* Launch VS Code Quick Open (Ctrl+P), find Remote-Containers: Open Folder in Container
* Choose directory in which repository is cloned.
* Docker image will be build. You can follow progress by clicking on View Log in bottom right of the VS Code screen.
* When done, open up a terminal and confirm you are in the image with 'whoami', which should return 'developer'.
* This is a full Flutter/Dart environment running in Docker, with files saved in the host file system.
* Start a new Flutter project with 'flutter create testapp'
* 'cd testapp'
* 'flutter run' should launch Chrome and show the app. It doesn't. You can see why if you run 'google-chrome'. You CAN start Chrome with 'google-chrome --no-sandbox' to confirm that X11 works.

## TODO: 
* Fix Chrome error, so it will start without --no-sandbox and thus will work when flutter run tries to start it.
* Add sound tunneling (dev will build speech-to-text and text-to-speech).
* Add an Android emulator and run over X11 or on host and tunnel.
* Add support for physical Android device (see https://blog.codemagic.io/how-to-dockerize-flutter-apps/ )
