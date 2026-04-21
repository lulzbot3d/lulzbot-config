#!/bin/bash

IFACE="eth0"
STATIC_IP="192.168.50.1/24"
DHCP_RANGE="192.168.50.10,192.168.50.100,12h"

DNSMASQ_CONF="/etc/dnsmasq.d/klipper-direct.conf"

function check_for_existing_network() {
    echo "Checking for active network..."

    if ip route | grep -q "default.*$IFACE"; then
        echo "Active network detected (default route present)."
        return 0
    else
        echo "No active network detected."
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

    # Give control back to NetworkManager
    if command -v nmcli >/dev/null 2>&1; then
        nmcli dev set $IFACE managed yes
        nmcli dev disconnect $IFACE 2>/dev/null
        nmcli dev connect $IFACE
    fi

    echo "Now using DHCP from external network."
}

function direct_mode() {
    echo "Switching to DIRECT CONNECT (DHCP server) mode..."

    if check_for_existing_network; then
        echo "Refusing to start DHCP server on active network."
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
    echo "Printer IP: 192.168.50.1"
}

case "$1" in
    normal)
        normal_mode
        ;;
    direct)
        direct_mode
        ;;
    *)
        echo "Usage: $0 {normal|direct}"
        exit 1
        ;;
esac
