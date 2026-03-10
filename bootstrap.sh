#!/bin/bash
# bootstrap.sh - First-time setup for a new machine.
# Installs dependencies, then calls sync.sh for idempotent config.

set -euo pipefail
DOTFILES="$HOME/dotfiles"

# --- Homebrew ---

if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Updating Homebrew"
  brew update
fi

brew bundle --file="$DOTFILES/Brewfile"
brew cleanup

# --- Zsh ---

if [ "$SHELL" != "$(which zsh)" ]; then
  echo "==> Changing default shell to zsh"
  chsh -s "$(which zsh)"
fi

# --- Oh My Zsh ---

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Sync dotfiles ---

echo "==> Running sync.sh"
bash "$DOTFILES/sync.sh"

# --- Dock ---

if command -v dockutil &>/dev/null; then
  echo "==> Configuring Dock"
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
else
  echo "==> dockutil not found, skipping Dock setup"
fi

# --- PyCharm plugins ---

if [ -x "$DOTFILES/pycharm-plugin-install.sh" ]; then
  echo "==> Installing PyCharm plugins"
  bash "$DOTFILES/pycharm-plugin-install.sh"
fi

# --- Secrets reminder ---

if [ ! -f "$DOTFILES/.codex-home/.secrets" ]; then
  echo ""
  echo "NOTE: Create $DOTFILES/.codex-home/.secrets with your API keys:"
  echo '  CONTEXT7_API_KEY="your-key"'
  echo '  DATA_GO_KR_API_KEY="your-key"'
  echo "Then run: ./sync.sh"
fi

echo "==> Bootstrap complete! Restart your terminal and iTerm2."
