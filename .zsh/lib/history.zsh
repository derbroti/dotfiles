## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=262144
SAVEHIST=262144

# CTRL_R will not find dups
setopt hist_find_no_dups
# append, do not overwrite if multiple sessions exist
#setopt append_history
# add timestamp to commands
setopt extended_history
# ignore command if it dups the last one
setopt hist_ignore_dups
# ignore commands with leading space
setopt hist_ignore_space
# history expansion
setopt hist_verify
# append command immediately to history
setopt inc_append_history
# share command history data
setopt share_history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

