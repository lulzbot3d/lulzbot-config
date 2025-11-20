#!/bin/bash

# Plans are, if we need to call a script when the system boots but before klipper starts, we will call it from here.

# BEWARE - this script runs as user root, not as biqu.  This can cause issues with file permissions that might
# prevent your script from running properly.  So it might work better to put your script in another file and
# call it from here with a command that runs it as user biqu.
# Something like:  sudo -u biqu /home/biqu/lulzbot-config/lulzbot-scripts/example.sh

echo "Lulzbot Startup Script Start: $(date)" >>/home/biqu/printer_data/logs/klippy.log

# This fixes an issue where sudo commands hang for 5 to 10 seconds if the hostname is not in /etc/hosts.
HOST=$(hostname); grep -qxF "127.0.0.1   $HOST" /etc/hosts || echo "127.0.0.1   $HOST" | sudo tee -a /etc/hosts > /dev/null

# This script detects if the acceleromter is present and uncomments the include line in printer.cfg.
sudo -u biqu /home/biqu/lulzbot-config/lulzbot-scripts/accel-detect.sh

# This script removes any orphaned and empty usb-sda folders in the gcodes folder.
# These can be left behind if you pull the flash drive while still in the folder.
sudo -u biqu /lulzbot-config/lulzbot-scripts/USB_Automount/cleanup_usb.sh

# This fixes an issue where the URL for the backports repo changed and broke System updates in Update Manager.
# We don't seem to need the backports repo, so the script comments it out in the sources file.
# Note: This needs to be run as root, so it is not run as user biqu.
/home/biqu/lulzbot-config/lulzbot-scripts/disable-backports.sh

# Comment out the xrandr commands in /etc/rc.local that set the refresh rate to 40 Hz.
# I don't think it ever helped with the issue I thought it helped, and it is causing problems with our new HDMI5 screens.
sudo sed -i 's/^[[:space:]]*\(sudo xrandr\)/# \1/' /etc/rc.local

echo "Lulzbot Startup Script End: $(date)" >>/home/biqu/printer_data/logs/klippy.log
