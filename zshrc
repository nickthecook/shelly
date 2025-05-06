# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
source "$ZINIT_HOME/zinit.zsh"

# zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

autoload -U compinit && compinit -u

## CUSTOM

# bindings
bindkey '[1;5C' forward-word
bindkey '[1;5D' backward-word

# bind PgUp and PgDown to history-based completion
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "[5~" up-line-or-beginning-search # Up
bindkey "[6~" down-line-or-beginning-search # Down

# history
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no-select
zinit light Aloxaf/fzf-tab

# aliases
alias ls="ls --color"
alias ll="ls -lh"
alias la="ls -a"
alias grep="grep --color=auto"

# shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# this causes infinite recursion in the cd command

## custom
#
DEFAULT_USER=nickthecook

export EJSON_KEYDIR="$HOME/.ejson"

export EDITOR="vim"
# end custom

fpath+=${ZDOTDIR:-~}/.zsh_functions

eval "$(starship init zsh)"

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi
