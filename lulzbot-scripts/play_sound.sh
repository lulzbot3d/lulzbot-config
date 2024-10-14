#!/bin/bash

# Function to validate that the filename is just a filename.
validate_filename() {
    local filename="$1"

    # Check if the filename contains a path separator
    if [[ "$filename" == */* ]]; then
        echo "Invalid input: Filename should not contain any path."
        return 1
    fi

    # Check for special characters (disallow most shell metacharacters)
    if [[ "$filename" =~ [^a-zA-Z0-9._-] ]]; then
        echo "Invalid input: Filename contains invalid characters."
        return 1
    fi

    # Optionally, check if the file exists in the current directory
    if [[ ! -e "$filename" ]]; then
        echo "File does not exist in the lulzbot-sounds directory."
        return 1
    fi

    return 0
}

volume=80%
# Check if volume parameter is an integer between 0 and 80
# if so, set volume to that value.
# (Don't allow over 80% volume, HDMI5/Manta has issues with that.)
if [[ "$2" =~ ^[0-9]+$ ]]; then
    if (( $2 >= 0 && $2 <= 80 )); then
        volume=$2%
    fi
fi

# Example usage:
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <filename> <volume>"
    exit 1
fi

export AUDIODRIVER=alsa
cd /home/biqu/lulzbot-config/lulzbot-sounds/
filename="$1"

# Validate the filename and play the file if valid
if validate_filename "$filename"; then
    amixer set hdmi_volume $volume
    # So there's an issue where it doesn't play the first 0.5 to 1.0 seconds of a file
    # if the new file is in a different format than the last file played.  So to make 
    # sure everything plays in the same format, we will convert to the same format.
    sox $filename -r 44100 -b 16 -e signed-integer /tmp/output.wav
    # Call the play command with the -q flag to suppress output.  Play in background.
    echo "Playing file: $filename" &
    play -q /tmp/output.wav
else
    echo "Filename validation failed."
    exit 1
fi
