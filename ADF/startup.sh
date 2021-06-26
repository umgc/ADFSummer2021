#!/bin/bash

# Setup RDP Session
systemctl enable xrdp
service xrdp restart
systemctl status xrdp

/bin/bash
