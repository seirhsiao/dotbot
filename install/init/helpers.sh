#!/bin/bash

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask() {
    print_question "$1"
    read -r
}

confirm() {
    print_question "$1 (y/n) "
    read -r -n 1
    printf "\n"
}

ask_for_sudo() {
    sudo -v &> /dev/null

    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
}

cmd_exists() {
    command -v "$1" &> /dev/null
}

kill_all_subprocesses() {
    local i=""

    for i in $(jobs -p); do
        kill "$i"
        wait "$i" &> /dev/null
    done
}

set_trap() {
    trap -p "$1" | grep "$2" &> /dev/null \
        || trap '$2' "$1"
}

skip_questions() {
    while :; do
        case $1 in
            -y|--yes) return 0;;
            *) break;;
        esac
        shift 1
    done

    return 1
}

show_spinner() {
    local -r FRAMES='\|/-'
    # shellcheck disable=SC2034
    local -r NUMBER_OR_FRAMES=${#FRAMES}
    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"
    local i=0
    local frameText=""

    # travisCI special treatment
    # https://unix.stackexchange.com/a/278888
    if [ "$TRAVIS" != "true" ]; then
        printf "\n\n\n"
        tput cuu 3
        tput sc
    fi

    # display spinner while commands are being executed
    while kill -0 "$PID" &>/dev/null; do
        frameText="${FRAMES:i++%NUMBER_OR_FRAMES:1} $MSG"

        if [ "$TRAVIS" != "true" ]; then
            printf "%s\n" "$frameText"
        else
            printf "%s" "$frameText"
        fi

        sleep 0.2

        if [ "$TRAVIS" != "true" ]; then
            tput rc
        else
            printf "\r"
        fi
    done
}

execute() {
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
    local exitCode=0
    local cmdsPID=""

    set_trap "EXIT" "kill_all_subprocesses"

    # execute commands in background
    eval "$CMDS" \
        &> /dev/null \
        2> "$TMP_FILE" &

    cmdsPID=$!

    # show a spinner if command will
    # take a long time
    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # wait for commands to finish executing
    # then get exit code
    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    # if there's a segfault
    # print a backtrace
    if [[ $exitCode -eq 139 ]]; then
        gdb -q $1 core -x "$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    return $exitCode
}

get_answer() {
    printf "%s" "$REPLY"
}

get_os() {
    local os=""
    local kernelName=""

    kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
        os="ubuntu"
    else
        os="$kernelName"
    fi

    printf="%s" "$os"
}

get_os_version() {
    local os=""
    local version=""

    os="$(get_os)"

    if [ "$os" == "macos" ]; then
        version="$(sw_vers -productVersion)"
    elif [ "$os" == "ubuntu" ]; then
        version="$(lsb_release -d | cut -f2 | cut -d' ' -f2)"
    fi

    printf "%s" "$version"
}

is_supported_version() {
    declare -a v1=(${1//./ })
    declare -a v2=(${2//./ })
    local i=""

    for (( i=0; i<${#v1[@]}; i++ )); do
        if [[ -z ${v2[i]} ]]; then
            v2[i]=0
        fi
        if (( 10#${v1[i]} < 10#${v2[i]} )); then
            return 1
        elif (( 10#${v1[i]} > 10#${v2[i]} )); then
            return 0
        fi
    done
}

is_git_repo() {
    git rev-parse &> /dev/null
}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

print_in_green() {
    print_in_color "$1" 2
}

print_in_purple() {
    print_in_color "$1" 5
}

print_in_red() {
    print_in_color "$1" 1
}

print_in_yellow() {
    print_in_color "$1" 3
}

print_in_cyan() {
    print_in_color "$1" 4
}

print_question() {
    print_in_yellow "💬  $1"
}

print_result() {
    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"
}

print_success() {
    print_in_green "✔  $1\n"
}

print_warning() {
    print_in_yellow "⚠  $1\n"
}

print_done() {
    print_in_purple "✨  Done!\n"
}

print_header() {
    print_in_cyan "$1\n"
}

print_error() {
    print_in_red "🚫  $1 $2\n"
}

print_error_stream() {
    while read -r line; do
        print_error "↳ ERROR: $line"
    done
}