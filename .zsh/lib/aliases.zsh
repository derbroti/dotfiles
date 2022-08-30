setopt complete_aliases

alias ll='ls -al'
alias lh='ls -hal'
alias ...='cd ../..'
alias now='date +%s'

# alias for dotfiles repo
alias config='/usr/bin/git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME'

# anyrc switch to pass configs to git and tmux
if [[ -v SSH_CLIENT ]]; then
    alias git='HOME="${ANYRC_HOME}" $(sh -c '\''which git'\'') "$@"'
    alias tmux='tmux -f ~/.anyrc/.anyrc.d/.tmux.conf "$@"'
fi

# there is no python2!
alias python=/opt/homebrew/bin/python3
alias pip=/opt/homebrew/bin/pip3

# brew is arm brew, brew86 is intel brew
alias brew86="arch -x86_64 /usr/local/bin/brew"
alias brew="/opt/homebrew/bin/brew"

alias sha256="openssl dgst -sha256"

alias d='dirs -v'
for index in {0..9}; alias "$index"="cd +${index}"
unset index

# <obsolete>
# run with x86 node #ugly...
# changed joplin itself to not use systemwide node but specific x86 build
#alias joplin='PATH=/usr/local/bin:"${PATH}" joplin'
