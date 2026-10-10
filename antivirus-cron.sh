#!/bin/bash

# Note: Update these paths to absolute paths depending on your cron environment
DIR="/tmp/monitored_dir"
MAL_DIR="/tmp/quarantined_dir"
WHITELIST="/tmp/whitelist.txt"

# Ensure directories exist for the cron job
mkdir -p "$DIR" "$MAL_DIR"
touch "$WHITELIST"

EXTENSIONS="\.exe$|\.bat$\vert{}\.vbs$|\.scr$\vert{}\.ps1$"
KEYWORDS="virus|trojan|malware|worm|ransomware"

for file in "$DIR"/*; do
    [ -e "$file" ] || continue
    [ -d "$file" ] && continue
    
    filename=$(basename "$file")
    
    if grep -Fxq "$filename" "$WHITELIST" 2>/dev/null; then
        continue
    fi
    
    is_malicious=0
    
    if echo "$filename" \vert{} grep -Eqi "$EXTENSIONS"; then
        is_malicious=1
    fi
    
    if [ $is_malicious -eq 0 ] && grep -Eqi "$KEYWORDS" "$file" 2>/dev/null; then
        is_malicious=1
    fi
    
    if [ $is_malicious -eq 1 ]; then
        echo "$filename is malicious and it is DELETED"
        cp "$file" "$MAL_DIR/"
        rm -f "$file"
    fi
done