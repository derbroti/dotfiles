#!/bin/sh
# MIT License. Copyright (c) 2022 Mirko Palmer

#     <=11<=22<=33<=44<=55<=66<=77<=88<=100
bars=(' ' '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█')

win_len=$2
left_len=$3
center_len=$(($win_len - $left_len))

MAXLEN=$(($center_len * 3 / 5))

now=$(date +"%a %d %b %H:%M:%S")
now_len=21
here=$1
here_len=${#here}
here_base=$(basename $here)
here_base_len=${#here_base}
here_slashes=$(echo $here | tr -d -c '/')
here_slashes_len=${#here_slashes}
here_min_len=$(( $here_base_len + 2 * $here_slashes_len - 1 )) # minus 1 as last slash has no ...
mascot="(づ｡◕‿‿◕｡)づ"
mascot_len=12

max_len=$(($MAXLEN - $now_len - $mascot_len))

while [ $here_len -gt $max_len ]
do
    here=$(echo $here | sed 's#[^/…][^/]*/#…/#')
    here_len=${#here}
    if [ $here_len -eq $here_min_len ]
    then
        mascot=""
        break
    fi
done

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

bat=$(pmset -g batt | grep -o "[0-9]\{1,3\}%")
bat=${bat%?}
bat=$(( $bat / 12 ))

echo "${mascot}#[bg=black,fg=green] ${here} #[fg=black,bg=white] ${now} #[fg=red,bg=black]${bars[$cpu]}#[fg=orange,bg=black]${bars[$bat]}"

