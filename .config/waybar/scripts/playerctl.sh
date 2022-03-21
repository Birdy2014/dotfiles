#!/usr/bin/env bash

command -v playerctl &> /dev/null || exit 1

status="$(playerctl status 2>&1)"
case "$status" in
    Paused) status_sym='';;
    Playing) status_sym='';;
    *) exit 0;;
esac

full_title="$(playerctl metadata | grep xesam:title | sed -e 's/^.*title\s*//' | sed 's/&/&amp;/g')"
[ ${#full_title} -gt 28 ] && short_title="$(cut -c 1-25 <<< $full_title)..." || short_title="$full_title"
echo -n -e "$status_sym $short_title\n$full_title"
