#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

for item in "$SCRIPT_DIR"/*; do
    if [ -d "$item" ] && [ "$(basename "$item")" != "." ]; then
        cp -rv "$item" /mnt/SDCARD/
        
        if [ -d "/mnt/SDCARD/Roms" ]; then
            for romdir in /mnt/SDCARD/Roms/*/; do
                if [ -d "$romdir" ]; then
                    dirname=$(basename "$romdir")
                    system_code=$(echo "$dirname" | grep -o '([^)]*)')
                    if [ ! -z "$system_code" ]; then
                        if [ -f "/mnt/SDCARD/Roms/.res/$system_code.png" ]; then
                            mv "/mnt/SDCARD/Roms/.res/$system_code.png" "/mnt/SDCARD/Roms/.res/$dirname.png"
                        fi
                    fi
                fi
            done
        fi
    fi
done