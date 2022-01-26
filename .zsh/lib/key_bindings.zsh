# TODO: Explain what some of this does..

# emacs editing mode
bindkey -e
# vim editing mode (some day maybe...)
#bindkey -v

# do not want #bindkey '\ew' kill-region

# run ls by pressing <esc>+l
bindkey -s '\el' "ls -hal\n"
# do "cd .." with <esc>+.
bindkey -s '\e.' "..\n"
# go to last directory with <esc>+-
bindkey -s '\e-' "cd -\n"

# <fn>+<up/down> (aka <Page Up/Down>): use already typed text for search in history
bindkey "^[[5~" up-line-or-search
bindkey "^[[6~" down-line-or-search

# not needed
#bindkey "^[[H" beginning-of-line
#bindkey "^[[1~" beginning-of-line
#bindkey "^[OH" beginning-of-line
#bindkey "^[[F"  end-of-line
#bindkey "^[[4~" end-of-line
#bindkey "^[OF" end-of-line

# ???
# bindkey ' ' magic-space    # also do history expansion on space

# <ctrl>+<right>
bindkey "^[[1;5C" forward-word
# <ctrl>+<left>
bindkey "^[[1;5D" backward-word
# ???
bindkey '^[[Z' reverse-menu-complete

# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

