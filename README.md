## Dotfiles

My Personal dotfiles

### Prerequisites

새 Mac에서 처음 시작하는 경우:

1. **Xcode Command Line Tools 설치 필요**
   - Git, curl 등 기본 개발 도구가 포함됨
   - `init.sh` 스크립트가 자동으로 설치 여부를 확인하고 설치 안내를 제공합니다

2. **bootstrap.sh가 자동으로 설치하는 것들**
   - Homebrew
   - Oh My Zsh
   - Zsh 플러그인들 (syntax-highlighting, autosuggestions, history-substring-search)
   - Powerlevel10k 테마
   - Brewfile에 정의된 모든 패키지 및 애플리케이션

### How to start?

**1단계: 초기 설정 (새 Mac인 경우)**

```bash
# dotfiles 레포지토리를 클론하지 않은 경우
curl -fsSL https://raw.githubusercontent.com/NEM-NE/dotfiles/main/init.sh | bash

# 또는 이미 클론한 경우
cd ~/dotfiles
chmod +x ./init.sh
./init.sh
```

`init.sh`는 다음을 수행합니다:
- Xcode Command Line Tools 설치 확인
- dotfiles 레포지토리 클론 (필요한 경우)
- bootstrap.sh 실행 권한 설정

**2단계: Bootstrap 실행**

```bash
cd ~/dotfiles
./bootstrap.sh
```

**3단계: iTerm2 프로필 적용**

```
iTerm2 실행 후:
Preferences -> Profiles -> Other Actions -> Import JSON Profiles
-> iterm_theme.json 선택
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
