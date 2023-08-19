#!/bin/bash

cwd=$(pwd)

if [ -d ~/.config/kitty ]; then
        read -p "kitty config found, clone your current one as kitty.old? [y/n] " kittyChoice
        if [ ${kittyChoice,,} == "y" ]; then
                mv ~/.config/kitty ~/.config/kitty.old
                cp -r $cwd/.config/kitty ~/.config
        fi
else
	cp -r $cwd/.config/kitty ~/.config
fi
echo "kitty config copied!"
