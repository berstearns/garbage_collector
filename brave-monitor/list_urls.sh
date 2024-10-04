#!/bin/bash

# Set the debugging URL (this is where Brave exposes its debugging interface)
DEBUG_URL="http://localhost:9222/json"

# Fetch the JSON response from the Brave debugging interface
response=$(curl -s $DEBUG_URL)

# Check if response is empty or contains an error
if [[ -z "$response" ]]; then
    echo "Error: Unable to connect to Brave. Make sure Brave is running with --remote-debugging-port=9222."
    exit 1
fi

# Use jq to parse the JSON and extract the URLs of open tabs
echo "Open Tabs in Brave:"
echo "$response" | jq -r '.[] | select(.type=="page") | .url'

