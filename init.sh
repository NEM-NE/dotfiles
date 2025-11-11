#!/usr/bin/env bash

# 초기 설정 스크립트 - bootstrap.sh를 실행하기 전에 필요한 의존성을 설치합니다.

set -e

echo "🚀 Starting dotfiles initialization..."
echo ""

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

# macOS 버전 확인
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is only for macOS"
    exit 1
fi

ok "Running on macOS"

# Xcode Command Line Tools 설치 확인
echo ""
echo "📦 Checking Xcode Command Line Tools..."

if xcode-select -p &> /dev/null; then
    ok "Xcode Command Line Tools already installed"
else
    warn "Installing Xcode Command Line Tools..."
    xcode-select --install

    echo ""
    echo "⏸️  Please complete the Xcode Command Line Tools installation."
    echo "   After installation is complete, run this script again."
    exit 0
fi

# Git 확인
echo ""
echo "🔍 Checking Git..."
if command -v git &> /dev/null; then
    ok "Git is installed ($(git --version))"
else
    error "Git is not installed. Please install Xcode Command Line Tools first."
    exit 1
fi

# dotfiles 디렉토리 확인
echo ""
echo "📁 Checking dotfiles directory..."

if [ -d "$HOME/dotfiles" ]; then
    ok "dotfiles directory already exists at $HOME/dotfiles"
else
    warn "dotfiles directory not found at $HOME/dotfiles"
    echo ""
    read -r -p "Do you want to clone the dotfiles repository? [y/N] " response

    if [[ $response =~ ^(y|yes|Y) ]]; then
        read -r -p "Enter your dotfiles repository URL: " repo_url

        if [ -z "$repo_url" ]; then
            error "Repository URL cannot be empty"
            exit 1
        fi

        git clone "$repo_url" "$HOME/dotfiles"
        ok "dotfiles repository cloned to $HOME/dotfiles"
    else
        error "Please create or clone your dotfiles repository to $HOME/dotfiles"
        exit 1
    fi
fi

cd "$HOME/dotfiles"

# bootstrap.sh 존재 확인
echo ""
echo "🔍 Checking bootstrap.sh..."
if [ -f "$HOME/dotfiles/bootstrap.sh" ]; then
    ok "bootstrap.sh found"

    # 실행 권한 확인 및 부여
    if [ ! -x "$HOME/dotfiles/bootstrap.sh" ]; then
        chmod +x "$HOME/dotfiles/bootstrap.sh"
        ok "Made bootstrap.sh executable"
    fi
else
    error "bootstrap.sh not found in $HOME/dotfiles"
    exit 1
fi

echo ""
echo "✨ Initialization complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Review bootstrap.sh to customize the setup"
echo "   2. Run: cd ~/dotfiles && ./bootstrap.sh"
echo ""
echo "⚠️  Note: bootstrap.sh will install Homebrew and all packages."
echo "   This may take a while depending on your internet connection."