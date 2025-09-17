#!/usr/bin/env bash

set -e

# Check for root privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "Script must be run as root."
  exit 1
fi

# Put setup commands that must be run outside the container here.
cp ./config/* /etc/udev/rules.d/
udevadm control --reload-rules && udevadm trigger

# TODO: raspi-config setup, might have to be manual.