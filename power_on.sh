#!/bin/bash

# check administrative privileges
if [ "$EUID" -ne "0" ]; then
    echo "You must be root to execute this script."
    exit 1
fi

# check uhubctl exists in PATH
which uhubctl
if [ "$?" -ne "0" ]; then
    echo "The dependency uhubctl is not available in your PATH."
    exit 1
fi

# check usb state exists
stat /tmp/usbstate &> /dev/null
if [ "$?" -ne "0" ]; then
    echo "No USB State found. No device was powered off."
    exit 1
fi

HUB_NAME=$(cat /tmp/usbstate | grep -o "hub [0-9\-]\+" | cut -d ' ' -f 2)
USB_PORT=$(cat /tmp/usbstate | grep -o "Port [0-9]\+" | cut -d ' ' -f 2)

uhubctl -l $HUB_NAME -p $USB_PORT -a on
mount -a
systemctl start smbd
systemctl start smartd
