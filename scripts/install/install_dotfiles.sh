#!/bin/zsh
#======================================================================================
#
# Author: Andrew Bell andrewbell8@gmail.com
# Website: https://fr1v.github.io
#
# 2017.06.21
#
# Link my config from dotfiles and to root user as well
#======================================================================================

setopt LOCAL_OPTIONS EXTENDED_GLOB

if [[ $OSTYPE == *darwin* ]] ; then
    USER_HOME="/Users/$USER"
    ROOT_HOME="/root"
elif [[ $OSTYPE == *linux* ]] ; then
    USER_HOME="/home/$USER"
    ROOT_HOME="/root"
fi


function link_root() {

    emulate -L zsh
    setopt LOCAL_OPTIONS EXTENDED_GLOB

    sudo rm -rf "$ROOT_HOME"/.zprezto && sudo ln -sd "$USER_HOME"/.dotfiles/prezto "$ROOT_HOME"/.zprezto
    sudo rm -rf "$ROOT_HOME"/.misc && sudo ln -sd "$USER_HOME"/.dotfiles/misc "$ROOT_HOME"/.misc
    sudo rm -rf "$ROOT_HOME"/.scripts && sudo ln -sd "$USER_HOME"/.dotfiles/scripts "$ROOT_HOME"/.scripts
    sudo rm -rf "$ROOT_HOME"/.git && sudo ln -sd "$USER_HOME"/.dotfiles/vcs/git "$ROOT_HOME"/.git
    sudo rm -rf "$ROOT_HOME"/.hg && sudo ln -sd "$USER_HOME"/.dotfiles/vcs/hg "$ROOT_HOME"/.hg

    for rcfile in "$USER_HOME"/.zprezto/runcoms/^README.md(.N); do
        sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}"
    done

    if [[ $OSTYPE == *darwin* ]] ; then
        sudo ln -sd "$USER_HOME/.dotfiles/macos/iterm" "$ROOT_HOME/.iterm2"
        sudo ln -sf "$USER_HOME/.dotfiles/macos/iterm/iterm2_shell_integration.zsh" "$ROOT_HOME/.iterm2_shell_integration.zsh"
        sudo ln -sf "$USER_HOME/.dotfiles/macos/iterm/iterm2_shell_integration.bash" "$ROOT_HOME/.iterm2_shell_integration.bash"

        for rcfile in "$USER_HOME"/.git/macos/^README.md(.N); do
            sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}_global"
        done

        for rcfile in "$USER_HOME"/.hg/macos/^README.md(.N); do
            sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}"
        done

        for rcfile in "$USER_HOME"/.misc/^README.md(.N); do
            sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}"
        done

        sudo ln -sf "$USER_HOME"/.hg/macos/config/hgignore "$ROOT_HOME"/.hgignore_global

        sudo ln -sf "$USER_HOME/.dotfiles/misc/macos/dircolors" "$ROOT_HOME/.dircolors"

        # Sublime Text 3
        sudo rm -rf "$ROOT_HOME/Library/Application Support/Sublime Text 3" \
            sudo rm -rf "$ROOT_HOME/Library/Caches/com.sublimetext.3" \
            sudo rm -rf "$ROOT_HOME/Library/Preferences/com.sublimetext.3.plist" \
            sudo rm -rf "$ROOT_HOME/Library/Saved Application State/com.sublimetext.3.savedState" \
            sudo mkdir -p "$ROOT_HOME/Library/Application Support" \
            sudo ln -s "$USER_HOME/Library/Application Support/Sublime Text 3/" "$ROOT_HOME/Library/Application Support/Sublime Text 3"

    elif [[ $OSTYPE == *linux* ]] ; then

        for rcfile in "$USER_HOME"/.git/linux/^README.md(.N); do
            sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}_global"
        done

        for rcfile in "$USER_HOME"/.hg/linux/^README.md(.N); do
            sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}"
        done

        sudo ln -sf "$USER_HOME"/.hg/linux/config/hgignore "$ROOT_HOME"/.hgignore_global

        sudo ln -sf "$USER_HOME/.dotfiles/misc/linux/dircolors" "$ROOT_HOME/.dircolors"

        for rcfile in "$USER_HOME"/.misc/^README.md(.N); do
            sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}"
        done

        for rcfile in "$USER_HOME"/.xorg/^README.md(.N); do
            sudo ln -sf "$rcfile" "$ROOT_HOME/.${rcfile:t}"
        done

        # Sublime Text 3
        sudo rm -rf "$ROOT_HOME/.config/sublime-text-3" \
            sudo rm -rf "$ROOT_HOME/Library/Caches/com.sublimetext.3" \
            sudo rm -rf "$ROOT_HOME/Library/Preferences/com.sublimetext.3.plist" \
            sudo rm -rf "$ROOT_HOME/Library/Saved Application State/com.sublimetext.3.savedState" \
            sudo mkdir -p "$ROOT_HOME/.config" \
            sudo ln -s "$USER_HOME/.config/sublime-text-3/" "$ROOT_HOME/Library/Application Support/Sublime Text 3"
    fi
}

