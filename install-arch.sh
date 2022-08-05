#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# dependencies
sudo pacman -Sy --needed --noconfirm \
	curl \
	jq \
	fontconfig \
	neofetch \
	zsh

# nerd fonts
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts "$HOME"/nerdfonts
git -C "$HOME"/nerdfonts sparse-checkout add patched-fonts/Hack
"$HOME"/nerdfonts/install.sh Hack
rm -rf "$HOME"/nerdfonts

# asdf
if [ -d "$HOME"/.asdf ]; then
	echo "warning: asdf-vm already exists -- updating"
	"$HOME"/.asdf/bin/asdf update
else
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf
fi

# omz
if [ -d "$ZSH" ]; then
	echo "warning: oh-my-zsh already exists -- updating"
	"$ZSH"/tools/upgrade.sh
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# powerlevel10k
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
	echo "warning: powerlevel10k already exists -- updating"
	git -C "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k pull
else
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
fi

# base16-shell
if [ -d "$HOME"/.config/base16-shell ]; then
	echo "warning: base16-shell already exists -- updating"
	git -C "$HOME"/.config/base16-shell pull
else
	git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

# dotfiles
ln -s -f "$SCRIPT_DIR"/.alacritty.yml -t "$HOME"
ln -s -f "$SCRIPT_DIR"/.p10k.zsh -t "$HOME"
ln -s -f "$SCRIPT_DIR"/neofetch.conf -t "$HOME/.config/neofetch"
ln -s -f "$SCRIPT_DIR"/.zprofile -t "$HOME"
ln -s -f "$SCRIPT_DIR"/.zshrc -t "$HOME"
ln -s -f "$SCRIPT_DIR"/aliases.zsh -t "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$HOME"/.scripts ]; then
	rm -rf "$HOME"/.scripts
fi
ln -s -f "$SCRIPT_DIR"/.scripts "$HOME"/.scripts

mv "$HOME"/.config/neofetch/neofetch.conf "$HOME"/.config/neofetch/config.conf

echo "source $HOME/.zshrc to apply configuration"

