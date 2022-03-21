#!/usr/bin/env bash

command -v gcalendar &> /dev/null || exit 1
command -v json_reformat &> /dev/null || exit 1

calendar="$(gcalendar --list-calendars | grep '@')"
event_json="$(gcalendar --calendar "$calendar" --no-of-days=1 --output=json | json_reformat)"

[[ "$event_json" == *'summary'* ]] || exit 1

IFS=
event_kindajson="$(sed 's/[",]//g' <<< $event_json)"

summary=$(echo $event_kindajson | grep -m1 summary | sed 's/^ *summary: \(.*\S\) *$/\1/')
start_time=$(echo $event_kindajson | grep -m1 start_time | sed 's/^ *start_time: \(.*\S\) *$/\1/')

full_text="$start_time - $summary"
[ ${#full_text} -gt 28 ] && short_text="$(cut -c 1-25 <<< $full_text)..." || short_text="$full_text"
echo -n -e "$short_text\n$full_text"
