## Dotfiles

My Personal dotfiles

### How to start?

```bash
chmod +x ./bootstrap.sh

./bootstrap.sh

# apply iterm profile
preferences -> profiles -> other Actions -> import json profiles
```

### How to update dotfiles?

시스템 설정을 변경한 후 레포지토리를 업데이트하려면:

```bash
chmod +x ./update-dotfiles.sh

./update-dotfiles.sh
```

이 스크립트는 다음 작업을 자동으로 수행합니다:
- `.zshrc` 업데이트
- `.gitconfig` 및 `.gitconfig-work` 업데이트
- `Brewfile` 업데이트 (설치된 패키지 목록)
- VSCode 확장 목록 업데이트 (`vscode-extensions.txt`)
- PyCharm 플러그인 목록 업데이트 (`pycharm-plugins.txt`)

업데이트 후 변경사항을 커밋하고 푸시하세요:

```bash
git add .
git commit -m "Update dotfiles"
git push
```

### Reference
[dotfiles 만들기](https://blog.appkr.dev/work-n-play/dotfiles/)
