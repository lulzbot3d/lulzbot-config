#!/bin/bash

# Script for flashing the Duet 6HC board in the AMOS printer.
# by LulzBot, Carl Smith, October 30, 2025
# Initially written by ChatGPT with much modification by me.

# Normal Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

cd "$(dirname "$0")"   # Set directory to where this script is at.
sdir=$(pwd)            # And save script directory

cd ~/klipper  # Not sure why, but need to be here for the flash_usb.py script to work.

# Device paths
DUET_NORMAL="/dev/serial/by-id/usb-Duet3D_Duet-if00"
DUET_ERASED="/dev/serial/by-id/usb-03eb_6124-if00"

# Find any device that looks like a Duet 6HC, so it will flash fixed or chip ID boards.
KLIPPER_DEVICE=$(ls /dev/serial/by-id/usb-Klipper_same70q20b* 2>/dev/null | head -n 1)

# Flash command template
FLASH_CMD="python3 ./scripts/flash_usb.py -t same70q20b -d"
FLASH_FILE=$sdir/duet_6hc_klipper.bin

echo
echo -e "${YELLOW}=== Duet 6HC Firmware Flash Helper by LulzBot ===${NC}"
echo
echo "This script does NOT compile new firmware."
echo "It flashes Klipper firmware provided by LulzBot."
echo

if [ ! -f "$FLASH_FILE" ]; then
    echo -e "❌ ${RED}Firmware file not found:${NC} $FLASH_FILE"
    exit 1
fi

echo "Flashing firmware from: "
echo $FLASH_FILE
echo

# --- CASE 1: Already running Klipper firmware ---
if [ -n "$KLIPPER_DEVICE" ] && [ -c "$KLIPPER_DEVICE" ]; then
    echo "✅ Klipper device detected at $KLIPPER_DEVICE"
    echo "Flashing firmware..."
    $FLASH_CMD "$KLIPPER_DEVICE" "$FLASH_FILE"
    if [ $? -eq 0 ]; then
        echo -e "✅ ${GREEN}Flash successful!${NC}"
    else
        echo -e "❌ ${RED}Flash failed.${NC}"
    fi
    exit 0
fi

# --- CASE 2: Already in erased mode ---
if [ -c "$DUET_ERASED" ]; then
    echo "✅ Duet board is already in ERASED mode ($DUET_ERASED)"
    echo "If there is an ERASE jumper installed on the board please remove it."
    echo "Then press Enter to continue flashing."
    read -r
    echo "Flashing firmware..."
    $FLASH_CMD "$DUET_ERASED" "$FLASH_FILE"
    if [ $? -eq 0 ]; then
        echo -e "✅ ${GREEN}Flash successful!${NC}"
    else
        echo -e "❌ ${RED}Flash failed.${NC}"
    fi
    exit 0
fi

# --- CASE 3: Board running factory Duet firmware ---
if [ -c "$DUET_NORMAL" ]; then
    echo "✅ Duet board detected with factory firmware at $DUET_NORMAL"
    echo
    echo "Please:"
    echo " 1) Install the ERASE jumper on the board."
    echo " 2) Press the RESET button on the board edge."
    echo
    echo "Waiting for the board to enter ERASED mode at ($DUET_ERASED)..."

    # Wait for old device to disappear
    while [ -c "$DUET_NORMAL" ]; do
        sleep 0.5
        printf "."
    done

    # Wait for erased device to appear
    while [ ! -c "$DUET_ERASED" ]; do
        sleep 0.5
        printf "."
    done

    printf "\n"
    echo "✅ Board now in ERASED mode."
    echo "Please remove the ERASE jumper, then press Enter to continue flashing."
    read -r
    echo
    echo "Flashing firmware..."
    $FLASH_CMD "$DUET_ERASED" "$FLASH_FILE"
    if [ $? -eq 0 ]; then
        echo -e "✅ ${GREEN}Flash successful!${NC}"
    else
        echo -e "❌ ${RED}Flash failed.${NC}"
    fi
    exit 0
fi

# --- CASE 4: No recognized device found ---
echo -e "❌ ${RED}No Duet 6HC device detected.${NC}"
echo "Please connect the board via USB and try again."
echo "If board is connected, try pressing the reset button"
echo "or try cycling power to the board."
echo
exit 1
