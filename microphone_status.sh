#!/bin/zsh

MICROPHONE_STATUS=`amixer -D pulse sget Capture | egrep -o '\[o.+\]' | head -1`
ACTIVE_COLOR() {
	# swaymsg client.focused '#000000 #504945 #FBF1C7'
    swaymsg bar secondary colors "background #282828"
}
MUTED_COLOR(){
	# swaymsg client.focused '#000000 #9D0006 #FBF1C7'
    swaymsg bar secondary colors "background #9D0006"
}
if [[ $MICROPHONE_STATUS == '[on]' ]]; then
	if [ "$1" != "" ]; then
		amixer -D pulse sset Capture toggle;
		MUTED_COLOR
	else
		ACTIVE_COLOR
	fi
elif [[ $MICROPHONE_STATUS == '[off]' ]]; then
	if [ "$1" != "" ]; then
		amixer -D pulse sset Capture toggle;
		ACTIVE_COLOR
	else
		MUTED_COLOR
	fi
fi

