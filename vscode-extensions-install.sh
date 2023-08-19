

code -v > /dev/null
if [[ $? -eq 0 ]];then
    read -r -p "Do you want to install VSC extensions? [y|N] " configresponse
    if [[ $configresponse =~ ^(y|yes|Y) ]];then
        ok "Installing extensions please wait..."
        code --install-extension donjayamanne.python-environment-manager
        code --install-extension donjayamanne.python-extension-pack
        code --install-extension Equinusocio.vsc-community-material-theme
        code --install-extension formulahendry.auto-close-tag
        code --install-extension formulahendry.auto-rename-tag
        code --install-extension formulahendry.code-runner
        code --install-extension foxundermoon.shell-format
        code --install-extension GitHub.github-vscode-theme
        code --install-extension golang.go
        code --install-extension googlecloudtools.cloudcode
        code --install-extension hashicorp.terraform
        code --install-extension idleberg.applescript
        code --install-extension jpoissonnier.vscode-styled-components
        code --install-extension k--kato.intellij-idea-keybindings
        code --install-extension KevinRose.vsc-python-indent
        code --install-extension ms-azuretools.vscode-docker
        code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
        code --install-extension ms-python.isort
        code --install-extension ms-python.python
        code --install-extension ms-python.vscode-pylance
        code --install-extension ms-toolsai.jupyter
        code --install-extension ms-toolsai.vscode-jupyter-cell-tags
        code --install-extension ms-toolsai.vscode-jupyter-slideshow
        code --install-extension ms-vscode-remote.remote-containers
        code --install-extension ms-vscode-remote.remote-ssh
        code --install-extension ms-vscode-remote.remote-ssh-edit
        code --install-extension ms-vscode.remote-explorer
        code --install-extension ms-vsliveshare.vsliveshare
        code --install-extension ms-vsliveshare.vsliveshare-audio
        code --install-extension ms-vsliveshare.vsliveshare-pack
        code --install-extension njpwerner.autodocstring
        code --install-extension PKief.material-icon-theme
        code --install-extension redhat.vscode-yaml
        code --install-extension ritwickdey.LiveServer
        code --install-extension tetradresearch.vscode-h2o
        code --install-extension tht13.html-preview-vscode
        code --install-extension Tim-Koehler.helm-intellisense
        code --install-extension VisualStudioExptTeam.intellicode-api-usage-examples
        code --install-extension VisualStudioExptTeam.vscodeintellicode
        code --install-extension vscjava.vscode-java-debug
        code --install-extension vscjava.vscode-java-dependency
        code --install-extension vscjava.vscode-java-pack
        code --install-extension vscjava.vscode-java-test
        code --install-extension vscjava.vscode-maven
        code --install-extension Vtrois.gitmoji-vscode
        ok "Extensions for VSC have been installed. Please restart your VSC."
    else
        ok "Skipping extension install.";
    fi

    read -r -p "Do you want to overwrite user config? [y|N] " configresponse
    if [[ $configresponse =~ ^(y|yes|Y) ]];then
        read -r -p "Do you want to back up your current user config? [Y|n] " backupresponse
        if [[ $backupresponse =~ ^(n|no|N) ]];then
            ok "Skipping user config save."
        else
            cp $HOME/Library/Application\ Support/Code/User/settings.json $HOME/Library/Application\ Support/Code/User/settings.backup.json
            ok "Your previous config has been saved to: $HOME/Library/Application Support/Code/User/settings.backup.json"
        fi
        cp ./settings.json $HOME/Library/Application\ Support/Code/User/settings.json

        ok "New user config has been written. Please restart your VSC."
    else
        ok "Skipping user config overwriting.";
    fi
else
    error "It looks like the command 'code' isn't accessible."
    error "Please make sure you have Visual Studio Code installed"
    error "And that you executed this procedure: https://code.visualstudio.com/docs/setup/mac"
fi
