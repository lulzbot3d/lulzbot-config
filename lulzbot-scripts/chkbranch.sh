#!/usr/bin/bash

printf "%-35s %s\n" "Directory" "Branch"
printf "%-35s %s\n" "---------" "------"

for d in */; do
    if git -C "$d" rev-parse --is-inside-work-tree &>/dev/null; then
        branch=$(git -C "$d" rev-parse --abbrev-ref HEAD 2>/dev/null)
        printf "%-35s %s\n" "${d%/}" "$branch"
    fi
done
