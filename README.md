![dotfiles banner](banner.png)

```
dotfiles/
├── .vim        > vim config w/ plugins
├── bin         > system automation scripts
├── brew        > homebrew configuration
├── git         > global git config, aliases, and functions
├── init        > scripts for running this dotfile dir
├── macos       > macos prefs
├── node        > global npm packages
├── shell       > aliases, functions, exports
├── tmux        > terminal multiplexer config
├── vim         > vim setup scripts
└── zsh         > zsh settings and prompts
```

**☠ abandon all hope ye who enter here (in active development)**

# usage

`setup.sh` will kick everything off for you, but i wouldn't recommend using it unless you know absolutely everything that's going on in there.

Once `setup.sh` is run and a restart has occurred, if you want `zsh` you have to change to it and source the config file

```bash
chsh -s $(which zsh)
source ~/dotfiles/zsh/.zshrc
```


### MacOS

```
# 1. Install XCode
sudo softwareupdate -i -a
xcode-select --install

# 2. Install

bash -c "$(curl -LsS https://raw.githubusercontent.com/coderzh/dotfiles/master/setup.sh)"

```

### Ubuntu

```
bash -c "$(wget -qO - https://raw.githubusercontent.com/coderzh/dotfiles/master/setup.sh)"
```

### Config

See: [setup.conf](https://github.com/seirhisao/dotfiles/blob/master/setup.conf)

