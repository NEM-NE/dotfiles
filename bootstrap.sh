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

# install space vim
# curl -sLf https://spacevim.org/install.sh | bash

# set gitconfig
[ ! -f $HOME/Desktop/vssl/.gitconfig-work ] && mkdir $HOME/Dekstop/vssl && ln -nfs $HOME/dotfiles/.gitconfig-work $HOME/Desktop/vssl/.gitconfig-work

[ ! -f $HOME/Desktop/workspace/.gitconfig-work ] && mkdir $HOME/Dekstop/workspace && ln -nfs $HOME/dotfiles/.gitconfig-private $HOME/Desktop/vssl/.gitconfig-private

chsh -s $(which zsh)
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
[ ! -f $HOME/.zshrc ] && ln -nfs $HOME/dotfiles/.zshrc $HOME/.zshrc
source $HOME/.zshrc

echo "*** Install dockutils from source (https://github.com/kcrawford/dockutil/issues/127) ***"
DOCKUTIL_URL=$(curl --silent "https://api.github.com/repos/kcrawford/dockutil/releases/latest" | jq -r .assets[].browser_download_url | grep pkg)
curl -sL "${DOCKUTIL_URL}" -o /tmp/dockutil.pkg
sudo installer -pkg "/tmp/dockutil.pkg" -target /
rm /tmp/dockutil.pkg

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/YT Music.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Cron.app"
dockutil --no-restart --add "/System/Applications/Notes.app"
dockutil --no-restart --add "/System/Applications/System\ Settings.app/"
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/Mail.app"


