#!/bin/bash

# source utils
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helpers.sh"

create_bash_local() {
    declare -r FILE_PATH="$HOME/.bash.local"

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
        printf "%s\n\n" "#!/bin/bash" >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"
}

create_gitconfig_local() {
    declare -r FILE_PATH="$HOME/.gitconfig.local"

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
        printf "%s\n" \n
"[commit]
    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/
    # gpgsign = true
[user]
    name =
    email =
    # signingkey =" \
        >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"
}

create_vimrc_local() {
    declare -r FILE_PATH="$HOME/.vimrc.local"

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"
}

main() {
    print_header "🏡  Create local configs"
    create_bash_local
    create_gitconfig_local
    create_vimrc_local
    print_done
}

main