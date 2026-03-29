#!/bin/bash
# prepare_images.sh - Map date-based scan names to sequential boulay_NNN names
#
# This script:
# 1. Maps scan images from date-based names (e.g., 1914_11_04(a).jpg) to sequential names
# 2. Copies/links them to the boulay-site directory with names like boulay_001_recto.jpg

SCAN_DIR="/sessions/bold-focused-darwin/mnt/Scan Cartes  Boulay/Scan des cartes"
OUTPUT_DIR="/sessions/bold-focused-darwin/boulay-site"

# Verify directories exist
if [ ! -d "$SCAN_DIR" ]; then
    echo "Error: Scan directory not found: $SCAN_DIR"
    exit 1
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

echo "Starting image mapping and copying..."
echo "Source directory: $SCAN_DIR"
echo "Output directory: $OUTPUT_DIR"

# Create a Python mapping script
python3 << 'PYTHON_EOF'
import json
import os
import shutil
from pathlib import Path

# Load the JSON to get the correct card order
with open('/sessions/bold-focused-darwin/cartes_boulay.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

cartes_dict = data.get('cartes', {})

# Sort cards by numero
cartes_list = []
for key, card in cartes_dict.items():
    cartes_list.append(card)
cartes_list.sort(key=lambda x: int(x.get('numero', 0)))

# Build mapping from card numbers to image sources
scan_dir = "/sessions/bold-focused-darwin/mnt/Scan Cartes  Boulay/Scan des cartes"
output_dir = "/sessions/bold-focused-darwin/boulay-site"

# Get actual image files in scan directory
img_files = {}
for f in os.listdir(scan_dir):
    if f.lower().endswith('.jpg'):
        # Extract date and side from filename
        # Filename pattern: YYYY_MM_DD(a).jpg or YYYY_MM_DD (a).jpg
        # (a) = recto, (b) = verso
        img_files[f] = os.path.join(scan_dir, f)

print(f"Found {len(img_files)} image files in scan directory")

# Process each card and copy/link images
copied = 0
missing = 0
mapping = []

for card in cartes_list:
    n = card.get('numero', 0)
    images = card.get('images', {})
    recto_src = images.get('recto')
    verso_src = images.get('verso')

    # Pad number
    padded_n = str(n).zfill(3)

    # Process recto (image side)
    if recto_src:
        src_path = os.path.join(scan_dir, recto_src)
        if os.path.exists(src_path):
            dst_name = f"boulay_{padded_n}_recto.jpg"
            dst_path = os.path.join(output_dir, dst_name)
            try:
                shutil.copy2(src_path, dst_path)
                copied += 1
                mapping.append(f"Card {n}: copied {recto_src} -> {dst_name}")
            except Exception as e:
                print(f"Error copying recto for card {n}: {e}")
                missing += 1
        else:
            missing += 1
            mapping.append(f"Card {n}: recto source not found: {recto_src}")

    # Process verso (message side)
    if verso_src:
        src_path = os.path.join(scan_dir, verso_src)
        if os.path.exists(src_path):
            dst_name = f"boulay_{padded_n}_verso.jpg"
            dst_path = os.path.join(output_dir, dst_name)
            try:
                shutil.copy2(src_path, dst_path)
                copied += 1
                mapping.append(f"Card {n}: copied {verso_src} -> {dst_name}")
            except Exception as e:
                print(f"Error copying verso for card {n}: {e}")
                missing += 1
        else:
            missing += 1
            mapping.append(f"Card {n}: verso source not found: {verso_src}")

print(f"\nSummary:")
print(f"  Copied: {copied} images")
print(f"  Missing: {missing} sources")
print(f"  Total cards: {len(cartes_list)}")

# Save mapping log
with open(os.path.join(output_dir, 'image_mapping.log'), 'w', encoding='utf-8') as f:
    f.write('\n'.join(mapping))

print(f"\nMapping log saved to {os.path.join(output_dir, 'image_mapping.log')}")

PYTHON_EOF

echo "Image preparation complete!"
