#!/bin/sh


# original code :https://blog.appkr.dev/work-n-play/dotfiles/

which -s brew
if [[ $? != 0 ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    brew update
fi

brew update
brew tap homebrew/bundle
brew bundle --file=$HOME/dotfiles/Brewfile
brew cleanup

[ ! -f $HOME/.gitconfig ] && ln -nfs $HOME/dotfiles/.gitconfig $HOME/.gitconfig
[ ! -f $HOME/.gitconfig-work ] && ln -nfs $HOME/dotfiles/.gitconfig-work $HOME/.gitconfig-work

# set vimrc
[ ! -d ~/.vim_runtime ] && mkdir ~/.vim_runtime
[ ! -L ~/.vim_runtime/sungvimrc ] && ln -s $HOME/dotfiles/sungvimrc ~/.vim_runtime

# install vim-plugin
sh $HOME/dotfiles/sungvimrc/install_awesome_vimrc.sh

# set gitconfig for work directories
[ ! -d $HOME/Desktop/toss ] && mkdir -p $HOME/Desktop/toss
[ ! -f $HOME/Desktop/toss/.gitconfig-work ] && ln -nfs $HOME/dotfiles/.gitconfig-work $HOME/Desktop/toss/.gitconfig-work

[ ! -d $HOME/Desktop/workspace ] && mkdir -p $HOME/Desktop/workspace
[ ! -f $HOME/Desktop/workspace/.gitconfig-private ] && ln -nfs $HOME/dotfiles/.gitconfig-private $HOME/Desktop/workspace/.gitconfig-private

# zsh
chsh -s $(which zsh)

# install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended
fi

# backup existing .zshrc if it exists and is not a symlink
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -nfs $HOME/dotfiles/.zshrc $HOME/.zshrc

# install zsh-plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

[ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ] && \
  git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search

# install powerlevel10k
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k


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
dockutil --no-restart --add "/System/Applications/System Settings.app/"
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/Mail.app"
killall Dock

# install vscode-extensions
./vscode-extensions-install.sh
