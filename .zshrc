if [[ -v ZDOTDIR ]]; then
    export ZSH=$ZDOTDIR/.zsh
else
    export ZSH=~/.zsh
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export HOMEBREW_NO_AUTO_UPDATE=1

# Load all of the config files in ~/oh-my-zsh that end in .zsh
for config_file ($ZSH/lib/*.zsh) source $config_file

# Extend Autocomplete Search Path
fpath=($HOME/.zsh/lib/completions $fpath)

# Load and run compinit
autoload -U compinit
compinit -i

PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Go Path related exports
export GOPATH=/Users/Mirko/Projects/GO
export PATH=$PATH:$GOPATH/bin

export CORRECT_IGNORE_FILE='.*'

set-window-title() {
  # /Users/clessg/projects/dotfiles -> ~/p/dotfiles
  window_title="\e]0;${PWD/#"$HOME"/~}\a"
  echo -ne "$window_title"
}

PR_TITLEBAR=''
set-window-title
add-zsh-hook precmd set-window-title

unsetopt correct_all
#setopt correct

unsetopt INC_APPEND_HISTORY
setopt APPEND_HISTORY

# ignore commands starting with a #
set -k

# alias kbl="kb list"
# alias kbe="kb edit"
# alias kba="kb add"
# alias kbv="kb view"
# alias kbs="kb view"
# alias kbd="kb delete --id"
# alias kbg="kb grep"
# alias kbt="kb list --tags"
# alias kbn="kb add --title"

alias sha256="openssl dgst -sha256"

#bindkey "^[[1;3C" forward-word
#bindkey "^[[1;3D" backward-word

export PICO_SDK_PATH=/Users/Mirko/Projects/rpi-pico/pico-sdk

alias brew86="arch -x86_64 /usr/local/bin/brew"
alias brew="/opt/homebrew/bin/brew"
export HOMEBREW_GITHUB_API_TOKEN=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
export PATH=/opt/homebrew/bin:$PATH

alias python=/opt/homebrew/bin/python3
alias pip=/opt/homebrew/bin/pip3

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

