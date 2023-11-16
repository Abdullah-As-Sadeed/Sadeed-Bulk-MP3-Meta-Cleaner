#!/bin/bash

# By Abdullah As-Sadeed

# Function to check if a command-line tool is installed
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display colored messages
print_message() {
    message="$1"
    color="$2"
    echo -e "${color}${message}\033[0m"
}

# Function to display error messages in red color
print_error() {
    print_message "Error: $1" "\033[1;31m"
}

# Check if eyeD3 is installed
if ! command_exists "eyeD3"; then
    print_error "eyeD3 is not installed! Please install it and try again."
    exit 1
fi

# Check if the directory argument is provided
if [ -z "$1" ]; then
    print_message "Usage: $0 <directory>" "\033[1;33m"
    exit 1
fi

# Check if the directory exists
if [ ! -d "$1" ]; then
    print_error "Failed to find the specified directory!"
    exit 1
fi

# Check if the script has read and write permissions for the directory
if [ ! -r "$1" ] || [ ! -w "$1" ]; then
    print_error "I do not have read and write permissions for the specified directory!"
    exit 1
fi

# Function to remove metadata from mp3 files
remove_metadata() {
    file="$1"
    echo "Removing metadata from: $file"
    eyeD3 --remove-all "$file"
}

processed_files=0

# Use process substitution to read from find command
while IFS= read -r file; do
    # Check if the script has read and write permissions for the file
    if [ ! -r "$file" ] || [ ! -w "$file" ]; then
        print_error "The script does not have read and write permissions for the file: $file"
        exit 1
    fi

    remove_metadata "$file"
    ((processed_files++))
done < <(find "$1" -type f -iname "*.mp3")

echo "The operation has been completed."
echo "Total processed files: $processed_files"
