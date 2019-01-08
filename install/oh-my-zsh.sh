#/!bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "init/utils.sh"

main() {

    print_in_purple "\n • Oh-My-Zsh\n\n"

    execute \
        "sudo chsh -s $(which zsh)" \
        "Set zsh as default"

    if [ ! -d $HOME/.oh-my-zsh ]; then

        execute \
            "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\"" \
            "Install oh-my-zsh"

    fi
    chsh -s /bin/zsh
    ##chsh -s $(which zsh)
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

}


main
