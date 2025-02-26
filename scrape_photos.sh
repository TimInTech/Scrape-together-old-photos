#!/bin/bash

# Scrape-together-old-photos - Find and recover old photos from external storage
# Author: TimInTech | Version: 1.0
# Description: This script scans connected hard drives & USB devices for old photos and copies them to a central "Recovered" folder.

### 🔍 STEP 1: Define Directories ###
BACKUP_DIR="$HOME/Recovered"
LOG_FILE="$BACKUP_DIR/scrape_log.txt"

# Create backup folder if it doesn't exist
mkdir -p "$BACKUP_DIR"

### 📂 STEP 2: Find All External Drives ###
echo "[INFO] Searching for connected hard drives & USB devices..." | tee -a "$LOG_FILE"
MOUNT_POINTS=$(lsblk -o MOUNTPOINT,TYPE | grep part | awk '{print $1}')

if [ -z "$MOUNT_POINTS" ]; then
    echo "[WARNING] No external drives found!" | tee -a "$LOG_FILE"
    exit 1
fi

### 🖼️ STEP 3: Search for Photos & Copy Them ###
echo "[INFO] Scanning the following drives: $MOUNT_POINTS" | tee -a "$LOG_FILE"

for DRIVE in $MOUNT_POINTS; do
    echo "[INFO] Scanning $DRIVE for image files..." | tee -a "$LOG_FILE"

    find "$DRIVE" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.tiff" -o -iname "*.bmp" \) | while read -r FILE; do
        # Extract metadata (year and month)
        YEAR=$(stat -c %y "$FILE" | cut -d'-' -f1)
        MONTH=$(stat -c %y "$FILE" | cut -d'-' -f2)

        # Create target folder
        TARGET_DIR="$BACKUP_DIR/$YEAR/$MONTH"
        mkdir -p "$TARGET_DIR"

        # Copy file
        cp -n "$FILE" "$TARGET_DIR"
        echo "[OK] Saved: $FILE → $TARGET_DIR" | tee -a "$LOG_FILE"
    done
done

echo "[DONE] All images have been saved to: $BACKUP_DIR" | tee -a "$LOG_FILE"
