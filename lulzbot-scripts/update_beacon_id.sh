#!/bin/bash

##########################################################
# Script to update the Beacon device path in printer.cfg #
# 2025/12/09 by ChatGPT and LulzBot                      #
##########################################################

CFG="/home/pi/printer_data/config/printer.cfg"   # <-- change if needed

# Find Beacon device in /dev/serial/by-id
BEACON_DEV="$(ls /dev/serial/by-id/*Beacon* 2>/dev/null | head -n 1)"

if [[ -z "$BEACON_DEV" ]]; then
    echo "Error: No Beacon device found in /dev/serial/by-id/"
    exit 1
fi

echo "Found Beacon device: $BEACON_DEV"

# Replace the serial line inside the [beacon] section
sed -i "/^\[beacon\]/,/^\[/ s|^serial:.*|serial: $BEACON_DEV|" "$CFG"

echo "Updated printer.cfg successfully."
