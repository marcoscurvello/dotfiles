# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# eval "$(rbenv init - zsh)"

# Path to your oh-my-zsh installation.
export ZSH="/Users/marcos.curvello/.oh-my-zsh"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# SPACESHIP PROMPT
ZSH_THEME="spaceship"


# GIT
# User email helper function
spaceship_git_useremail() {
  spaceship::is_git || return

    local useremail

    useremail="$(git config user.email)"

    if [[ -n $useremail ]]; then
      spaceship::section \
        "magenta" \
        "$useremail"
        fi
}

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  git_useremail # Git user.email
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  package       # Package version
  node          # Node.js section
  elixir        # Elixir section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  gcloud        # Google Cloud Platform section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code sectio
  ruby          # Ruby section
  char          # Prompt character
)

SPACESHIP_RPROMPT_ORDER=(
  time          # Time stamps section
  exec_time     # Execution time
)

# PROMPT
SPACESHIP_PROMPT_DEFAULT_PREFIX=""

# RIGHT PROMPT
SPACESHIP_RPROMPT_ADD_NEWLINE=true

# CHAR
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_CHAR_SYMBOL="$"

# USER
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX="" # remove `with` before username
SPACESHIP_USER_SUFFIX=":" # remove space before host

# HOST
# Result will look like this:
#   username@:(hostname)
# SPACESHIP_HOST_PREFIX="@:("
# SPACESHIP_HOST_SUFFIX=") "

# DIR
SPACESHIP_DIR_PREFIX=":" # disable directory prefix, cause it's not the first section
SPACESHIP_DIR_SUFFIX='%B%F{cyan}:%f%b' # disable directory prefix, cause it's not the first section
SPACESHIP_DIR_TRUNC='1' # show only last directory

# GIT
# Disable git symbol
SPACESHIP_GIT_SYMBOL=":" # disable git prefix
SPACESHIP_GIT_BRANCH_PREFIX="" # disable branch prefix too
# Wrap git in `git:(...)`
SPACESHIP_GIT_PREFIX="%B%F{cyan}(%f%b"
SPACESHIP_GIT_SUFFIX="%B%F{cyan}) %f%b"
SPACESHIP_GIT_BRANCH_SUFFIX="" # remove space after branch name
# Unwrap git status from `[...]`
# SPACESHIP_GIT_STATUS_PREFIX=""
# SPACESHIP_GIT_STATUS_SUFFIX=""

SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_TIME_SHOW=true

# SPACESHIP_PROMPT_ORDER=($SPACESHIP_PROMPT_ORDER)

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
#

alias .="open ."
alias dot="cd ~/.dotfiles"
alias dev="cd ~/Developer"

# XCODE
alias dd="rm -rf ~/Library/Developer/Xcode/DerivedData"

# GIT
alias branch="git symbolic-ref --short HEAD | tr -d ' \n'"
alias origin="git remote -v | grep origin | head -n1 | awk '{ print $2 }'"
alias upstream="git remote -v | grep upstream | head -n1 | awk '{ print $2 }'"

alias cpbranch="git symbolic-ref --short HEAD | tr -d \\n | pbcopy"
alias cporigin="git remote -v | grep origin | head -n1 | awk '{ print $2 }' | tr -d \\n | pbcopy"
alias cpupstream="git remote -v | grep origin | head -n1 | awk '{ print $2 }' | tr -d \\n | pbcopy"

# FF
alias ff="cd ~/Developer/farfetch"
alias ffios="cd ~/Developer/farfetch/farfetch-ios"
alias plp="cd ~/Developer/farfetch/farfetch-ios/libs/slices/plp"
alias pdp="cd ~/Developer/farfetch/farfetch-ios/libs/slices/pdp"
alias comp="cd ~/Developer/farfetch/component-ui-kit-ios"
alias crapi="cd ~/Developer/farfetch/connectedretail-api"
alias ffsnaps="open ~/Developer/farfetch/component-ui-kit-ios/ComponentUIKitTests/SnapshotTests/ReferenceImages_64/ComponentUIKitTests.DiscoverSnapshotTests"

# Helpers
alias pwdir="pwd | tr -d \\n | pbcopy"
alias dd="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias ip="curl http://ipecho.net/plain; echo"
alias flushdns="sudo killall -HUP mDNSResponder"
alias src="source ~/.zshrc"

# Scripts
source $ZSH/oh-my-zsh.sh
source ~/.iterm2_shell_integration.zsh

# exa
alias ls="exa -lah"
