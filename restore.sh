#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dir> <malicious_dir>"
    exit 1
fi

DIR="$1"
MAL_DIR="$2"
WHITELIST="whitelist.txt"

while true; do
    if [ -z "$(ls -A "$MAL_DIR" 2>/dev/null)" ]; then
        echo "No malicious files to review."
        exit 0
    fi
    
    echo -e "\nFiles in quarantine:"
    files=("$MAL_DIR"/*)
    for i in "${!files[@]}"; do
        echo "$((i+1)).$(basename "${files[$i]}")"
    done
    
    read -p "Pick a file by number (or 0 to exit): " choice
    
    if [ "$choice" -eq 0 ]; then
        exit 0
    fi
    
    if [ "$choice" -gt 0 ] && [ "$choice" -le "${#files[@]}" ]; then
        target_file="${files[$((choice-1))]}"
        target_name=$(basename "$target_file")
        
        echo -e "\nOptions for $target_name:"
        echo "1: Restore this file back into $DIR"
        echo "2: Permanently delete this file from $MAL_DIR"
        echo "3: Leave this file as-is and go back to the list"
        read -p "Select option (1-3): " opt
        
        case $opt in
            1)
                mv "$target_file" "$DIR/"
                # Bonus 2: Add to whitelist upon restore
                echo "$target_name" >> "$WHITELIST"
                echo "Restored $target_name to$DIR."
                ;;
            2)
                rm -f "$target_file"
                echo "$target_name permanently deleted."
                ;;
            3)
                continue
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
    else
        echo "Invalid selection. Please enter a valid number."
    fi
done