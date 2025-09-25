#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${LOG_DIR:-$SCRIPT_DIR/logs}"

echo "Log directory: $LOG_DIR"
echo "Script directory: $SCRIPT_DIR"

abort() {
    echo "ERROR: $*" >&2
    exit 1
}

sanitize_path() {
    local path=$1
    path=${path%/}
    path=${path#/}
    [[ -z $path ]] && path="root"
    path=${path//\//_}
    path=${path//[[:space:]]/_}
    echo "$path"
}

backup() {
    if [[ $# -ne 2 ]]; then
        abort "Usage: backup <source> <destination>"
    fi

    local SOURCE=$1
    local DESTINATION=$2

    if ! mkdir -p "$DESTINATION"; then
        abort "Failed to create destination directory: $DESTINATION"
    fi

    if [[ ! -d "$DESTINATION" ]]; then
        abort "Destination directory does not exist after creation: $DESTINATION"
    fi

    if ! mkdir -p "$LOG_DIR"; then
        abort "Failed to create log directory: $LOG_DIR"
    fi

    local dest_key
    dest_key=$(sanitize_path "$DESTINATION")
    local timestamp
    timestamp=$(date '+%Y%m%d-%H%M%S')
    local log_file="$LOG_DIR/${dest_key}_${timestamp}.log"

    echo "Backing up '$SOURCE' → '$DESTINATION' (logging to $log_file)"

    sudo rsync \
        --progress                             \
        --verbose                              \
        --archive                              \
        --compress                             \
        --human-readable                       \
        --exclude=.cache                       \
        --exclude=.composer/vendor             \
        --exclude=.conda                       \
        --exclude=.codeium                     \
        --exclude=.cursor                      \
        --exclude=.npm                         \
        --exclude=.nvm                         \
        --exclude=.ollama                      \
        --exclude=.pyenv                       \
        --exclude=.vscode                      \
        --exclude=.orbstack                    \
        --exclude=antonio-ribeiro-macbookpro   \
        --exclude=Applications                 \
        --exclude="Creative Cloud Files"       \
        --exclude=curl-timings.txt             \
        --exclude=Desktop                      \
        --exclude=Downloads                    \
        --exclude=go                           \
        --exclude='Library/Caches/'            \
        --exclude='Library/Logs/'              \
        --exclude='Library/Saved Application State/' \
        --exclude='Library/Application Support/CrashReporter/' \
        --exclude=Movies                       \
        --exclude=Music                        \
        --exclude=node_modules                 \
        --exclude=OrbStack                     \
        --exclude=Pictures                     \
        --exclude=Postman                      \
        --exclude=Public                       \
        --exclude=Screenshots                  \
        --exclude=torrents                     \
        --exclude=Trash                        \
        --exclude=.Trash                       \
        --exclude=videos                       \
        "$SOURCE"                             \
        "$DESTINATION" 2>&1 | tee "$log_file"
    
}

backup "/private/etc" "/Volumes/4TB SSD/backup/area17-m1-macbook-pro/private/etc"

backup "/opt/homebrew" "/Volumes/4TB SSD/backup/area17-m1-macbook-pro/opt/homebrew"

backup "/Users/antonioribeiro/" "/Volumes/4TB SSD/backup/area17-m1-macbook-pro/Users/antonioribeiro/"
