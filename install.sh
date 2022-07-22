#!/bin/sh

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

sudo pacman -Sy --needed --noconfirm \
	curl \
	emacs \
	git \
	wget \
	zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp -f $SCRIPT_DIR/.p10k.zsh $HOME
cp -f $SCRIPT_DIR/.zshrc $HOME
cp -f $SCRIPT_DIR/.alacritty.yml $HOME
cp -f $SCRIPT_DIR/aliases.zsh $HOME/.oh-my-zsh/custom/
cp -f -R $SCRIPT_DIR/.doom.d $HOME

source $HOME/.zshrc

