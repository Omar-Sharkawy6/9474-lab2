#!/bin/bash

dir=$1
malicious_dir=$2

flagged_extensions=(".exe" ".bat" ".vbs" ".scr" ".ps1")
flagged_keywords=("virus" "trojan" "malware" "worm" "ransomware")

sleep 23

scan_directory() {
    for file in "$dir"/*; do
        [ -f "$file" ] || continue

        malicious=false

        for ext in "${flagged_extensions[@]}"; do
            if [[ "$file" == *"$ext" ]]; then
                malicious=true
                break
            fi
        done

        if [ "$malicious" = false ]; then
            for keyword in "${flagged_keywords[@]}"; do
                if grep -qi "$keyword" "$file"; then
                    malicious=true
                    break
                fi
            done
        fi

        if [ "$malicious" = true ]; then
            filename=$(basename "$file")
            echo "$filename is malicious and it is DELETED"
            cp "$file" "$malicious_dir/"
            rm "$file"
        fi
    done
}

mkdir -p "$malicious_dir"

if [ ! -f cron-directory-info.last ]; then
    scan_directory
    ls -l "$dir" > cron-directory-info.last
else
    ls -l "$dir" > cron-directory-info.new

    if ! cmp -s cron-directory-info.last cron-directory-info.new; then
        scan_directory
        cp cron-directory-info.new cron-directory-info.last
    fi
fi
