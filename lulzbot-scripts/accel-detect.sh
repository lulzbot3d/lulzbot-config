#!/bin/bash

# This script automatically enables the Big Tree Tech USB ADXL345 accelerometer
# It looks for the device below, and if found, searches the config file set below,
# for the pattern below, and removes any # characters at the start of that line.
# If not found, it adds a # to the start of the line if there isn't one already.

# Define the device path
DEVICE_PATH="/dev/serial/by-id/usb-Klipper_rp2040_btt_acc-if00"

# Define the output file and configuration file paths
CONFIG_FILE="/home/biqu/printer_data/config/printer.cfg"

# Define the pattern to search for in the configuration file
PATTERN="BTT_USB_ADXL345"

# Check if the device exists
if [ -e "$DEVICE_PATH" ]; then
    # Remove leading # characters from the line containing the pattern
    sed -i "/$PATTERN/s/^#//" "$CONFIG_FILE"
else
    # Add a leading # character to the line containing the pattern if it doesn't already have one
    sed -i "/$PATTERN/s/^[^#]/#&/" "$CONFIG_FILE"
fi
