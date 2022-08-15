# TODO: Explain what some of this does..

# emacs editing mode
bindkey -e
# vim editing mode (some day maybe...)
#bindkey -v

# -s is "in string, out string"
# run ls by pressing <esc>+l
bindkey -s '\el' "ls -hal\n"
# do "cd .." with <esc>+.
bindkey -s '\e.' "..\n"
# go to last directory with <esc>+-
bindkey -s '\e-' "cd -\n"
# go home
bindkey -s '\eh' "cd ~\n"

# defined in history.zsh
# <up/down> searches in local history
bindkey "^[[A" up-line-or-local-history
bindkey "^[[B" down-line-or-local-history
# the above does not work because... debian?
# something.. something... normal vs. application mode or in short: terminals are weird
# https://invisible-island.net/xterm/xterm.faq.html#xterm_arrows
# (see /etc/zsh/zshrc)
bindkey "^[OA" up-line-or-local-history
bindkey "^[OB" down-line-or-local-history

# <ctrl>+<up/down> searches global history
bindkey "^[[1;5A" up-line-or-history
bindkey "^[[1;5B" down-line-or-history
# <alt>+<up/down> use already typed text for search in history
bindkey "^[[1;3A" up-line-or-search
bindkey "^[[1;3B" down-line-or-search

# not needed
#bindkey "^[[H" beginning-of-line
#bindkey "^[[1~" beginning-of-line
#bindkey "^[OH" beginning-of-line
#bindkey "^[[F"  end-of-line
#bindkey "^[[4~" end-of-line
#bindkey "^[OF" end-of-line

# ??? ??? from oh-my-zsh
bindkey ' ' magic-space # [Space] - don't do history expansion

# <alt>+<right>
bindkey "^[[1;3C" emacs-forward-word
# <alt>+<left>
bindkey "^[[1;3D" vi-backward-word

# again terms are weird: different codes inside and outside of tmux...
# <alt><left|right>
bindkey "^[[1;9C" emacs-forward-word
bindkey "^[[1;9D" vi-backward-word

# <ctrl>+<right>
bindkey "^[[1;5C" end-of-line
# <ctrl>+<left>
bindkey "^[[1;5D" beginning-of-line

# ???
# bindkey '^[[Z' reverse-menu-complete

bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
# delete
bindkey "^[[3~" delete-char

# moved to https://github.com/deseven/iCanHazShortcut, still on: ctrl-esc
# # open safari window in split screen - when terminal is in full screen
# toggleSafariSplit() {
#     /Users/Mirko/.macos/toggle_safari.sh
# }
# zle -N toggleSafariSplit
# # mapped to ctrl-Esc (see iterm keymap)
# bindkey "^[[1;3R" toggleSafariSplit


# deactivate S-F11, M-F8, M-F9 (tmux takes hold of them on its own)
# used for forwarding tmux-disable toggle (nested sessions)
bindkey -s "^[[23;2~" ''
bindkey -s "^[[19;3~" ''
bindkey -s "^[[20;3~" ''

# deactivate M-F10, M-F11, C-F{1-4} - vim uses them
bindkey -s "^[[21;3~" ''
bindkey -s "^[[23;3~" ''

bindkey -s "^[[1;5P" ''
bindkey -s "^[[1;5Q" ''
bindkey -s "^[[1;5R" ''
bindkey -s "^[[1;5S" ''
