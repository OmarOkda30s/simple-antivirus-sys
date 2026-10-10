#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <dir> <malicious_dir> <interval-secs>"
    exit 1
fi

DIR="$1"
MAL_DIR="$2"
INTERVAL="$3"
WHITELIST="whitelist.txt"

EXTENSIONS="\.exe$|\.bat$\vert{}\.vbs$|\.scr$\vert{}\.ps1$"
KEYWORDS="virus|trojan|malware|worm|ransomware"

scan_directory() {
    for file in "$DIR"/*; do
        # Skip if not a valid file or if it's a directory
        [ -e "$file" ] || continue
        [ -d "$file" ] && continue
        
        filename=$(basename "$file")
        
        # Bonus 2:
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
}

if [ ! -f "directory-info.last" ]; then
    scan_directory
    ls -l "$DIR" > directory-info.last
fi

while true; do
    sleep "$INTERVAL"
    ls -l "$DIR" > directory-info.new
    
    if ! cmp -s directory-info.last directory-info.new; then
        scan_directory
        cp directory-info.new directory-info.last
    fi
done