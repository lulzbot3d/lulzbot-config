#!/bin/bash

# testing 123

# A test to see if we can write to the log before klipper starts
d=$(date)
echo "Lulzbot Startup Script $d" >>/home/biqu/printer_data/logs/klippy.log
