#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# dependencies
sudo pacman -Sy --needed --noconfirm \
	curl \
	emacs \
	git \
	wget \
	ripgrep \
	zsh

# nerd fonts
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts "$HOME"/nerdfonts
git -C "$HOME"/nerdfonts sparse-checkout add patched-fonts/Hack
"$HOME"/nerdfonts/install.sh Hack
rm -rf "$HOME"/nerdfonts

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

# emacs doom
if [ -d "$HOME"/.emacs.d ]; then
	echo "warning: doomemacs already exists -- updating"
	"$HOME"/.emacs.d/bin/doom upgrade -!
else
	git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME"/.emacs.d
	"$HOME"/.emacs.d/bin/doom install -!
fi

# dotfiles
ln -s -f "$SCRIPT_DIR"/.p10k.zsh -t "$HOME"
ln -s -f "$SCRIPT_DIR"/.zshrc -t "$HOME"
ln -s -f "$SCRIPT_DIR"/.alacritty.yml -t "$HOME"
ln -s -f "$SCRIPT_DIR"/aliases.zsh -t "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$HOME"/.doom.d ]; then
	rm -rf "$HOME"/.doom.d
fi
mkdir "$HOME"/.doom.d
ln -s -f "$SCRIPT_DIR"/.doom.d/*.el -t "$HOME"/.doom.d

echo "source $HOME/.zshrc to apply configuration"

