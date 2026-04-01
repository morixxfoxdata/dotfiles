#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
session_name=$(echo "$input" | jq -r '.session_name // empty')
username=$(whoami)
current_time=$(date +%R)

# Get directory with home replacement
get_directory() {
    local dir="$1"
    local home="$HOME"

    # Replace home with ~
    if [[ "$dir" == "$home"* ]]; then
        dir="~${dir#$home}"
    fi

    # Apply substitutions from Starship config
    dir="${dir//\/Documents\//\/󰈙 \/}"
    dir="${dir//\/Downloads\//\/ \/}"
    dir="${dir//\/Music\//\/ \/}"
    dir="${dir//\/Pictures\//\/ \/}"

    echo "$dir"
}

# Get git info if in a git repo
get_git_info() {
    if command -v git &> /dev/null && git -C "$1" rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git -C "$1" -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null || git -C "$1" -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null)

        # Get git status
        local status=""
        if ! git -C "$1" -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false diff --quiet 2>/dev/null; then
            status+="!"
        fi
        if [ -n "$(git -C "$1" -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false ls-files --others --exclude-standard 2>/dev/null)" ]; then
            status+="?"
        fi

        if [ -n "$branch" ]; then
            printf " [%s %s]" "$branch" "$status"
        fi
    fi
}

# Build the status line
directory=$(get_directory "$cwd")
git_info=$(get_git_info "$cwd")

# Main prompt with colors (using printf for ANSI colors)
printf "\033[38;2;46;52;64;48;2;136;192;208m %s \033[0m" "$directory"

# Git info if available
if [ -n "$git_info" ]; then
    printf "\033[38;2;118;159;240m%s\033[0m" "$git_info"
fi

# Right side info
printf " | \033[1muser: %s\033[0m ✨ \033[38;2;160;169;203m  %s\033[0m" "$username" "$current_time"

# Add session name if set
if [ -n "$session_name" ]; then
    printf " | %s" "$session_name"
fi
