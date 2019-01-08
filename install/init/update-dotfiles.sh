#!/bin/bash

# source utils
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helpers.sh"

main() {
    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        ./set-ssh.sh \
            || return 1
    fi

    confirm "Do you want to update your dotfiles?"

    if answer_is_yes; then
        git fetch --all 1> /dev/null \
            && git reset --hard origin/master 1> /dev/null \
            && git clean -fd 1> /dev/null
        print_result $? "Update dotfiles"
    fi
}

main