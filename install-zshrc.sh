#!/bin/bash

cwd=$(pwd)

if [ ! -f "/usr/bin/git" ] && [ ! -f "/bin/git" ]; then
	echo "Please install git before running"
	exit
fi
if [ -f "/usr/bin/zsh" ] || [ -f "/bin/zsh" ]; then
	# Installs oh-my-zsh
	printf '\e[38;5;195;1;2moh-my-zsh is about to install. It will put you in a zsh terminal when it finishes.\e[38;5;51m Please type “exit” when oh-my-zsh is finished to return back to this script.\e[0m\n' 
	sleep 5
	echo "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "Please install zsh before running"
	exit
fi
echo "Copy .zshrc into home"
echo ""
echo "Please choose your operating system"
echo "-----------------------------------"
echo "1.) Arch based (includes Manjaro, Endeavor, SteamOS, etc.)"
echo "2.) Debian based (includes Ubuntu, Pop!_OS, Linux Mint, anything Ubuntu based, etc.)"
echo "3.) Redhat based (includes Fedora, CentOS, etc.)"
echo "4.) macOS (Should work with almost any version (OS X included). Tested with macOS 13)"
echo "5.) Unsure/Other (will install .zshrc.arch, but not install pfetch or fortune-mod)"
echo "0.) Exit install script"
echo ""
echo "If you choose 2-4, you will be prompted to install pfetch + fortune later."
echo "If you choose 5, you will have to modify the aliases manually in .zshrc to have it match with your system"
echo ""
read -p "Operating System Choice [0-5]: " osChoice
case $osChoice in
	"0")
		echo "Exiting..."
		exit
		;;
	"1")
		echo "Arch chosen"
		zshrcType="arch"
		;;
	"2")
		echo "Debian chosen"
		zshrcType="debian"
		;;
	"3")
		echo "Redhat chosen"
		zshrcType="redhat"
		;;
	"4")
		echo "macOS chosen"
		zshrcType="macos"
		;;
	"5")
		echo "Manual install method chosen"
		zshrcType="arch"
		;;
	*)
		echo "Invalid choice. Exiting..."
		exit
esac
if [ -f ~/.zshrc ]; then
	echo "This will overwrite your current .zshrc, how do you want to handle this?"
	echo "-----------------------------------------------------------------------"
	echo "1. Overwrite .zshrc"
	echo "2. mv old .zshrc to .zshrc.old"
	echo "0. Exit this script"
	read -p "Choice [0-2]: " writeChoice
	case $writeChoice in
		"0")
			echo "Exiting..."
			exit
			;;
		"1")
			echo "Copying .zshrc directly into ~"
			cp ./.zshrc.$zshrcType ~/.zshrc
			;;
		"2")
			echo "Renaming old .zshrc"
			mv ~/.zshrc ~/.zshrc.old
			echo "Copying .zshrc"
			cp ./.zshrc.$zshrcType ~/.zshrc
			;;
		*)
			echo "No valid choice supplied, exiting"
			exit
	esac
else
	cp ./.zshrc ~
fi
cd /tmp
echo "Installing plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "installation complete"
if [ $osChoice = "5" ]; then
	echo "Manual install for pfetch/fortune-mod was chosen earlier."
	echo "Script complete!"
	exit
fi
echo ""
read -p "Install pfetch and fortune? [y/n]: " installChoice
if [ "${installChoice,,}" != "y" ]; then
	echo "Skipping install..."
	echo "Script complete!"
	exit
fi
echo "Installing pfetch and fortune..."
if [ -f "/usr/bin/pfetch" ] || [ -f "/usr/bin/fortune" ]; then
	read -p "pfetch and/or fortune is installed. Continue with install script? [y/n]: " installChoice2
	if [ ${installChoice2,,} != "y" ]; then
		echo "Skipping install..."
		echo "Script complete!"
		exit
	fi
fi
case $osChoice in
	"1")
		echo "Arch install method chosen"
		if [ ! -f /usr/bin/yay ]; then
			read -p "yay not installed: install yay? [y/n] " installYay
		
			if [ ${installYay,,} == "y" ]; then
				base_devel_check=$(pacman -Qs base-devel)
				if [[ ! "$base_devel_check" == *"base-devel"* ]]; then
					echo "base-devel package not installed. Installing..."
					sudo pacman -S base-devel
				fi
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
		read -p "Add --needed tag? [y/n] " neededTag
		if [ ${neededTag,,} == "y" ]; then
			yay -S pfetch fortune-mod --needed
		else
			yay -S pfetch fortune-mod
		fi
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
		if [ ! -f "/opt/homebrew/bin/brew" ]; then
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
	"5")
		echo "Manual install for pfetch/fortune-mod was chosen earlier."
		;;
esac
echo "Script complete!"
