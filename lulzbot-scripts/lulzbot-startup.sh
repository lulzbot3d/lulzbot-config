#!/bin/bash

# Plans are, if we need to call a script when the system boots but before klipper starts, we will call it from here.

# BEWARE - this script runs as user root, not as pi.  This can cause issues with file permissions that might
# prevent your script from running properly.  So it might work better to put your script in another file and
# call it from here with a command that runs it as user pi.
# Something like:  sudo -u pi /home/pi/lulzbot-config/lulzbot-scripts/example.sh

echo "Lulzbot Startup Script Start: $(date)" >>/home/pi/printer_data/logs/klippy.log

# Automatically update the Beacon device path in printer.cfg at startup
sudo -u pi /home/pi/lulzbot-config/lulzbot-scripts/update_beacon_id.sh

echo "Lulzbot Startup Script End: $(date)" >>/home/pi/printer_data/logs/klippy.log
