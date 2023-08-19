#!/bin/bash

if [ ! -f "/usr/bin/git" ]; then
	echo "Please install git before running"
	exit
fi
if [ -f "/usr/bin/zsh" ]; then
	# Installs oh-my-zsh
	echo "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "Please install zsh before running"
	exit
fi
echo "copying .zshrc to home"
cp ./.zshrc ~
cd /tmp
echo "installing plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "installation complete"
echo "Install pfetch and fortune"
echo ""
if [ -f "/usr/bin/pfetch" ] || [ -f "/usr/bin/fortune" ]; then
	read -p "pfetch and/or fortune is installed. Continue with install script? [y/n]: " installChoice
	if [ ${installChoice,,} != "y" ]; then
		echo "Skipping install..."
		echo "Script complete!"
		exit
	fi
fi
echo ""
echo "What operating system are you on?"
echo "---------------------------------"
echo "1. Arch based"
echo "2. Debian based"
echo "3. Redhad based"
echo "4. macOS"
echo "0. Exit out of this menu/install manually"
read -p "Choice: " installMethod
case $installMethod in
	"0")
		echo "Exiting"
		exit
		;;
	"1")
		echo "Arch install method chosen"
		if [ ! -f /usr/bin/yay ]; then
			read -p "yay not installed: install yay? [y/n] " installYay
		
			if [ ${installYay,,} == "y" ]; then
				cd /tmp
				if [ -d ./yay ]; then
					rm -rf yay
				fi
				git clone https://aur.archlinux.org/yay.git
				cd yay
				makepkg -si
			else
				echo "Cannot install due to yay being absent. Exiting...."
				exit
			fi
		fi
		yay -S pfetch fortune-mod
		;;
	"2")
		echo "Debian install method chosen"
		cd /tmp
		if [ -d ./pfetch ]; then
			rm -rf pfetch
		fi
		git clone https://github.com/dylanaraps/pfetch.git
		sudo install pfetch/pfetch /usr/local/bin
		sudo apt install fortune-mod
		;;
	"3")
		echo "Redhat install method chosen"
		cd /tmp
		if [ -d ./pfetch ]; then
                        rm -rf pfetch
                fi
                git clone https://github.com/dylanaraps/pfetch.git
                sudo install pfetch/pfetch /usr/local/bin
		sudo dnf install fortune-mod
		;;
	"4")
		echo "macOS install method chosen"
		if [ ! -f "/usr/local/bin/brew" ]; then
			read -p "brew not installed: install brew? [y/n] " installBrew
			if [ ${installBrew,,} == "y" ]; then
        			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			else
                        	echo "Cannot install due to brew being absent. Exiting...."    
                	exit    
			fi
		fi
		brew install pfetch fortune
		;;
esac
echo "Script complete!"