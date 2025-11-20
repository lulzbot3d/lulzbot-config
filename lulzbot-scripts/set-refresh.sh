#!/bin/bash

# Turns out this never runs, apparently I copied the lines below directly into the
# /etc/rc.local file.  But now that's causing an issue with our new batch of HDMI5
# screens, so I'll have to add a magic command to the lulzbot-startup.sh script to
# comment out the xrander lines there and let the OS pick the right refresh rate.

# Add 40 and 35 Hz refresh modes for HDMI5 touchscreen, set to 40Hz.
export DISPLAY=:0.0
sudo xrandr --newmode "800x480_40.00" 19.50 800 824 896 992 480 483 493 496 -hsync +vsync
sudo xrandr --verbose --addmode HDMI-1 "800x480_40.00"
sudo xrandr --newmode "800x480_35.00" 17.00 800 824 896 992 480 483 493 496 -hsync +vsync
sudo xrandr --verbose --addmode HDMI-1 "800x480_35.00"
sudo xrandr --output HDMI-1 --mode "800x480_40.00"
