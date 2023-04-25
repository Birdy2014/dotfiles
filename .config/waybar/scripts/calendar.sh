#!/usr/bin/env bash

command -v gcalendar &> /dev/null || exit 1
command -v jq &> /dev/null || exit 1

calendar="$(gcalendar --list-calendars | grep '@')"
event_json="$(gcalendar --calendar "$calendar" --no-of-days=1 --output=json)"

[[ "$event_json" == *'summary'* ]] || exit 1

summary=$(echo $event_json | jq -r '.[0].summary')
start_time=$(echo $event_json | jq -r '.[0].start_time')
start_date=$(echo $event_json | jq -r '.[0].start_date')
location=$(echo $event_json | jq -r '.[0].location')

if [[ "$start_date" = "$(date --iso-8601)" ]]; then
    day="Heute"
else
    day="Morgen"
fi

full_text="$day $start_time - $summary"
[[ ${#full_text} -gt 28 ]] && short_text="$(cut -c 1-25 <<< $full_text)..." || short_text="$full_text"
if [[ ! -z "$location" ]]; then
    tooltip="$start_date $start_time - $summary - $location"
else
    tooltip="$start_date $start_time - $summary"
fi
printf '%s\n%s' "$short_text" "$tooltip"
