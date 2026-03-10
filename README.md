## Dotfiles

My personal macOS dotfiles.

### Structure

```
dotfiles/
├── bootstrap.sh             # New machine: full install (brew, oh-my-zsh, ...) + sync
├── sync.sh                  # Existing machine: idempotent config sync
├── .gitconfig               # Git config (name, alias, template)
├── .gitconfig-private       # Git config override for ~/Desktop/workspace/
├── .zshrc                   # Zsh config (plugins, aliases, pyenv, sdkman)
├── .p10k.zsh                # Powerlevel10k prompt config
├── .gitignore_global        # Global gitignore
├── Brewfile                 # Homebrew packages & casks
├── my_configs.vim           # IdeaVIM config (multiple cursors)
├── .git_template/           # Git template (pre-commit hook)
├── .claude-home/            # Claude Code global config (~/.claude)
├── .codex-home/             # Codex CLI global config (~/.codex)
│   ├── config.toml.template # Codex config ($HOME + API keys as placeholders)
│   ├── .secrets             # API keys (gitignored)
│   └── ...
├── sungvimrc/               # Vim/Neovim config (submodule)
│   ├── nvim/                # Neovim (lazy.nvim)
│   └── my_configs.vim       # Classic vim config
├── pycharm-plugin-install.sh
├── pycharm-plugins.txt
└── iterm_theme.json         # iTerm2 theme source for generated dynamic profile
```

### Quick Start

#### New machine

```bash
# 1. Xcode CLI tools
xcode-select --install

# 2. Clone & bootstrap
git clone --recursive https://github.com/NEM-NE/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh

# 3. Create secrets file for Codex MCP servers
cat > .codex-home/.secrets << 'EOF'
CONTEXT7_API_KEY="your-key-here"
DATA_GO_KR_API_KEY="your-key-here"
EOF

# 4. Re-sync to generate codex config.toml
./sync.sh
```

`bootstrap.sh` installs:
- Homebrew + Brewfile packages (includes `gettext` for envsubst, `dockutil`)
- Oh My Zsh + plugins (syntax-highlighting, autosuggestions, history-substring-search)
- Powerlevel10k theme + Meslo Nerd Font
- Dock layout (if dockutil is available)

Then calls `sync.sh` for config sync.

#### Existing machine (sync after dotfiles update)

```bash
cd ~/dotfiles
git pull --recurse-submodules
./sync.sh
```

### What `sync.sh` does

Idempotent - safe to run repeatedly.

| Target | Source |
|--------|--------|
| `~/.gitconfig` | `.gitconfig` |
| `~/.gitconfig-private` | `.gitconfig-private` |
| `~/.zshrc` | `.zshrc` |
| `~/.p10k.zsh` | `.p10k.zsh` |
| `~/.claude` | `.claude-home/` |
| `~/.codex` | `.codex-home/` |
| `~/.vim_runtime/sungvimrc` | `sungvimrc/` |
| `~/.vim_runtime/my_configs.vim` | `sungvimrc/my_configs.vim` |
| `~/.config/nvim` | `sungvimrc/nvim/` |
| `~/Desktop/workspace/.gitconfig-private` | `.gitconfig-private` |
| `~/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json` | generated from `iterm_theme.json` |

Codex `config.toml` is generated from `config.toml.template` + `.secrets` via `envsubst`.
Template uses `${HOME}` for paths, so it adapts to different usernames.

### Secrets management

Codex MCP server API keys are stored separately:

```bash
# .codex-home/.secrets (gitignored, pure KEY=VALUE, no shell code)
CONTEXT7_API_KEY="your-key-here"
DATA_GO_KR_API_KEY="your-key-here"
```

On a new machine, create this file manually, then run `sync.sh` to generate `config.toml`.

Codex `real-estate` MCP server requires an external repo:

```bash
cd ~/Desktop/workspace
git clone <real-estate-mcp-repo-url>
cd real-estate-mcp
python -m venv .venv && .venv/bin/pip install -e .
```

### iTerm2 profile

`sync.sh` generates a Dynamic Profile from `iterm_theme.json`, places it in
`~/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json`, and sets
its GUID as the iTerm2 default profile. Restart iTerm2 after syncing to load it.

### Reference

[dotfiles blog post](https://blog.appkr.dev/work-n-play/dotfiles/)
