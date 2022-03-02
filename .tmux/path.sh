#!/bin/bash
# MIT License. Copyright (c) 2022 Mirko Palmer

#     <=11<=22<=33<=44<=55<=66<=77<=88<=100
bars=(' ' '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█')
# alternative
#bars=(' ' '▏' '▎' '▍' '▌' '▋' '▊' '▉' '█')

win_len=$2
left_len=$3

client_flags=$4
client_key_table=$5

center_len=$(($win_len - $left_len))

MAXLEN=$(($center_len * 3 / 5))

now=" $(date +"%a %d %b %H:%M:%S") "
now_len=21
here=$1
here_len=${#here}
here_base=$(basename $here)
here_base_len=${#here_base}
here_slashes=$(echo $here | tr -d -c '/')
here_slashes_len=${#here_slashes}
here_min_len=$(( $here_base_len + 2 * $here_slashes_len - 1 )) # minus 1 as last slash has no ...

if [ -n "$SSH_CLIENT" ]
then
    mascot="" # "o(•_• )"
    mascot_len=8
else
    mascot="(づ｡◕‿‿◕｡)づ"
    mascot_len=12
fi

max_len=$(($MAXLEN - $now_len - $mascot_len))

# if tmux does not give any path, we try ourselves
if [[ $here = '' ]]
then
    here=" $(pwd) "
fi

while [ $here_len -gt $max_len ]
do
    here=$(echo -n $here | sed 's#[^/…][^/]*/#…/#')
    here_len=${#here}
    if [ $here_len -eq $here_min_len ]
    then
        mascot=""
        break
    fi
done
here=" ${here} "

if [ $(($here_min_len + $now_len)) -gt $MAXLEN ]
then
    now=$(date +"%H:%M")
fi

cpu=0
# update every 5 seconds
if [ $(($(date +"%-S") % 5)) -eq 0 ]
then
    # we have 8 threads, 9 indicator levels form 0 to 8 -> 0/12 = 0 100/12 = 8
    cpu=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f\n", (s/8) / 12}')
    echo $cpu > /tmp/tmux_cpu_usage
else
    if [ -f /tmp/tmux_cpu_usage ]
    then
        cpu=$(cat /tmp/tmux_cpu_usage)
    fi
fi

off=""
if [[ $client_key_table == "off" || $client_flags != *"focused"* ]]
then
    color1="#[bg=colour235,fg=colour239]"
    color2="#[bg=colour16,fg=colour242]"
    color3="#[fg=colour245,bg=black]"
    color4="#[fg=colour240,bg=black]"
    color5="#[fg=colour247,bg=black]"
    if [[ $client_key_table == "off" ]]
    then
        off="#[bg=red,fg=white] OFF #[default] "
    fi
else
    color1="#[bg=black,fg=green]"
    color2="#[fg=black,bg=white]"
    color3="#[fg=red,bg=black]"
    color4="#[fg=yellow,bg=black]"
    color5="#[fg=green,bg=black]"
fi

vpn=""
bat=""
# do not show battery when run on server
if [ -z "$SSH_CLIENT" ]
then
    bat=$(pmset -g batt | grep -o "[0-9]\{1,3\}%")
    bat=${bat%?}
    bat=$(( $bat / 12 ))
    bat=${bars[$bat]}

    vpn=$(ifconfig ipsec0 2>/dev/null | grep "RUNNING")
    if [ -n "${vpn}" ]
    then
        vpn=${bars[8]}
        #"●"
    else
        vpn=" "
    fi
else
    vpn=" "
    now="\`o(•_• )"
    color4='#[fg=colour94,bg=black]'
    bat='≀'
fi

echo "${off}${mascot}${color1}${here}${color2}${now}${color3}${bars[$cpu]}${color4}$bat${color5}${vpn}"

