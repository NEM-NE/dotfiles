# Dotfiles overrides for the Powerlevel10k lean preset.

POWERLEVEL10K_DOTFILES_PRESET="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/config/p10k-lean.zsh"
[[ -r "$POWERLEVEL10K_DOTFILES_PRESET" ]] && source "$POWERLEVEL10K_DOTFILES_PRESET"
unset POWERLEVEL10K_DOTFILES_PRESET

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir
  vcs
  newline
  prompt_char
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  command_execution_time
  background_jobs
  direnv
  asdf
  virtualenv
  anaconda
  pyenv
  goenv
  nodenv
  nvm
  nodeenv
  rbenv
  rvm
  fvm
  luaenv
  jenv
  plenv
  perlbrew
  phpenv
  scalaenv
  haskell_stack
  kubecontext
  terraform
  aws
  aws_eb_env
  azure
  gcloud
  google_app_cred
  toolbox
  context
  nordvpn
  ranger
  nnn
  lf
  xplr
  vim_shell
  midnight_commander
  nix_shell
  chezmoi_shell
  todo
  timewarrior
  taskwarrior
  per_directory_history
  time
  newline
)

typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%244F╭─'
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%244F├─'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%244F╰─'
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%244F─╮'
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%244F─┤'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%244F─╯'
typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=' '
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
typeset -g POWERLEVEL9K_RULER_FOREGROUND=244
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='·'

if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=244
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=' '
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
  typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
fi

typeset -g POWERLEVEL9K_VCS_PREFIX='%fon '
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='%ftook '
typeset -g POWERLEVEL9K_CONTEXT_PREFIX='%fwith '
typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX='%fat '
typeset -g POWERLEVEL9K_TOOLBOX_PREFIX='%fin '
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%I:%M:%S %p}'
typeset -g POWERLEVEL9K_TIME_PREFIX='%fat '
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
