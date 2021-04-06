#!/bin/bash
#
# License: MIT
#
# A script to easily pick a color on a wayland session by using:
# slurp to select the location, grim to get the pixel, convert
# to make the pixel a hex number and zenity to display a nice color
# selector dialog where the picked color can be tweaked further.
#
# The script was possible thanks to the useful information on:
# https://www.trst.co/simple-colour-picker-in-sway-wayland.html
# https://unix.stackexchange.com/questions/320070/is-there-a-colour-picker-that-works-with-wayland-or-xwayland/523805#523805
#

# Check if running under wayland.
if [ "$WAYLAND_DISPLAY" = "" ]; then
    zenity  --error --width 400 \
        --title "No wayland session found." \
        --text "This color picker must be run under a valid wayland session."
    exit 1
fi

# Get color position
position=$(slurp -b 00000000 -p)

# Checking if position if assigned (used for user cancellation)
if [[ "$position" = "" ]]; then
    exit 1
fi
echo $position

# Reduced sleep for faster results
sleep 0.2 # If result is wrong color, increase to 1

# Store the hex color value using graphicsmagick or imagemagick.
#if command -v /usr/bin/gm &> /dev/null; then
    #color=$(grim -g "$position" -t png - \
        #| /usr/bin/gm convert - -format '%[pixel:p{0,0}]' txt:- \
        #| tail -n 1 \
        #| rev \
        #| cut -d ' ' -f 1 \
        #| rev
    #)
#else
color=$(grim -g "$position" -t png - \
    | convert - -format '%[pixel:p{0,0}]' txt:- \
    | tail -n 1 \
    | cut -d ' ' -f 4
)

echo $color
# fi

perl -e 'foreach $a(@ARGV){print "\e[48;2;".join(";",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@"

# Display a color picker and store the returned rgb color
rgb_color=$(zenity --color-selection \
    --title="Copy color to Clipboard" \
    --color="${color}"
)

# Execute if user didn't click cancel
if [ "$rgb_color" != "" ]; then
    # Convert rgb color to hex
    hex_color="#"
    for value in $(echo "${rgb_color}" | grep -E -o -m1 '[0-9]+'); do
        hex_color="$hex_color$(printf "%.2x" $value)"
    done

    # Copy user selection to clipboard
    echo $hex_color | wl-copy
fi
