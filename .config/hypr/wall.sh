#!/usr/bin/bash
TEMP=/tmp/current_wall

files=(~/.config/hypr/wallpapers/*)

scripts=~/.scripts

cooldown=1

change () {
    index=$(cat $TEMP)
    index=$((index+$1))
    if [ $index -ge ${#files[@]} ]; then
        index=0
    fi
    echo $index > $TEMP
    swww img "${files[$index]}" --transition-fps 60 --transition-type grow --transition-pos 0.925,0.977 --transition-duration 2
    exit 0
}

while true
do
    case "$1" in
        "cycle")
            change 1
            ;;
        "cycler")
            change -1
            ;;
    esac
    sleep $cooldown
done