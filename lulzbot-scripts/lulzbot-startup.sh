#!/bin/bash

# Plans are, if we need to call a script when the system boots but before klipper starts, we will call it from here.

# BEWARE - this script runs as user root, not as pi.  This can cause issues with file permissions that might
# prevent your script from running properly.  So it might work better to put your script in another file and
# call it from here with a command that runs it as user pi.
# Something like:  sudo -u pi /home/pi/lulzbot-config/lulzbot-scripts/example.sh

echo "Lulzbot Startup Script Start: $(date)" >>/home/pi/printer_data/logs/lulzbot-startup.log

# Automatically update the Beacon device path in printer.cfg at startup
sudo -u pi /home/pi/lulzbot-config/lulzbot-scripts/update_beacon_id.sh >>/home/pi/printer_data/logs/lulzbot-startup.log

# Make sure the eth_mode script is in sudoers so it can be called from a macro without a password
# Note, this one does not use "sudo -u pi" because the setup_sudoers function needs to run as root to modify the sudoers file.
/home/pi/lulzbot-config/lulzbot-scripts/eth_mode.sh setup_sudoers >>/home/pi/printer_data/logs/lulzbot-startup.log

# Apply the saved Ethernet mode (if any) at startup
/home/pi/lulzbot-config/lulzbot-scripts/eth_mode.sh apply >>/home/pi/printer_data/logs/lulzbot-startup.log

# Ensure the timedatectl command is in sudoers so it can be called from the KlipperScreen timezone panel without a password
/home/pi/lulzbot-config/lulzbot-scripts/timedatectl-nopasswd.sh >>/home/pi/printer_data/logs/lulzbot-startup.log

echo "Lulzbot Startup Script End: $(date)" >>/home/pi/printer_data/logs/lulzbot-startup.log
echo >>/home/pi/printer_data/logs/lulzbot-startup.log
