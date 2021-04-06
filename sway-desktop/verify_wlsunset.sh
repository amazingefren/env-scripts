#!/bin/bash

if [ "$1" == "-s" ]; then
    if ! [ $(pgrep -x "wlsunset") ]; then 
        wlsunset &>/dev/null
    fi
elif [ "$1" == "-t" ]; then
    if [ $(pgrep -x "wlsunset") ]; then
        killall wlsunset
    else
        wlsunset &>/dev/null
    fi
fi

