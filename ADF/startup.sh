#!/bin/bash

# Setup RDP Session
sudo systemctl enable xrdp
sudo service xrdp restart
sudo systemctl status xrdp

/bin/bash
