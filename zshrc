# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# PATH exports
export PATH="/opt/homebrew/bin:$HOME/.rbenv/bin:$HOME/bin:$HOME/.dotfiles/bin:/usr/local/sbin:$HOME/.pyenv/bin:$PATH"

# RBENV and PYENV lazy loading
rbenv() { eval "$(command rbenv init -)"; rbenv "$@"; }
pyenv() { eval "$(command pyenv init -)"; pyenv "$@"; }

# NVM configuration with lazy loading
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && alias nvm='unalias nvm && . "$NVM_DIR/nvm.sh" && nvm'
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  jsontools
  bundler
  dotenv
  macos
  rake
  ruby
)

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Custom functions
fpath=($HOME/.zsh/functions $fpath)
autoload -U $HOME/.zsh/functions/*(:t)

# Set personal aliases, overriding those provided by oh-my-`zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# SYSTEM
alias .="open ."
alias dot="cd ~/.dotfiles"
alias dev="cd ~/Developer"

# GIT
alias branch="git symbolic-ref --short HEAD | tr -d ' \n'"
alias origin="git remote -v | grep origin | head -n1 | awk '{ print $2 }'"
alias upstream="git remote -v | grep upstream | head -n1 | awk '{ print $2 }'"

# EXA
alias ls="eza -lah"

# BAT
alias cat="bat --paging=never"

# Private aliases
[[ -f ~/.zsh_private_aliases ]] && source ~/.zsh_private_aliases

# Powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH AUTOSUGGESTIONS
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh