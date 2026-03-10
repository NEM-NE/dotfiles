#!/bin/bash
# sync.sh - Idempotent dotfiles sync script
# Safe to run repeatedly on any machine to converge to dotfiles state.

set -euo pipefail
DOTFILES="$HOME/dotfiles"

echo "==> Syncing dotfiles from $DOTFILES"

# --- Helper: safe envsubst using only KEY=VALUE lines from secrets file ---
# Avoids sourcing arbitrary shell code (#3 fix)
load_secrets() {
  local secrets_file="$1"
  while IFS='=' read -r key value; do
    # skip blank lines and comments
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
    # strip surrounding quotes from value
    value="${value%\"}"
    value="${value#\"}"
    export "$key=$value"
  done < "$secrets_file"
}

# --- Symlinks (ln -nfs is always idempotent) ---

# gitconfig
ln -nfs "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -nfs "$DOTFILES/.gitconfig-private" "$HOME/.gitconfig-private"

# zshrc
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo "    Backing up existing .zshrc to .zshrc.backup"
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -nfs "$DOTFILES/.zshrc" "$HOME/.zshrc"

# p10k prompt config
if [ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
  echo "    Backing up existing .p10k.zsh to .p10k.zsh.backup"
  cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup"
fi
ln -nfs "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"

# claude code config
if [ -d "$HOME/.claude" ] && [ ! -L "$HOME/.claude" ]; then
  echo "    Migrating existing ~/.claude to $DOTFILES/.claude-home"
  rsync -a "$HOME/.claude/" "$DOTFILES/.claude-home/"
  rm -rf "$HOME/.claude"
fi
ln -nfs "$DOTFILES/.claude-home" "$HOME/.claude"

# codex config
if [ -d "$HOME/.codex" ] && [ ! -L "$HOME/.codex" ]; then
  echo "    Migrating existing ~/.codex to $DOTFILES/.codex-home"
  rsync -a "$HOME/.codex/" "$DOTFILES/.codex-home/"
  rm -rf "$HOME/.codex"
fi
ln -nfs "$DOTFILES/.codex-home" "$HOME/.codex"

# codex: generate config.toml from template + secrets
if [ -f "$DOTFILES/.codex-home/config.toml.template" ]; then
  SECRETS_FILE="$DOTFILES/.codex-home/.secrets"
  if [ -f "$SECRETS_FILE" ]; then
    chmod 600 "$SECRETS_FILE"
    load_secrets "$SECRETS_FILE"
    if command -v envsubst &>/dev/null; then
      envsubst < "$DOTFILES/.codex-home/config.toml.template" > "$DOTFILES/.codex-home/config.toml"
      chmod 600 "$DOTFILES/.codex-home/config.toml"
      echo "    Generated codex config.toml from template"
    else
      echo "    WARNING: envsubst not found. Install gettext: brew install gettext"
      cp "$DOTFILES/.codex-home/config.toml.template" "$DOTFILES/.codex-home/config.toml"
    fi
  else
    echo "    WARNING: $SECRETS_FILE not found. Create it with your API keys, then re-run sync.sh"
    # only copy if config.toml doesn't exist yet (#2 fix: avoid cp -n exit code 1)
    [ -f "$DOTFILES/.codex-home/config.toml" ] || \
      cp "$DOTFILES/.codex-home/config.toml.template" "$DOTFILES/.codex-home/config.toml"
  fi
fi

# vim
mkdir -p "$HOME/.vim_runtime"
ln -nfs "$DOTFILES/sungvimrc" "$HOME/.vim_runtime/sungvimrc"
ln -nfs "$DOTFILES/sungvimrc/my_configs.vim" "$HOME/.vim_runtime/my_configs.vim"
sh "$DOTFILES/sungvimrc/install_awesome_vimrc.sh"

# nvim (#7 fix: backup existing non-symlink nvim config)
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "    Backing up existing ~/.config/nvim to ~/.config/nvim.backup"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
fi
ln -nfs "$DOTFILES/sungvimrc/nvim" "$HOME/.config/nvim"

# --- Workspace gitconfig ---

mkdir -p "$HOME/Desktop/workspace"
ln -nfs "$DOTFILES/.gitconfig-private" "$HOME/Desktop/workspace/.gitconfig-private"

# --- Zsh plugins (clone only if missing) ---

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$HOME/.oh-my-zsh" ]; then
  [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

  [ -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ] || \
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"

  [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# iTerm2 profile
if [ -f "$DOTFILES/iterm_theme.json" ]; then
  ITERM_PROFILE_GUID="59B040BC-39FC-4B91-AC47-5A6E78458F26"
  ITERM_PROFILE_NAME="Dotfiles"
  ITERM_DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  ITERM_DYNAMIC_PROFILE_PATH="$ITERM_DYNAMIC_PROFILES_DIR/dotfiles.json"

  mkdir -p "$ITERM_DYNAMIC_PROFILES_DIR"
  if command -v jq &>/dev/null; then
    jq \
      --arg guid "$ITERM_PROFILE_GUID" \
      --arg name "$ITERM_PROFILE_NAME" \
      --arg home "$HOME" \
      '{
        Profiles: [
          . |
          .Guid = $guid |
          .Name = $name |
          .Description = $name |
          ."Working Directory" = $home |
          ."Custom Directory" = "No"
        ]
      }' \
      "$DOTFILES/iterm_theme.json" > "$ITERM_DYNAMIC_PROFILE_PATH"
    defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "$ITERM_PROFILE_GUID"
    echo "    Installed iTerm2 dynamic profile ($ITERM_PROFILE_NAME)"
  else
    echo "    WARNING: jq not found. Skipping iTerm2 profile install"
  fi
fi

echo "==> Sync complete!"