function root_link_inquire() {
    emulate -L zsh

    echo  -n "Do you want to link your config to /root as well [Y/N]? "
    read answer
    finish="-1"
    while [ "$finish" = '-1' ]
    do
    finish="1"
    if [ "$answer" = '' ];
    then
    answer=""
    else
      case $answer in
        y | Y | yes | YES ) answer="y"; link_root; echo "User & root config linked, script complete"; exit 1;;
        n | N | no | NO ) answer="n"; echo "User config only linked, script complete"; exit 1;;
        *) finish="-1";
          echo -n 'Invalid response -- please reenter:';
          read answer;;
      esac
    fi
    done
}

function link_user() {

    emulate -L zsh

    setopt LOCAL_OPTIONS EXTENDED_GLOB

    rm -rf "${ZDOTDIR:-$HOME}"/.zprezto && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/prezto "${ZDOTDIR:-$HOME}"/.zprezto
    rm -rf "${ZDOTDIR:-$HOME}"/.misc && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/misc "${ZDOTDIR:-$HOME}"/.misc
    rm -rf "${ZDOTDIR:-$HOME}"/.xorg && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/xorg "${ZDOTDIR:-$HOME}"/.xorg
    rm -rf "${ZDOTDIR:-$HOME}"/.scripts && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/scripts "${ZDOTDIR:-$HOME}"/.scripts
    rm -rf "${ZDOTDIR:-$HOME}"/.git && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/vcs/git "${ZDOTDIR:-$HOME}"/.git
    rm -rf "${ZDOTDIR:-$HOME}"/.hg && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/vcs/hg "${ZDOTDIR:-$HOME}"/.hg
    rm -rf "${ZDOTDIR:-$HOME}"/.config/ranger && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/ranger "${ZDOTDIR:-$HOME}"/.config/ranger
    rm -rf "${ZDOTDIR:-$HOME}"/.config/nvim && ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/nvim "${ZDOTDIR:-$HOME}"/.config/nvim


    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -sf "$rcfile" "${ZDOTDIR:-$HOME}"/.${rcfile:t}
    done

    if [[ $OSTYPE == *darwin* ]] ; then

        ln -sd "${ZDOTDIR:-$HOME}"/.dotfiles/macos/iterm/tools "${ZDOTDIR:-$HOME}"/.iterm2
        ln -sf "${ZDOTDIR:-$HOME}"/.dotfiles/macos/iterm/iterm2_shell_integration.zsh "${ZDOTDIR:-$HOME}"/.iterm2_shell_integration.zsh
        ln -sf "${ZDOTDIR:-$HOME}"/.dotfiles/macos/iterm/iterm2_shell_integration.bash "${ZDOTDIR:-$HOME}"/.iterm2_shell_integration.bash

        brew tap caskroom/cask
        brew cask install macdown

        for rcfile in "${ZDOTDIR:-$HOME}"/.git/macos/^README.md(.N); do
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}_global"
        done

        for rcfile in "${ZDOTDIR:-$HOME}"/.hg/macos/^README.md(.N); do
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}_global"
        done

        ln -sf "${ZDOTDIR:-$HOME}"/.hg/macos/config/hgignore "${ZDOTDIR:-$HOME}"/.hgignore_global

        ln -sf "${ZDOTDIR:-$HOME}"/.dotfiles/misc/macos/dircolors "${ZDOTDIR:-$HOME}"/.dircolors

    elif [[ $OSTYPE == *linux* ]] ; then

        for rcfile in "${ZDOTDIR:-$HOME}"/.git/linux/^README.md(.N); do
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}_global"
        done

        for rcfile in "${ZDOTDIR:-$HOME}"/.hg/linux/^README.md(.N); do
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}_global"
        done

        for rcfile in "${ZDOTDIR:-$HOME}"/.misc/^README.md(.N); do
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        done

        for rcfile in "${ZDOTDIR:-$HOME}"/.misc/linux/^README.md(.N); do
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        done

        for rcfile in "${ZDOTDIR:-$HOME}"/.xorg/^README.md(.N); do
            ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        done
    fi
}

function install_homebrew() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

# Symlink config files
function install_dotfiles() {
    emulate -L zsh

    $USER_HOME/.dotfiles/prezto/homebrew/functions/install_brew

    link_user
    root_link_inquire
}

install_dotfiles "$@"
