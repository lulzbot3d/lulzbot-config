#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    echo "Please restart the printer for proper permissions to be set up."
    exit 1
fi

IFACE="eth0"
STATIC_IP="192.168.50.1/24"
DHCP_RANGE="192.168.50.10,192.168.50.100,12h"

DNSMASQ_CONF="/etc/dnsmasq.d/klipper-direct.conf"
STATE_FILE="/var/lib/eth_mode_state"

function check_for_existing_network() {
    echo "Checking for existing DHCP server on $IFACE..."

    if [ "$(cat /sys/class/net/$IFACE/carrier)" = "0" ]; then
        echo "No physical connection detected on $IFACE."
        return 1
    fi

    ip link set $IFACE up

    rm -f /tmp/dhcp_test.log
    timeout 5 dhclient -1 -v -sf /bin/true $IFACE &> /tmp/dhcp_test.log

    if grep -q "DHCPOFFER" /tmp/dhcp_test.log || grep -q "DHCPACK" /tmp/dhcp_test.log; then
        echo "DHCP server detected!"
        return 0
    else
        echo "No DHCP server detected."
        return 1
    fi
}

function take_control_of_interface() {
    echo "Taking control of $IFACE..."

    # Disable NetworkManager control
    if command -v nmcli >/dev/null 2>&1; then
        nmcli dev set $IFACE managed no
    fi
}

function normal_mode() {
    echo "Switching to NORMAL (DHCP client) mode..."

    systemctl stop dnsmasq
    rm -f $DNSMASQ_CONF
    ip addr flush dev $IFACE

    # Give control back to NetworkManager
    if command -v nmcli >/dev/null 2>&1; then
        nmcli dev set $IFACE managed yes

        echo "Looking for existing NetworkManager connection for $IFACE..."

        CONN=$(nmcli -t -f NAME,DEVICE connection show | grep "$IFACE$" | cut -d: -f1 | head -n1)

        # If nothing directly bound, try any ethernet connection
        if [ -z "$CONN" ]; then
            CONN=$(nmcli -t -f NAME,TYPE connection show | grep "ethernet$" | cut -d: -f1 | head -n1)
        fi

        if [ -n "$CONN" ]; then
            echo "Using existing connection: $CONN"
            nmcli connection up "$CONN" 2>/dev/null || true
        else
            echo "No existing connection found, creating one"
            nmcli connection add type ethernet ifname $IFACE con-name "eth0-auto"
            nmcli connection up "eth0-auto" 2>/dev/null || true
        fi
    fi

    echo "normal" > $STATE_FILE
    echo "Now using DHCP from external network."
}

function direct_mode() {
    echo "Switching to DIRECT CONNECT (DHCP server) mode..."

    if check_for_existing_network; then
        echo "Refusing to start DHCP server on active network."
        echo "Direct Ethernet mode NOT enabled."
        echo "Direct mode is intended for use when directly"
        echo "connecting a computer to the printer without"
        echo "any other network present."
        exit 1
    fi

    take_control_of_interface

    systemctl stop dnsmasq

    ip addr flush dev $IFACE
    ip addr add $STATIC_IP dev $IFACE
    ip link set $IFACE up

    echo "Creating dnsmasq config..."

    cat <<EOF > $DNSMASQ_CONF
interface=$IFACE
bind-interfaces
dhcp-range=$DHCP_RANGE
EOF

    systemctl restart dnsmasq

    echo "DHCP server started."
    echo "Note: It may take a minute for the computer to recognize"
    echo "the new network and obtain an IP address."
    echo "If you have trouble connecting to the IP address below,"
    echo "try reloading the page in the browser or try"
    echo "reconnecting the cable."
    IP_ONLY="${STATIC_IP%%/*}"
    echo "Printer IP: $IP_ONLY"
    echo "direct" > $STATE_FILE
}

function apply_saved_mode() {
    if [ -f "$STATE_FILE" ]; then
        MODE=$(cat $STATE_FILE)
        echo "Applying saved mode: $MODE"

        if [ "$MODE" = "direct" ]; then
            direct_mode
        else
            normal_mode
        fi
    else
        echo "No saved mode, defaulting to normal"
        normal_mode
    fi
}

function setup_sudoers() {
# This may look like a chicken and egg problem. For this script to work properly, it needs to be able to run with sudo from the pi user without a password.
# This is a requirement because normally we want to use the script from a macro that runs a gcode shell extension command, and those commands run as the pi user,
# and the user can't interactively enter a password when running a shell command from a macro.
# This function checks if the script is already in sudoers, and if not, it adds an entry to allow it.
# It will be called from the lulzbot_startup script, which runs as root, so it has the permissions to modify the sudoers file if needed.
    if ! sudo -l -U pi | grep -q "eth_mode.sh"; then
        echo "Adding sudoers entry for eth_mode.sh..."
        echo "pi ALL=(ALL) NOPASSWD: /home/pi/lulzbot-config/lulzbot-scripts/eth_mode.sh" | tee /etc/sudoers.d/010_pi-eth_mode
        chmod 440 /etc/sudoers.d/010_pi-eth_mode
    else
        echo "Sudoers entry for eth_mode.sh already exists."
    fi
}

function show_mode() {
    if [ -f "$STATE_FILE" ]; then
        MODE=$(cat $STATE_FILE)
        echo "Current Ethernet Direct Connect mode: $MODE"
    else
        echo "No Ethernet Direct Connect mode set."
    fi
}


case "$1" in
    normal)
        normal_mode
        ;;
    direct)
        direct_mode
        ;;
    apply)
        apply_saved_mode
        ;;
    show)
        show_mode
        ;;
    setup_sudoers)
        setup_sudoers
        ;;
    *)
        echo "Usage: $0 {normal|direct|apply|show|setup_sudoers}"
        exit 1
        ;;
esac
