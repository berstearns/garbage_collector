#!/bin/bash
set -e

function reinstall_package() {
    pip uninstall -y knowledge-engineering || { echo "Uninstall failed"; exit 1; }
    pip install ../../ || { echo "Install failed"; exit 1; }
    echo "Reinstallation complete."
}

function question_generation(){
    $VENV_BIN_FOLDERPATH QG.py
}

function display_usage() {
    echo "Usage: $0 {r:reinstall,qg:Question Generation}"
    exit 1
}

VENV_BIN_FOLDERPATH=./venv/bin/python3
case "$1" in
    r) # reinstall
	reinstall_package
        ;;
    qg)# question generation
	question_generation
	;;
    *)
	display_usage
        ;;
esac
