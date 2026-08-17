#!/usr/bin/env bash
set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
if find "$project_root" -path "$project_root/.git" -prune -o \
    -path "$project_root/build" -prune -o -type f \
    \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.cxx' -o \
       -name '*.h' -o -name '*.hpp' -o -name '*.rs' \) -print -quit |
    rg -q '.'; then
    printf '%s\n' 'foreign implementation source found' >&2
    exit 1
fi
if rg -n -i 'glfw|sdl' "$project_root" \
    --glob '!README.md' --glob '!tools/check-abla-only.sh' \
    --glob '!.git/**' --glob '!build/**'; then
    printf '%s\n' 'forbidden windowing dependency found' >&2
    exit 1
fi
printf '%s\n' 'Abla-only source audit passed'
