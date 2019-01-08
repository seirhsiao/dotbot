#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "init/utils.sh" \
    && . "../setup.conf"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Pip\n\n"

    for i in "${PIP_PACKAGES[@]}"; do
        execute \
            "sudo -H pip install $i" \
            "install $i"
    done

}

main


