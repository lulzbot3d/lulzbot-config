#!/bin/bash

# Script to UPDATE firmware on an EBB that is already flashed
# with the Katapult bootloader, Klipper firmware,
# and is already set up with a CAN Bus ID in the printer_ids.cfg file.

# This will NOT work for first time flashing an EBB on a new printer in production.

set -e
cd "$(dirname "$0")"   # Set directory to where this script is at.
sdir=$(pwd)

echo "Flashing EBB36 by CAN Bus"
echo "This command does NOT compile NEW firmware."
echo "It flashes firmware provided by LulzBot through the Update Manager."
canid=$( awk 'f {print $2; exit} /\[mcu EBBCan\]/ {f=1}' ~/printer_data/config/.printer_ids.cfg )
python3 ~/katapult/scripts/flashtool.py -i can0 -f $sdir/ebb.bin -u $canid
