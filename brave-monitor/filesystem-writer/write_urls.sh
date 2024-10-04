#!/bin/bash

LOG_FILE="~/brave_tab_urls.txt"

# Reading the input from the extension (JSON input)
while read line; do
    echo "$line" | jq -r '.urls[]' >> "$LOG_FILE"
done

