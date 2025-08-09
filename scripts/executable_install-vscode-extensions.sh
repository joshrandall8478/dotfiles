#!/bin/bash
while read line; do code --install-extension "$line"; done < ~/scripts/vscode-extensions.txt
