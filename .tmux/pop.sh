#!/usr/bin/env bash

POPS=$(tmux showenv -g POPS)
SESS=$(tmux display-message -p "#{session_id}")

if [ -z "$POPS" ]; then
    tmux resize-pane -Z
    tmux has-session -t popup
    if [ $? -ne 0 ]; then
        tmux new -ds popup
    fi
    tmux switch-client -t popup
    TTY=$(tmux display-message -p "#{pane_tty}")
    sleep 0.15
    echo -ne "\033[2J" > $TTY
    tmux display-popup -xC -y81 -b'rounded' -h'99%' -E "tmux attach -t '${SESS}' \; select-pane \; setenv -Fg POPS \"#{client_pid}\" \; set status off \; set pane-border-status off"
else
    PID=$(tmux showenv -g POPS | cut -d'=' -f2)
    ps -p $PID > /dev/null
    if [ $? -eq 0 ]; then
        tmux resize-pane -Z
        tmux detach
        tmux switch-client -t ${SESS}
        tmux set status on
        tmux set pane-border-status bottom
        tmux kill-session -t popup
    fi
    tmux setenv -gu POPS
fi
exit 0
