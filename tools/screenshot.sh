#!/usr/bin/env bash
set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
output="$project_root/screenshots/abla-doom.png"
mkdir -p "$project_root/screenshots"

xvfb-run -a -s "-screen 0 320x200x24 -noreset" sh -c '
    app=$1
    output=$2
    "$app" screenshot &
    app_pid=$!
    attempt=0
    while [ "$attempt" -lt 40 ]; do
        if xwininfo -root -tree 2>/dev/null | rg -q "ABLA DOOM"; then
            break
        fi
        sleep 0.05
        attempt=$((attempt + 1))
    done
    magick import -window root "$output"
    wait "$app_pid"
' sh "$project_root/build/abla-doom" "$output"

dimensions=$(magick identify -format '%wx%h' "$output")
if [[ $dimensions != 320x200 ]]; then
    printf 'screenshot dimensions are %s, expected 320x200\n' \
        "$dimensions" >&2
    exit 1
fi
printf 'captured %s (%s)\n' "$output" "$dimensions"
