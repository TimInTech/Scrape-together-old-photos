

# 📸 **Scrape-together-old-photos - Digital Time Capsule**

## **🕰️ Welcome to the Time Capsule Community!**

We are on a mission to **rediscover and preserve old memories** by searching forgotten **hard drives, USB devices, and folders** for lost photos.

This repository provides a **Bash script** that automatically scans your **external storage devices**, extracts images, and organizes them **by year and month** based on metadata.

---

## **🛠️ Features**
✅ **Scans external drives & USB devices** for old photos
✅ **Detects images** (`.jpg`, `.png`, `.gif`, `.tiff`, `.bmp`)
✅ **Sorts images by year & month** based on file metadata
✅ **Creates a log file** for tracking scanned files

---

# 🚀 **Script: `scrape_photos.sh`**

### **📂 How It Works:**
- The script **searches all mounted drives** for image files.
- It **copies** them into a **central backup folder** sorted by **year and month**.
- A **log file** keeps track of all extracted images.

---

### **📜 Bash Script (`scrape_photos.sh`)**

Save the following script as `scrape_photos.sh`, **make it executable**, and run it.

```bash
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
```

---

## **📖 Installation & Usage**

### 🔹 **1. Download the Script**
```bash
git clone https://github.com/TimInTech/Scrape-together-old-photos.git
cd Scrape-together-old-photos
chmod +x scrape_photos.sh
```

### 🔹 **2. Run the Script**
```bash
./scrape_photos.sh
```

### 🔹 **3. View the Results**
- 📂 Images are stored in: `~/Recovered/Year/Month/`
- 📄 Log file: `scrape_log.txt`

---

## 🔧 **Additional Commands**

### 📌 **View Logs**
Check the scan log to see which files were processed:
```bash
cat ~/Recovered/scrape_log.txt
```

### 📌 **Delete Duplicate Files**
If you want to remove duplicate images, use `fdupes`:
```bash
sudo apt install fdupes
fdupes -rd ~/Recovered
```

### 📌 **Manually List External Drives**
```bash
lsblk | grep -i usb
```

### 📌 **Delete the Backup Folder (If Needed)**
```bash
rm -rf ~/Recovered
```

---

## **🤝 Contribute**
🔹 Found an issue? **Report it!**
🔹 Want to improve the script? **Submit a Pull Request!**

