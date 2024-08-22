#!/bin/bash

# Check if BTT ADXL345 is connected in boot mode
is_btt_adxl345_connected() {
    if lsusb | grep -q "Raspberry Pi RP2 Boot"; then
        return 0  # Device is connected
    else
        return 1  # Device is not connected
    fi
}

set -e
cd "$(dirname "$0")"   # Set directory to where this script is at.
sdir=$(pwd)

echo
echo -e "Flashing BTT ADXL345 Accelerometer"
echo
echo "This command does NOT compile NEW firmware."
echo "It flashes firmware provided by LulzBot through the Update Manager."
echo
echo If the accelerometer is already plugged in by USB, disconnect it.
echo Then hold the boot button on the side of the board,
echo plug the USB cable in, and let go of the boot button.
echo 
echo Waiting for USB connection.
echo
while true; do
    if is_btt_adxl345_connected; then
        echo 
        echo -e "Found RP2040 in boot mode."
        echo
        break  # Exit the loop when the device is connected
    else
        echo -n "."
        sleep 1  # Wait for 1 seconds before checking again
    fi
done
cd ~/klipper
python3 ./scripts/flash_usb.py -t "rp2040" -d "2e8a:0003" $sdir/BTT_ADXL345_USB.uf2
