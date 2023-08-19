#!/bin/bash

cwd=$(pwd)

if [ -d ~/.config/kitty ]; then
	echo "already existing kitty config found"
	echo "-----------------------------------"
	echo "1. Overwrite kitty config"
        echo "2. mv old kitty config to .kitty.old"
        echo "0. Exit this script"
        read -p "Choice: " writeChoice
        case $writeChoice in
                "0")
                        echo "Exiting..."
                        exit
                        ;;
                "1")
                        echo "Overwriting kitty config"
                        cp -r $cwd/.config/kitty ~/.config
                        ;;
                "2")
                        echo "Renaming old kitty config"
                        mv ~/.config/kitty ~/.config/.kitty.old
			echo "Copying kitty config"
			cp -r $cwd/.config/kitty ~/.config
                        ;;
                *)
                        echo "No valid choice supplied, exiting"
                        exit
        esac
else
	cp -r $cwd/.config/kitty ~/.config
fi
echo "kitty config copied!"
