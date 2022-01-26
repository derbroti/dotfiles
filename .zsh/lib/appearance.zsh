# ls colors
autoload colors; colors;

# Enable ls colors
if [ "$DISABLE_LS_COLORS" != "true" ]
then
  # Find the option for using colors in ls, depending on the version: Linux or BSD
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
fi

#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS

if [[ x$WINDOW != x ]]
then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi

# Apply theming defaults
PS1="%n@%m:%~%# "
#PS1="%n@%m: "

# # $1 = type; 0 - both, 1 - tab, 2 - title
# # rest = text
# setTerminalText () {
#     # echo works in bash & zsh
#     local mode=$1 ; shift
#     echo -ne "\033]$mode;$@\007"
# }
# stt_both  () { setTerminalText 0 $@; }
# stt_tab   () { setTerminalText 1 $@; }
# stt_title () { setTerminalText 2 $@; }

