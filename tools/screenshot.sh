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
    window_id=
    while [ "$attempt" -lt 40 ]; do
        window_id=$(xwininfo -root -tree 2>/dev/null | sed -n \
            '\''s/^[[:space:]]*\(0x[0-9a-fA-F]*\) "ABLA DOOM".*/\1/p'\'' | \
            head -n 1)
        if [ -n "$window_id" ]; then
            break
        fi
        sleep 0.05
        attempt=$((attempt + 1))
    done
    if [ -z "$window_id" ]; then
        printf "%s\n" "could not find the ABLA DOOM window" >&2
        kill "$app_pid" 2>/dev/null || true
        wait "$app_pid" 2>/dev/null || true
        exit 1
    fi
    # Window creation precedes the first graphics presentation. Give the
    # paced screenshot mode several frames to render before reading pixels.
    sleep 0.3
    magick import -window "$window_id" "$output"
    wait "$app_pid"
' sh "$project_root/build/abla-doom" "$output"

dimensions=$(magick identify -format '%wx%h' "$output")
if [[ $dimensions != 320x200 ]]; then
    printf 'screenshot dimensions are %s, expected 320x200\n' \
        "$dimensions" >&2
    exit 1
fi
printf 'captured %s (%s)\n' "$output" "$dimensions"
