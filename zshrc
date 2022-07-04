# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# eval "$(rbenv init - zsh)"

# Path to your oh-my-zsh installation.
export ZSH="/Users/marcos.curvello/.oh-my-zsh"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/Library/Python/3.8/bin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  jsontools
  bundler
  dotenv
  macos
  rake
  rbenv
  ruby
)

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# SYSTEM
alias .="open ."
alias dot="cd ~/.dotfiles"
alias dev="cd ~/Developer"
alias srczsh="source ~/.zshrc"
alias pwdir="pwd | tr -d \\n | pbcopy"
alias flushdns="sudo killall -HUP mDNSResponder"
alias ip="curl http://ipecho.net/plain; echo"

# FF
alias ff="cd ~/Developer/ff"
alias ffios="cd ~/Developer/ff/farfetch-ios"
alias plp="cd ~/Developer/ff/farfetch-ios/libs/slices/plp"
alias pdp="cd ~/Developer/ff/farfetch-ios/libs/slices/pdp"
alias ffcu="cd ~/Developer/ff/component-ui-kit-ios"
alias crapi="cd ~/Developer/ff/connectedretail-api"
alias ffsnaps="open ~/Developer/ff/component-ui-kit-ios/ComponentUIKitTests/SnapshotTests/ReferenceImages_64/ComponentUIKitTests.DiscoverSnapshotTests"

# XCODE
alias dd="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias pps="rm -rf ~/Library/MobileDevice/Provisioning\ Profiles/*"

# GIT
alias branch="git symbolic-ref --short HEAD | tr -d ' \n'"
alias origin="git remote -v | grep origin | head -n1 | awk '{ print $2 }'"
alias upstream="git remote -v | grep upstream | head -n1 | awk '{ print $2 }'"
alias cpbranch="git symbolic-ref --short HEAD | tr -d \\n | pbcopy"
alias cporigin="git remote -v | grep origin | head -n1 | awk '{ print $2 }' | tr -d \\n | pbcopy"
alias cpupstream="git remote -v | grep origin | head -n1 | awk '{ print $2 }' | tr -d \\n | pbcopy"
alias ghist="git log --pretty=format:'%C(green)%h %C(red)%cd %C(yellow)%<(11,mtrunc)%an %C(white)%s' --date=short"

# SCRIPTS
source $ZSH/oh-my-zsh.sh
source ~/.iterm2_shell_integration.zsh

# exa
alias ls="exa -lah"

# Load Custom Font-Glyphs
source ~/.local/share/fonts/i_oct.sh
source ~/.local/share/fonts/i_dev.sh

# Powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10kzsh.
[[ ! -f ~/.p10kzsh ]] || source ~/.p10kzsh