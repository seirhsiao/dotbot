#!/bin/bash

# source
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helpers.sh"

main() {
    print_warning "Restart required"
    sleep .5
    confirm "Do you want to restart?"
    printf "\n"

    if answer_is_yes; then
        sudo shutdown -r now &> /dev/null
    fi
}

main