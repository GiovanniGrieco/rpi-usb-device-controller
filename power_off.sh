#!/bin/bash

DEVICE_NAME="Western Digital"

# check administrative privileges
if [ "$EUID" -ne "0" ]; then
    echo "You must be root to execute this script."
    exit 1
fi

# check uhubctl exists in PATH
which uhubctl &> /dev/null
if [ "$?" -ne "0" ]; then
    echo "The dependency uhubctl is not available in your PATH."
    exit 1
fi

uhubctl -s "$DEVICE_NAME" > /tmp/usbstate

systemctl stop smartd
systemctl stop smbd
umount /mnt
uhubctl -s "$DEVICE_NAME" -a off
