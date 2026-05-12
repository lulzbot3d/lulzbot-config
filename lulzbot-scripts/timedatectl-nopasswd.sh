#!/bin/bash

# Allow user "pi" to run timedatectl without a password

SUDOERS_FILE="/etc/sudoers.d/010-pi-timedatectl-nopasswd"
SUDOERS_LINE='pi ALL=(ALL) NOPASSWD: /usr/bin/timedatectl'

# Ensure script is running as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Timedatectl sudoers script must be run as root."
    exit 1
fi

# Check if correct entry already exists
if [[ -f "$SUDOERS_FILE" ]] && grep -Fxq "$SUDOERS_LINE" "$SUDOERS_FILE"; then
    echo "Timedatectl sudoers entry already exists."
    exit 0
fi

# Write sudoers file
echo "$SUDOERS_LINE" > "$SUDOERS_FILE"

# Correct permissions required by sudo
chmod 440 "$SUDOERS_FILE"

# Validate sudoers syntax
if visudo -cf "$SUDOERS_FILE" > /dev/null; then
    echo "Timedatectl sudoers entry installed successfully."
else
    echo "ERROR: Timedatectl sudoers validation failed!"
    rm -f "$SUDOERS_FILE"
    exit 1
fi
