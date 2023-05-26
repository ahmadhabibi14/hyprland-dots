#!/bin/bash

# Define the source and destination paths
source_path="$HOME/.config"
destination_path="$HOME/Dev/githubRepos/hyprland-dots/.config"

# Remove existing directories from the destination path
rm -rf "$destination_path"

# Copy specified folders from the source to destination
folders=(
	"hypr"
	"waybar"
	"dunst"
)  # Add the names of the folders you want to copy
for folder in "${folders[@]}"; do
  cp -r "$source_path/$folder" "$destination_path"
done

echo "Folders copied successfully!"
