#!/bin/bash

status="$(playerctl status 2>&1)"
case "$status" in
    Paused) status_sym='';;
    Playing) status_sym='';;
    *) exit 0;;
esac
title="$(playerctl metadata | grep xesam:title | sed -e 's/^.*title\s*//')"
[ ${#title} -gt 28 ] && title="$(cut -c 1-25 <<< $title)..."
echo -n "$status_sym $title | "
