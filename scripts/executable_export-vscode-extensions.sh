#!/bin/bash

EXT_FILE=~/scripts/vscode-extensions.txt

# Delete file if it exists
[ -f "$EXT_FILE" ] && rm "$EXT_FILE"

# Save current extensions list
code --list-extensions > "$EXT_FILE"

