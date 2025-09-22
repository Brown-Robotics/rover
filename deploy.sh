#!/usr/bin/env bash

set -e

# Check for root privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "Script must be run as root."
  exit 1
fi

echo "NB: raspi-config must be done manually."
echo "See https://github.com/nasa-jpl/osr-rover-code/blob/master/setup/rpi.md#enabling-serial-and-i2c."

# Put setup commands that must be run outside the container here.
cp ./config/* /etc/udev/rules.d/
udevadm control --reload-rules && udevadm trigger

adduser $USER tty
adduser $USER dialout
adduser $USER input
