#!/bin/bash

systemctl enable xrdp
service xrdp restart
cd /home/$USER
code --install-extension dart-code.flutter --user-data-dir /home/$USER
systemctl status xrdp

/bin/bash
