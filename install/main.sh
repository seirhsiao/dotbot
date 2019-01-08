#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "init/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

"./$(get_os)/main.sh"

./oh-my-zsh.sh
./npm.sh
./vim.sh
./pip.sh

