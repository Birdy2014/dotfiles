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
start_date=$(echo $event_kindajson | grep -m1 start_date | sed 's/^ *start_date: \(.*\S\) *$/\1/')
location=$(echo $event_kindajson | grep -m1 location | grep -E 'location: \S+' | sed 's/^ *location: \(.*\S\) *$/\1/')

if [ "$start_date" = "$(date --iso-8601)" ]; then
    day="Heute"
else
    day="Morgen"
fi

full_text="$day $start_time - $summary"
[ ${#full_text} -gt 28 ] && short_text="$(cut -c 1-25 <<< $full_text)..." || short_text="$full_text"
if [ ! -z "$location" ]; then
    tooltip="$start_date $start_time - $summary - $location"
else
    tooltip="$start_date $start_time - $summary"
fi
echo -n -e "$short_text\n$tooltip"
