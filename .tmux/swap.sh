#!/usr/bin/env bash

src=$1
tgt=$2

ord() {
  printf '%d' "'$1"
}
convert () {
    ret=$1
    if [[ ! $ret =~ [0-9] ]]; then
        ret=$(ord $ret)
        a=$(ord 'a')
        ret=$(( ( $ret - $a ) + 10 ))
        if [ $ret -lt 0 ]; then
            exit 255
        fi
    fi
    echo $ret
}

src=$(convert $src)
tgt=$(convert $tgt)

tmux swap-pane -s $src -t $tgt

