#!/bin/bash

read -p "Please enter the directory: " dir

# Check if the entered directory exists
if [[ ! -d $dir ]]; then
    echo "The directory $dir does not exist. Exiting."
    exit 1
fi

read -p "You have chosen the directory $dir. Are you sure you want to proceed? [y/n]: " answer

# Convert to lowercase to accept 'Y' or 'y' as confirmation
answer=${answer,,}

if [[ $answer == 'y' ]]; then
    find "$dir" -type f -name "*.mkv" -print0 | while IFS= read -r -d '' file; do
        # Get all track IDs for video, audio, and subtitles
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
