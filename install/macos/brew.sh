#!/usr/bin/env bash

set -e

# Install command-line tools using Homebrew.

## if install failed, need set mirror
# cd "$(brew --repo)"
# git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
# cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
# git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
# cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask"
# git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
# brew update
# echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Taps,指定相应的brew的源
brew tap 'caskroom/cask'
brew tap 'caskroom/fonts'
brew tap 'caskroom/versions'
brew tap 'homebrew/bundle'
brew tap 'homebrew/dupes'
brew tap 'homebrew/php'
brew tap 'homebrew/science'

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)


ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install packages
apps=(
    caskroom/cask/brew-cask
##  Install GNU core utilities (those that come with macOS are outdated).
##  Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
    coreutils
    cmake
##  Install some other useful utilities like `sponge`.
    moreutils
    # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
##  Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
    findutils
##  Install Bash 4.
    bash
    bash-completion2
    zsh
    zsh-completions
    openssh
    openssl
    ctags
    curl
    vim --with-override-system-vi
## Install more recent versions of some OS X tools
    homebrew/dupes/grep
##  Install GnuPG to enable PGP-signing commits.
    #gnupg
    #gmp
    #screen
## Install GNU `sed`, overwriting the built-in `sed`.
    gnu-sed --with-default-names
## Install Binaries
#   awscli
    git
    ant
    markdown
    maven
    node
#   android-sdk
#   go
#   hugo
#   mercurial
#   mysql
#   python
#   python3
#   php
#   ruby
#   svn
#   vim
#   trash
#   mackup
#   hub
#   node
#   trash
#   httpie
#   autojump
#   neofetch ## use for on zsh
#   lua
## Install custom tools
  # ffmpeg --with-faac --with-fdk-aac --with-sdl --with-freetype --with-libass --with-libbluray --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265
  # gcc
  # glew
  # glfw3
  # jenv


 # pyenv
 # rbenv ruby-build
 # sdl2
## Install `wget` with IRI support.
    wget --with-iri
    htop
    tree
## Install font tools.
#   tap bramstein/webfonttools
#   sfnt2woff
#   sfnt2woff-zopfli
#   woff2
## Install some CTF tools; see https://github.com/ctfs/write-ups.
#   aircrack-ng
#   bfg
#   binutils
#   binwalk
#   cifer
#   dex2jar
#   dns2tcp
#   fcrackzip
#   foremost
#   hashpump
#   hydra
#   john
#   knock
#   netpbm
#   nmap
#   pngcheck
#   socat
#   sqlmap
#   tcpflow
#   tcpreplay
#   tcptrace
#   ucspi-tcp
#  `tcpserver` etc.
#   xpdf
#   xz
## Install other useful binaries.
 # ack
 # exiv2
 # dark-mode
 # git
 # git-lfs
 # imagemagick --with-webp
 # lua
 # lynx
 # p7zip
 # pigz
 # pv
 # rename
 # rhino
 # speedtest_cli
 # ssh-copy-id
 # tree
 # vbindiff
 # webkit2png
 # zopfli
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar.
brew cleanup

caskapps=(

    #android-studio
    # alfred
    # atom
    cheatsheet
    dash
    evernote
    # genymotion
    google-chrome
    google-drive
    intellij-idea-ce
## Dev Tools
    iterm2
    java
    sublime-text3
    # karabiner
    # keepassx
    # kindle
    # pomotodo
    # pycharm-ce
    # qq
    # qqmusic
    # qqmacmgr
    sogouinput
    thunder
    # vagrant
    # virtualbox
    youdao
##  Quicklook plugins
    # qlcolorcode
    # qlmarkdown
    # quicklook-json
    # quicklook-csv
    # qlstephen
    # qlprettypatch
    # qlimagesize
    # webpquicklook
    # provisionql
## Fonts
    font-sauce-code-powerline
    font-source-code-pro
    font-source-sans-pro
    font-source-serif-pro
## Media

#vlc
)

brew tap caskroom/versions
brew cask update
brew cask install --appdir="/Applications" "${caskapps[@]}"
brew cask cleanup
