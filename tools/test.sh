#!/usr/bin/env bash
set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
set +e
xvfb-run -a -s "-screen 0 320x200x24 -noreset" \
    "$project_root/build/abla-doom" test
status=$?
set -e
if [[ $status -ne 42 ]]; then
    printf 'abla-doom test returned %s, expected 42\n' "$status" >&2
    exit 1
fi
printf '%s\n' 'abla-doom rendered and presented its procedural scene'
