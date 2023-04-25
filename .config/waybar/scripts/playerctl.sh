#!/usr/bin/env bash

set -o pipefail

command -v playerctl &> /dev/null || exit 1

status="$(playerctl-current status 2>&1)"
case "$status" in
    Paused) status_sym='';;
    Playing) status_sym='';;
    *) echo '' && exit 0;;
esac

full_title="$(playerctl-current metadata xesam:title 2>/dev/null)"
[[ "$?" -ne 0 ]] && echo '' && exit 0
[ ${#full_title} -gt 28 ] && short_title="$(colrm 25 <<< $full_title)..." || short_title="$full_title"
echo -n -e "$status_sym $short_title\n$full_title"
