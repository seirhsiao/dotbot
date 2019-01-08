#!/bin/bash

# source utils
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helpers.sh"

initialize_git_repo() {
    declare -r GIT_ORIGIN="$1"

    if [ -z "$GIT_ORIGIN" ]; then
        print_error "Provide a URL for the git origin"
        exit 1
    fi

    if ! is_git_repo; then
        cd ../../ \
            || print_error "Failed to cd `../../`"

        execute \
            "git init && git remote add origin $GIT_ORIGIN" \
            "Initialize the git repo"
    fi
}

main() {
    print_header "🏎  Initializing the git repo..."
    initialize_git_repo "$1"
    print_done
}
main "$1"