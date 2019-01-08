#!/bin/bash

# source utils
cd "$(dirname "$0")" \
    && . "../init/utils.sh"

declare -a fontsArr=(
    "font-hack"
    "font-anonymous-pro"
    "font-nexa"
    "font-nunito"
    "font-source-code-pro"
)

# fonts
install_fonts() {
    echo "📰  Installing fonts..."
    for i in "${fontsArr[@]}"
    do
        brew cask install "$i" > /dev/null
        print_success "$i"
    done
    sleep .5
    print_done
}

install_fonts