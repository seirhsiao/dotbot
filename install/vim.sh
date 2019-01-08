#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "init/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_plugins() {

    declare -r VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
    declare -r VUNDLE_GIT_REPO_URL="https://github.com/VundleVim/Vundle.vim.git"

    declare -r PATHOGEN_DIR="$HOME/.vim/autoload/pathogen.vim"
    declare -r PATHOGEN_GIT_REPO_URL="https://tpo.pe/pathogen.vim"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install plugins.

    if [ ! -d "$VUNDLE_DIR" ]; then

        execute \
            "git clone --quiet '$VUNDLE_GIT_REPO_URL' '$VUNDLE_DIR' \
                && printf '\n' | vim +PluginInstall +qall" \
            "Install Vundle and Plugins" \
            || return 1

    fi

    if [ ! -f "$PATHOGEN_DIR" ]; then
        execute \
            "curl -LSso '$PATHOGEN_DIR' '$PATHOGEN_GIT_REPO_URL'" \
            "Install Pathogen" \
             || return 1

    fi

}

update_plugins() {

    execute \
        "vim +PluginUpdate +qall" \
        "Update plugins"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Vim\n\n"

    printf "\n"

    install_plugins
    # update_plugins

}

main
