#!/bin/bash

FILE="/etc/apt/sources.list"
BACKPORTS="bullseye-backports"

# Only modify if an uncommented backports entry exists
if grep -q "^[^#].*$BACKPORTS" "$FILE"; then
    cp "$FILE" "$FILE.bak"
    sed -i "/^[^#].*$BACKPORTS/ s|^|# |" "$FILE"
fi
