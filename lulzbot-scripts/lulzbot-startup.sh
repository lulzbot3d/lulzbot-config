#!/bin/bash

# Plans are, if we need to call a script when the system boots but before klipper starts, we will call it from here.

# BEWARE - this script runs as user root, not as biqu.  This can cause issues with file permissions that might
# prevent your script from running properly.  So it might work better to put your script in another file and
# call it from here with a command that runs it as user biqu.
# Something like:  sudo -u biqu /home/biqu/lulzbot-config/lulzbot-scripts/example.sh

echo "Lulzbot Startup Script Start: $(date)" >>/home/biqu/printer_data/logs/klippy.log

# This script detects if the acceleromter is present and uncomments the include line in printer.cfg.
sudo -u biqu /home/biqu/lulzbot-config/lulzbot-scripts/accel-detect.sh

# This script removes any orphaned and empty usb-sda folders in the gcodes folder.
# These can be left behind if you pull the flash drive while still in the folder.
sudo -u biqu /lulzbot-config/lulzbot-scripts/USB_Automount/cleanup_usb.sh

echo "Lulzbot Startup Script End: $(date)" >>/home/biqu/printer_data/logs/klippy.log
