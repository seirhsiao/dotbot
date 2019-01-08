#!/bin/bash

# source utils
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helpers.sh"

add_ssh_configs() {
    printf "%s\n" \
        "Host github.com" \
        "   IdentifyFile $1" \
        "   LogLevel ERROR" >> ~/.ssh/config

    print_result $? "Add SSH configs"
}

copyssh() {
  if pbcopy < ~/.ssh/id_rsa.pub ; then
    echo '🔑  → 📋  ssh key copied to clipboard!'
  else
    echo '😩  something went wrong!'
  fi
}

generate_ssh() {
    ask "Enter your email: " && printf "\n"
    ssh-keygen -t rsa -b 4096 -C "$(get_answer)" -f "$1"

    print_result $? "Generate SSH keys"
}

open_github_ssh_page() {
    declare -r GITHUB_SSH_URL="https://github.com/settings/ssh"

    if cmd_exists "xdg-open"; then
        xdg-open "$GITHUB_SSH_URL"
    elif cmd_exists "open"; then
        open "$GITHUB_SSH_URL"
    else
        print_warning "Couldn't automatically add your ssh key to github. Open ($GITHUB_URL) to add it manually."
}

set_ssh_key() {
    local sshKeyFileName="$HOME/.ssh/github"

    if [ -f "$sshKeyFileName" ]; then
        sshKeyFileName="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
    fi

    generate_ssh_keys "$sshKeyFileName"
    add_ssh_configs "$sshKeyFileName"
    copyssh
    open_github_ssh_page
    test_ssh_connection \
        && rm "${sshKeyFileName}.pub"
}

test_ssh_connection() {
    while true; do
        ssh -T git@github.com &> /dev/null
        [ $? -eq 1 ] && break
        sleep 5
    done
}

main() {
    print_header "🔑  Set Github SSH keys"
    if ! is_git_repo; then
        print_error "Not a git repo"
        exit 1
    fi

    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        set_ssh_key
    fi

    print_result $? "Set Github SSH keys"
}

main