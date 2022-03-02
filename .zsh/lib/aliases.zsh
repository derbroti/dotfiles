setopt complete_aliases

alias ll='ls -la'
alias lh='ls -lah'
alias ...='cd ../..'
alias now='date +%s'
alias config='/usr/bin/git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME'

if [[ -v SSH_CLIENT ]]; then
    alias git='HOME="${ANYRC_HOME}" $(sh -c '\''which git'\'') "$@"'
    alias tmux='tmux -f ~/.anyrc/.anyrc.d/.tmux.conf "$@"'
fi

alias python=/opt/homebrew/bin/python3
alias pip=/opt/homebrew/bin/pip3

alias brew86="arch -x86_64 /usr/local/bin/brew"
alias brew="/opt/homebrew/bin/brew"

alias sha256="openssl dgst -sha256"

# run with x86 node #ugly...
# changed joplin itself to not use systemwide node but specific x86 build
#alias joplin='PATH=/usr/local/bin:"${PATH}" joplin'
