#!/bin/bash

dir=$1
malicious_dir=$2

whitelist_file="whitelist.txt"

while true; do
    files=("$malicious_dir"/*)

    if [ ! -e "${files[0]}" ]; then
        echo "No malicious files to review."
        break
    fi

    echo "Malicious files:"

    for i in "${!files[@]}"; do
        echo "$((i + 1))) $(basename "${files[$i]}")"
    done

    read -p "Select a file by number: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]; then
        echo "Invalid choice."
        continue
    fi

    file="${files[$((choice - 1))]}"
    filename=$(basename "$file")

    echo "1) Restore this file"
    echo "2) Permanently delete this file"
    echo "3) Leave this file as-is"
    read -p "Choose an option: " action

    case "$action" in
        1)
            mv "$file" "$dir/"
            if ! grep -qxF "$filename" "$whitelist_file" 2>/dev/null; then
              echo "$filename" >> "$whitelist_file"
            fi
            echo "Restored $filename to $dir."
            ;;
        2)
            rm "$file"
            echo "$filename permanently deleted."
            ;;
        3)
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
