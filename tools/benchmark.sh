#!/usr/bin/env bash
set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
frames=300

for backend in opengl vulkan; do
    elapsed_ns=$(xvfb-run -a -s "-screen 0 320x200x24 -noreset" sh -c '
        app=$1
        mode=$2
        start=$(date +%s%N)
        "$app" "$mode" >&2
        end=$(date +%s%N)
        printf "%s\n" "$((end - start))"
    ' sh "$project_root/build/abla-doom" "benchmark-$backend")

    frames_per_second=$(awk -v frames="$frames" -v elapsed="$elapsed_ns" \
        'BEGIN { printf "%.1f", frames * 1000000000 / elapsed }')
    elapsed_seconds=$(awk -v elapsed="$elapsed_ns" \
        'BEGIN { printf "%.3f", elapsed / 1000000000 }')
    printf '%-6s %s frames in %ss: %s fps\n' \
        "$backend" "$frames" "$elapsed_seconds" "$frames_per_second"
done
