#!/bin/bash

# source utils
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helpers.sh"

create_dirs() {
    declare -a DIRS=(
        "$HOME/Downloads/torrents"
        "$HOME/Desktop/screenshots"
    )

    for i in "${DIRS[@]}"; do
        mkd "$i"
    done
}

main() {
    print_header "🗄  Creating directories..."
    create_dirs
    print_done
}

main