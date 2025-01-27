#!/usr/bin/env bash

# -----------------------------------------------------
# Get the directory of this script
# -----------------------------------------------------
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# -----------------------------------------------------
# 1) Copy the hidden .res folder if it exists
# -----------------------------------------------------
if [ -d "$SCRIPT_DIR/.res" ]; then
    echo "Copying hidden '.res' folder -> /mnt/SDCARD/"
    cp -rv "$SCRIPT_DIR/.res" /mnt/SDCARD/
fi

# -----------------------------------------------------
# 2) Loop over all *non-hidden* items in $SCRIPT_DIR
# -----------------------------------------------------
for item in "$SCRIPT_DIR"/*; do
    
    # If it's a directory and not '.' or '..' or '.res'
    if [ -d "$item" ] \
       && [ "$(basename "$item")" != "." ] \
       && [ "$(basename "$item")" != ".." ] \
       && [ "$(basename "$item")" != ".res" ]; then

        echo "Copying directory: $item -> /mnt/SDCARD/"
        cp -rv "$item" /mnt/SDCARD/
    fi
done

# -----------------------------------------------------
# 3) If /mnt/SDCARD/Roms exists, rename PNG files
# -----------------------------------------------------
if [ -d "/mnt/SDCARD/Roms" ]; then
    # Loop over subdirectories in /mnt/SDCARD/Roms
    for romdir in /mnt/SDCARD/Roms/*/; do

        # Double-check it's really a directory
        [ -d "$romdir" ] || continue

        dirname="$(basename "$romdir")"
        # Extract the first parentheses group from the directory name
        system_code="$(echo "$dirname" | grep -o '([^)]*)')"

        if [ -n "$system_code" ]; then
            src_png="/mnt/SDCARD/Roms/.res/$system_code.png"
            dst_png="/mnt/SDCARD/Roms/.res/$dirname.png"
            if [ -f "$src_png" ]; then
                echo "Renaming $src_png -> $dst_png"
                mv "$src_png" "$dst_png"
            fi
        fi
    done
fi