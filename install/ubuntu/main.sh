#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../setup.conf" \
    && . "../init/utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n • Execute ubuntu commands\n\n"
execute_commands "${UBUNTU_COMMANDS[@]}"


print_in_purple "\n • APT-GET\n\n"
update
upgrade
install_all_packages ${APT_GET_PACKAGES[@]}
autoremove
