#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "init/utils.sh" \
    && . "../setup.conf"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_npm_packages() {

    for i in "$@"; do
        execute \
            "sudo npm install --global --silent $i" \
            "install $i"
    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • NPM\n\n"

    execute \
        "npm config set registry https://registry.npm.taobao.org" \
        "set taobao npm source"

    install_npm_packages ${NPM_PACKAGES[@]}

}

main
