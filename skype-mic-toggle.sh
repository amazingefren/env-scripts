#!/bin/zsh
LANGUAGE="en_US"

app_name="Google Chrome input"

current_sink_num=''
sink_num_check=''
app_name_check=''

muted=''

toggle_bar(){
    #echo "$muted"
    if [[ "$1" = "-p" ]]; then
        if [[ "$muted" = "yes" ]]; then
            swaymsg bar secondary colors "background #458588"
        else
            swaymsg bar secondary colors "background #282828"
        fi
    else 
        if [[ "$muted" = "no" ]]; then
            swaymsg bar secondary colors "background #458588"
        else
            swaymsg bar secondary colors "background #282828"
        fi 
    fi

}

pactl list source-outputs |while read line; do \
    sink_num_check=$(echo "$line" |sed -rn 's/^Source Output #(.*)/\1/p')
    if [ "$sink_num_check" != "" ]; then
        current_sink_num="$sink_num_check"
        muted=''
    else
        if [[ "$muted" = "" ]]; then
            muted=$(echo "$line" |sed -rn 's/^Mute: (yes|no)/\1/p')
        fi
        # echo "---------------------------"
        # echo "hmm: $muted"
        app_name_check=$(echo "$line" \
            |sed -rn 's/application.name = "([^"]*)"/\1/p')
        if [ "$app_name_check" = "$app_name" ]; then
            if [[ "$1" != "-p" ]]; then
                pactl set-source-output-mute "$current_sink_num" toggle
            fi
            if [ "$muted" = "no" ]; then
                # MUTED IS YES NOW BECAUSE OF PACTL
                # SO NOW IT IS BLUE
                #swaymsg bar secondary colors "background #458588"
                toggle_bar "$1"
            else
                #swaymsg bar secondary colors "background #282828"
                toggle_bar "$1"
            fi
            exit 0
        fi
    fi
done
