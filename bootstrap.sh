#!/bin/sh


# original code :https://blog.appkr.dev/work-n-play/dotfiles/

if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew tap homebrew/bundle
brew bundle --file=$HOME/dotfiles/Brewfile
brew cleanup
brew cask cleanup

[ ! -f $HOME/.gitconfig ] && ln -nfs $HOME/dotfiles/.gitconfig $HOME/.gitconfig
[ ! -f $HOME/.gitconfig-work ] && ln -nfs $HOME/dotfiles/.gitconfig $HOME/.gitconfig-work
[ ! -f $HOME/.gitconfig-private ] && ln -nfs $HOME/dotfiles/.gitconfig $HOME/.gitconfig-private
[ ! -f $HOME/.gitignore_global ] && ln -nfs $HOME/dotfiles/.gitignore_global $HOME/.gitignore_global

# install space vim
curl -sLf https://spacevim.org/install.sh | bash

chsh -s $(which zsh)
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
[ ! -f $HOME/.zshrc ] && ln -nfs $HOME/dotfiles/.zshrc $HOME/.zshrc
source $HOME/.zshrc
