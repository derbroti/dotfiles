# used for anyrc to specify a different path for the config files
if [[ -v ZDOTDIR ]]; then
    export ZSH=$ZDOTDIR/.zsh
else
    export ZSH=~/.zsh
fi

# if we are connecting via ssh (through anyrc, which sets "PRINT_MOTD"), print the motd once
if [[ -v PRINT_MOTD && -v SSH_CLIENT ]]; then
    run-parts /etc/update-motd.d/
    unset PRINT_MOTD
fi

# have 1 trailing space in rprompt
# my screen resolution results in an uneven tmux split... moving stuff around is ugly otherwise
ZLE_RPROMPT_INDENT=1

# ignore ctrl+d (eof) to prevent accidental closing...
setopt ignore_eof

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export HOMEBREW_NO_AUTO_UPDATE=1

# Load all of the config files in ~/oh-my-zsh that end in .zsh
for config_file ($ZSH/lib/*.zsh) source $config_file

# Extend Autocomplete Search Path
fpath=($HOME/.zsh/lib/completions $fpath)

WORDCHARS='*?_-[]~&;!$%^(){}<>'

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Go Path related exports
export GOPATH=/Users/Mirko/Projects/GO
export PATH=$PATH:$GOPATH/bin

#???
export CORRECT_IGNORE_FILE='.*'

# set-window-title() {
#   window_title="\e]0;${PWD/#"$HOME"/~}\a"
#   echo -ne "$window_title"
# }
#
# PR_TITLEBAR=''
# set-window-title
# add-zsh-hook precmd set-window-title

#???
unsetopt correct_all
#setopt correct

# ignore commands starting with a #
# set -k
setopt interactivecomments

export PICO_SDK_PATH=/Users/Mirko/Projects/rpi-pico/pico-sdk

source $ZSH/.github.token

# arm brew
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
# more recent bc
export PATH="/opt/homebrew/opt/bc/bin:$PATH"

LS_COMPL_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:or=40;31;01:"
zstyle ':completion:*' list-colors ${(s.:.)LS_COMPL_COLORS}

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _prefix
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' max-errors 0
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/Users/Mirko/.zshrc'

autoload -Uz compinit
compinit -i
# End of lines added by compinstall

