#!/bin/bash

REMOTE=berstearns-gdrive
SHARED=false
SCRIPT_FOLDERPATH="$(dirname "$(realpath "$0")")"

# Function to pull files from the remote
pull() {
    echo "Pulling files from $REMOTE to $SCRIPT_FOLDERPATH..."
    if [ "$SHARED" = true ]; then
        rclone copyto --progress --drive-shared-with-me "$REMOTE:/celso-bernardo/gapster" "$SCRIPT_FOLDERPATH"
    else
        rclone copyto --progress "$REMOTE:/celso-bernardo/gapster" "$SCRIPT_FOLDERPATH"
    fi
}

# Function to push files to the remote
push() {
    echo "Pushing files from $SCRIPT_FOLDERPATH to $REMOTE..."
    if [ "$SHARED" = true ]; then
        rclone copyto --progress --drive-shared-with-me --exclude "*.sh" "$SCRIPT_FOLDERPATH" "$REMOTE:/celso-bernardo/gapster"
    else
        rclone copyto --progress --exclude "*.sh" "$SCRIPT_FOLDERPATH" "$REMOTE:/celso-bernardo/gapster"
    fi

}

# Main function to handle script logic
main() {
    echo "The absolute path of this script is: $SCRIPT_FOLDERPATH"

    # Check for command-line arguments to determine whether to pull or push
    if [ "$1" = "pull" ]; then
        pull
    elif [ "$1" = "push" ]; then
        push
    else
        echo "Usage: $0 {pull|push}"
        exit 1
    fi
}

# Call the main function and pass all command-line arguments
main "$@"
