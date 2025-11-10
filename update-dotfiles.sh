#!/usr/bin/env bash

# 현재 시스템의 dotfiles를 레포지토리로 업데이트하는 스크립트

set -e

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

echo "🔄 Updating dotfiles from system configuration..."

# 색상 출력 함수
ok() {
    echo "✅ $1"
}

warn() {
    echo "⚠️  $1"
}

error() {
    echo "❌ $1"
}

# .zshrc 업데이트
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc"
    ok "Updated .zshrc"
else
    warn ".zshrc not found in home directory"
fi

# .gitconfig 업데이트
if [ -f "$HOME/.gitconfig" ]; then
    # 심볼릭 링크인지 확인
    if [ -L "$HOME/.gitconfig" ]; then
        warn ".gitconfig is a symbolic link, skipping copy"
    else
        cp "$HOME/.gitconfig" "$DOTFILES_DIR/.gitconfig"
        ok "Updated .gitconfig"
    fi
else
    warn ".gitconfig not found in home directory"
fi

# .gitconfig-work 업데이트
if [ -f "$HOME/.gitconfig-work" ]; then
    if [ -L "$HOME/.gitconfig-work" ]; then
        warn ".gitconfig-work is a symbolic link, skipping copy"
    else
        cp "$HOME/.gitconfig-work" "$DOTFILES_DIR/.gitconfig-work"
        ok "Updated .gitconfig-work"
    fi
fi

# Brewfile 업데이트
echo ""
echo "📦 Updating Brewfile..."
if command -v brew &> /dev/null; then
    brew bundle dump --file="$DOTFILES_DIR/Brewfile" --force
    ok "Updated Brewfile"
else
    error "Homebrew not installed, skipping Brewfile update"
fi

# VSCode 확장 목록 업데이트
echo ""
echo "💻 Updating VSCode extensions list..."
if command -v code &> /dev/null; then
    VSCODE_EXTENSIONS_FILE="$DOTFILES_DIR/vscode-extensions.txt"
    code --list-extensions > "$VSCODE_EXTENSIONS_FILE"
    ok "Updated VSCode extensions list to vscode-extensions.txt"
else
    warn "VSCode CLI not found, skipping extensions update"
fi

# PyCharm 플러그인 목록 업데이트
echo ""
echo "🐍 Updating PyCharm plugin list..."
if [ -f "$DOTFILES_DIR/update-pycharm-plugin-list.sh" ]; then
    bash "$DOTFILES_DIR/update-pycharm-plugin-list.sh"
else
    warn "update-pycharm-plugin-list.sh not found"
fi

# Git 상태 확인
echo ""
echo "📊 Git status:"
git status --short

echo ""
echo "✨ Dotfiles update complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Review changes: git diff"
echo "   2. Commit changes: git add . && git commit -m 'Update dotfiles'"
echo "   3. Push to remote: git push"