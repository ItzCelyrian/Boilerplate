#!/bin/bash

# Use fzf to select a directory with sorting
dir=$(find /mnt/sda1 -type d -print | sort | fzf --prompt="Select a directory: ")

# Check if the user made a selection
if [ -z "$dir" ]; then
    echo "No directory selected. Exiting."
    exit 1
fi

echo "You have chosen the directory $dir. Are you sure you want to proceed? [y/n]: "
read -r answer

# Convert to lowercase to accept 'Y' or 'y' as confirmation
answer=${answer,,}

if [[ $answer == 'y' ]]; then
    # Find all .mkv files and process them
    find "$dir" -type f -name "*.mkv" -print0 | while IFS= read -r -d '' file; do
        # Get all track IDs for video, audio, and subtitles using mkvmerge
        track_ids=$(mkvmerge -J "$file" | jq '.tracks[] | select(.type == "video" or .type == "audio" or .type == "subtitles") | .id + 1')

        # Loop through each track ID and remove its name
        for id in $track_ids; do
            mkvpropedit "$file" --edit track:@$id --set name=""
        done
    done
else
    echo "Operation cancelled. Exiting."
    exit 1
fi
