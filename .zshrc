export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export PAGER=less

# used for anyrc to specify a different path for the config files
if [[ -v ZDOTDIR ]]; then
    export ZSH=$ZDOTDIR/.zsh
else
    export ZSH=~/.zsh
fi

# Load all of the config files in ~/oh-my-zsh that end in .zsh
for config_file ($ZSH/lib/*.zsh) source $config_file

# if we are connecting via ssh (through anyrc, which sets "PRINT_MOTD"), print the motd once
if [[ -v PRINT_MOTD && -v SSH_CLIENT ]]; then
    run-parts /etc/update-motd.d/
    unset PRINT_MOTD
fi

# have 1 trailing space in rprompt
# my screen resolution results in an uneven tmux split... moving stuff around is ugly otherwise
ZLE_RPROMPT_INDENT=1

WORDCHARS='*?_-[]~&;!$%^(){}<>'

# set esc key timeout to 10ms
KEYTIMEOUT=1

# ignore ctrl+d (eof) to prevent accidental closing...
setopt ignore_eof

# Extend Autocomplete Search Path
fpath=($HOME/.zsh/lib/completions $fpath)

# do not correct arguments
unsetopt correct_all

# allows to put a command into the history without executing it
# by putting a # in front of it
setopt interactivecomments

# allow multiple output redirections
# e.g.: echo Hello > foo > bar
# writes Hello into a file named foo and a file named bar
setopt multios

# print PID when using jobs
setopt long_list_jobs

# do not beep!
setopt nobeep

setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

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

export HOMEBREW_NO_AUTO_UPDATE=1
# arm brew
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
# more recent bc
export PATH="/opt/homebrew/opt/bc/bin:$PATH"

export PICO_SDK_PATH=/Users/Mirko/Projects/rpi-pico/pico-sdk

# Go Path related exports
export GOPATH=/Users/Mirko/Projects/GO
export PATH=$PATH:$GOPATH/bin

export PATH=/usr/local/bin:/usr/local/sbin:$PATH


# source github token so that we do not accidentially leak it
# via dotfiles repo
source $ZSH/.github.token

