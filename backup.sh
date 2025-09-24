#!/usr/bin/env bash

set -euo pipefail

abort() {
    echo "ERROR: $*" >&2
    exit 1
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

    if ! sudo rsync \
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
        "$DESTINATION"; then
        abort "Backup failed for '$SOURCE' → '$DESTINATION'"
    fi
}

backup "/private/etc" "/Volumes/4TB SSD/backup/area17-m1-macbook-pro/private/etc"

backup "/opt/homebrew" "/Volumes/4TB SSD/backup/area17-m1-macbook-pro/opt/homebrew"

backup "/Users/antonioribeiro/" "/Volumes/4TB SSD/backup/area17-m1-macbook-pro/Users/antonioribeiro/"


