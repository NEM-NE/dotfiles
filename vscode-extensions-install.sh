#!/usr/bin/env bash

# 색상 출력 함수
ok() {
    echo "✅ $1"
}

error() {
    echo "❌ $1"
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/vscode-extensions.txt"

code -v > /dev/null
if [[ $? -eq 0 ]];then
    read -r -p "Do you want to install VSC extensions? [y|N] " configresponse
    if [[ $configresponse =~ ^(y|yes|Y) ]];then
        ok "Installing extensions please wait..."

        if [ -f "$EXTENSIONS_FILE" ]; then
            while IFS= read -r extension; do
                # 빈 줄이나 주석(#로 시작) 무시
                [[ -z "$extension" || "$extension" =~ ^# ]] && continue
                echo "Installing $extension..."
                code --install-extension "$extension"
            done < "$EXTENSIONS_FILE"
            ok "Extensions for VSC have been installed. Please restart your VSC."
        else
            error "Extensions file not found: $EXTENSIONS_FILE"
        fi
    else
        ok "Skipping extension install.";
    fi

    read -r -p "Do you want to overwrite user config? [y|N] " configresponse
    if [[ $configresponse =~ ^(y|yes|Y) ]];then
        read -r -p "Do you want to back up your current user config? [Y|n] " backupresponse
        if [[ $backupresponse =~ ^(n|no|N) ]];then
            ok "Skipping user config save."
        else
            cp "$HOME/Library/Application Support/Code/User/settings.json" "$HOME/Library/Application Support/Code/User/settings.backup.json"
            ok "Your previous config has been saved to: $HOME/Library/Application Support/Code/User/settings.backup.json"
        fi

        if [ -f "$SCRIPT_DIR/settings.json" ]; then
            cp "$SCRIPT_DIR/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
            ok "New user config has been written. Please restart your VSC."
        else
            error "settings.json not found in dotfiles directory"
        fi
    else
        ok "Skipping user config overwriting.";
    fi
else
    error "It looks like the command 'code' isn't accessible."
    error "Please make sure you have Visual Studio Code installed"
    error "And that you executed this procedure: https://code.visualstudio.com/docs/setup/mac"
fi
