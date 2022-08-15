#!/bin/bash

# based on: https://sunaku.github.io/tmux-yank-osc52.html

buf=$(cat "$@" 2>/dev/null)
len=$( printf %s "$buf" | wc -c )
max=74994

if [ $len -gt $max ]
then
    err_msg="Did not copy! Buf is $(( $len - $max )) bytes too long."
    err_msg_len=$(( ${#err_msg} + 6 ))
    if [ -z ${TMUX} ]
    then
        printf "${err_msg}" >&2
    else
        if [ ${err_msg_len} -gt $(tmux display -p "#{pane_width}") ]
        then
            # TODO shorten the message - this happens only when the window is too short in the
            # first place
            tmux display -d5000 "${err_msg}"
        else
            tmux display-popup -E -h3 -w"${err_msg_len}" "echo \"  ${err_msg}\" && sleep 5"
        fi
    fi
    # important - we have no length check in the osc52 assignment below
    exit 1
fi

osc52="\033]52;c;$( printf %s "${buf}" | base64 | tr -d '\r\n' )\a"

# outside_tmux: for running vim on server without tmux on server but locally
# -> the local tmux snags the osc escape sequence...
if [ -n "${buf}" ]
then
    if [ -n "${TMUX}" ]
    then
        tmux set-buffer "${buf}"
    fi
    if [ -n "${TMUX}" ] || [ -n "${OUTSIDE_TMUX}" ]
    then
        osc52="\033Ptmux;\033${osc52}\033\\"
    fi
    printf "${osc52}" > "${SSH_TTY}"
else
    if [ -n "${TMUX}" ]
    then
        # tmux has a hard limit ot 5 seconds for any escape sequence
        OLD_ESC_TIME=$(tmux display-message -p "#{escape-time}")
        tmux set -sg escape-time 5000
        REPLY=$(tmux refresh-client -l ${TMUX_PANE})
        tmux set -sg escape-time ${OLD_ESC_TIME}
        read -rs -u0 -d$'\\' < $SSH_TTY
        REPLY=${REPLY:0:-1}
    else
        osc52="\033]52;c;?\a"
        if [ -n "${OUTSIDE_TMUX}" ]
        then
            osc52="\033Ptmux;\033${osc52}\033\\"
        fi
        printf "${osc52}" > "${SSH_TTY}"
        read -rs -u0 -d$'\a' < $SSH_TTY
    fi
    echo ${REPLY##*;} | /usr/bin/base64 -d -
fi
