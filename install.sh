#!/bin/sh

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

sudo pacman -Sy --needed --noconfirm \
	curl \
	emacs \
	git \
	wget \
	zsh

cp -f $SCRIPT_DIR/alacritty.yml $HOME
cp -f $SCRIPT_DIR/aliases.sh $HOME/.oh-my-zsh/custom/
cp -f -R $SCRIPT_DIR/.doom.d $HOME
cp -f $SCRIPT_DIR/.zshrc .

source $HOME/.zshrc

