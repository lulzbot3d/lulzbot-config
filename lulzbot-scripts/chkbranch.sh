#!/usr/bin/bash

# Color codes for terminal output
GREEN=$(tput setaf 2 2>/dev/null || echo -e '\033[32m')
RESET=$(tput sgr0 2>/dev/null || echo -e '\033[0m')
RED=$(tput setaf 1 2>/dev/null || echo -e '\033[31m')

printf "%-35s %-20s %s\n" "Directory" "Branch" "Organization"
printf "%-35s %-20s %s\n" "---------" "------" "------------"

for d in */; do
    if git -C "$d" rev-parse --is-inside-work-tree &>/dev/null; then
        branch=$(git -C "$d" rev-parse --abbrev-ref HEAD 2>/dev/null)
        org=$(git -C "$d" remote get-url origin | cut -d'/' -f4 2>/dev/null)

        # Color organization green if it's lulzbot3d
        if [ "$org" = "lulzbot3d" ]; then
            org_display="${GREEN}${org}${RESET}"
        else
            org_display="${org}"
        fi

        # Print with plain values for alignment
        printf "%-35s " "${d%/}"

        # Print branch with color if needed
        if [[ "$branch" != *"master"* && "$branch" != *"main"* ]]; then
            printf "${RED}%-20s${RESET} " "$branch"
        else
            printf "%-20s " "$branch"
        fi

        # Print organization
        printf "%s\n" "$org_display"
    fi
done
