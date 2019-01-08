#!/bin/bash

# source utils
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helpers.sh"

create_symlinks() {
    declare -a FILES_TO_SYMLINK=(
        "git/aliases.zsh"
        "git/functions.zsh"

        "shell/aliases/core"
        "shell/aliases/npm"
        "shell/aliases/utils"
        "shell/aliases/yarn"
        "shell/.aliases"
        "shell/.bash_profile"
        "shell/.bash_prompt"
        "shell/.bashrc"
        "shell/.exports"
        "shell/.functions"

        "tmux/tmux.conf"

        "vim/.vimrc"
        "vim/setup.sh"
    )

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=false

    skip_questions "$@" \
        && skipQuestions=true

    for i in "${FILES_TO_SYMLINK[@]}"; do
        sourceFile="$(cd .. && pwd)/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ ! -e "$targetFile" ] || $skipQuestions; then
            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"
        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else
            if ! $skipQuestions; then
                confirm "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then
                    rm -rf "$targetFile"
                    execute \
                        "ln -fs $sourceFile $targetFile" \
                        "$targetFile → $sourceFile"
                else
                    print_error "$targetFile → $sourceFile"
                fi
            fi
        fi
    done
}

main() {
    print_header "🔗  Creating symbolic links..."
    create_symlinks "$@"
}

main "$@"