#!/bin/bash

# Script to UPDATE firmware on a Manta M5P that is already flashed with CAN Bus firmware
# and is already set up with a CAN Bus ID in the printer_ids.cfg file.

# This will NOT work for first time flashing a Manta on a new printer in production.

set -e
cd "$(dirname "$0")"   # Set directory to where this script is at.
sdir=$(pwd)

echo "Flashing Manta by CAN Bus"
echo "This command does NOT compile NEW firmware."
echo "It flashes firmware provided by LulzBot through the Update Manager."
canid=$( awk 'f {print $2; exit} /\[mcu\]/ {f=1}' ~/printer_data/config/.printer_ids.cfg )
echo "Resetting to bootloader."
python3 ~/katapult/scripts/flashtool.py -u $canid -r
sleep 1
echo Flashing MantaM5P
set +e
sudo dfu-util -d ,0483:df11 -R -a 0 -s 0x8002000:leave -D  $sdir/manta.bin
echo "NOTE: An error above saying dfu-util: Error during download get_status is not a true error."
echo "If it says File downloaded successfully it finished OK."
