#!/usr/bin/bash


    n=5000
    shift
    while [ $(( n -= 1 )) -ge 0 ]
    do
        { time curl https://yapzap.me/tags >/dev/null; } 2>&1 | grep real | awk -F 'real\t' '{print $2}'
    done

