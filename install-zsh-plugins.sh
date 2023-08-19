#!/bin/bash

if [! -d "/usr/bin/git"]; then
	echo "Please install git before running"
	exit
fi
if [-d "/usr/bin/zsh"]; then
	# Installs oh-my-zsh
	echo "Installing oh-my-zsh"
	exec sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "Please install zsh before running"
	exit
fi
exec cp ./.zshrc ~
cd /tmp
exec git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
exec git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

