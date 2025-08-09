#!/bin/bash
while read line; do code --install-extension "$line"; done < vscode-extensions.txt
