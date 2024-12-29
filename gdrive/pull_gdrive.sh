#!/bin/bash 

REMOTE=berstearns-gdrive
SCRIPT_FOLDERPATH="$(dirname $(realpath "$0"))"
echo "The absolute path of this script is: $SCRIPT_PATH"
rclone copyto --progress --drive-shared-with-me $REMOTE:/celso-bernardo/gapster $SCRIPT_FOLDERPATH/
