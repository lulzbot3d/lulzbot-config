#!/bin/bash

# Find directories starting with "usb-sd" in the gcodes folder, delete if empty.
# Cleans up orphaned mount directories for automounted USB flash drives.
find /home/biqu/printer_data/gcodes -type d -name 'usb-sd*' -empty | while read -r dir; do
    rmdir "$dir"
done
