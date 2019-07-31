#!/usr/bin/env bash

# variables
DOTFILES=$HOME/.dotfiles
ANTIGEN=$HOME/.antigen
TMUX=$HOME/.tmux
EMACSD=$HOME/.emacs.d
SPACEMACSD=$HOME/.spacemacs.d

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

. "${BASE_DIR}/utils.sh"

if [ ! git_exist ]; then
    print_error_and_exit "git is not installed"
fi

if [ ! curl_exist ]; then
    print_error_and_exit "curl is not installed"
fi

if [ "$(get_os)" == "macos" ]; then
    print_info "checking brew..."
    if brew_exist; then
        print_success "brew has been installed"
    else
        print_info "installing brew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        print_success "brew install successfully"
    fi

    print_info "checking homebrew-cask..."
    if [[ -d "$(brew --repo)/Library/Taps/homebrew/homebrew-cask" ]]; then
        print_success "homebrew-cask has been added"
    else
        print_info "adding homebrew-cask..."
        brew tap homebrew/cask
        print_success "homebrew-cask add successfully"
    fi

    print_info "checking homebrew-cask-fonts..."
    if [[ -d "$(brew --repo)/Library/Taps/homebrew/homebrew-cask-fonts" ]]; then
        print_success "homebrew-cask-fonts has been added"
    else
        print_info "adding homebrew-cask-fonts..."
        brew tap homebrew/cask-fonts
        print_success "homebrew-cask-fonts add successfully"
    fi

    print_info "checking homebrew-cask-versions..."
    if [[ -d "$(brew --repo)/Library/Taps/homebrew/homebrew-cask-versions" ]]; then
        print_success "homebrew-cask-versions has been added"
    else
        print_info "adding homebrew-cask-versions..."
        brew tap homebrew/cask-versions
        print_success "homebrew-cask-versions add successfully"
    fi

    print_info "checking homebrew-cask-upgrade..."
    if [[ -d "$(brew --repo)/Library/Taps/buo/homebrew-cask-upgrade" ]]; then
        print_success "homebrew-cask-upgrade has been added"
    else
        print_info "adding homebrew-cask-upgrade..."
        brew tap buo/cask-upgrade
        print_success "homebrew-cask-upgrade add successfully"
    fi

    print_info "checking homebrew-emacs-plus..."
    if [[ -d "$(brew --repo)/Library/Taps/d12frosted/homebrew-emacs-plus" ]]; then
        print_success "homebrew-emacs-plus has been added"
    else
        print_info "adding homebrew-emacs-plus..."
        brew tap d12frosted/emacs-plus
        print_success "homebrew-emacs-plus add successfully"
    fi
fi

print_info "checking antigne..."
antigen_files=("${ANTIGEN}/antigen.zsh" "/usr/local/share/antigen/antigen.zsh" "/usr/share/zsh/share/antigen.zsh")
found_antigen=0
for file in ${antigen_files[@]}; do
    if [[ -f $file ]]; then
        found_antigen=1
        break;
    fi
done

if [[ found_antigen -eq 1 ]]; then
    print_success "antigen has been installed"
else
    print_info "installing antigen..."
    case $(get_os) in
        macos)
            brew install antigen
            ;;
        arch)
            if ! yay_exists; then
                print_error_and_exit "yay is not installed, please install yay first"
            fi
            yay -S --noconfirm antigen-git
            ;;
        *)
            mkdir -p $ANTIGEN
            curl -fsSL https://git.io/antigen > $ANTIGEN/antigen.zsh.tmp && mv $ANTIGEN/antigen.zsh.tmp $ANTIGEN/antigen.zsh
    esac
fi

print_info "installing dotfiles..."
sync_git_repo github cxb811201/dotfiles $DOTFILES

# zsh
ln -sf $DOTFILES/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/.zshrc $HOME/.zshrc

# tmux
ln -sf $DOTFILES/.tmux.conf.local $HOME/.tmux.conf.local

# npm
ln -sf $DOTFILES/.npmrc $HOME/.npmrc

# gem
ln -sf $DOTFILES/.gemrc $HOME/.gemrc

# pypi
if [ $(get_os) != "macos" ]; then
    mkdir -p $HOME/.config/pip
    ln -sf $DOTFILES/pip.conf $HOME/.config/pip/pip.conf
fi

# sbt
cp -rf $DOTFILES/.sbt $HOME

# git
ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global
ln -sf $DOTFILES/.gitconfig_global $HOME/.gitconfig_global
if [ $(get_os) == "macos" ]; then
    ln -sf $DOTFILES/.gitconfig_macos $HOME/.gitconfig
else
    ln -sf $DOTFILES/.gitconfig_linux $HOME/.gitconfig
fi
print_success "dotfiles install successfully"

print_info "installing tmux..."
sync_git_repo github gpakosz/.tmux $TMUX optimizations
ln -sf $TMUX/.tmux.conf $HOME/.tmux.conf
print_success "tmux install successfully"

print_info "installing spacemacs..."
sync_git_repo github cxb811201/spacemacs $EMACSD develop
sync_git_repo github cxb811201/spacemacs-private $SPACEMACSD
print_success "spacemacs install successfully"

# Entering zsh
print_success "done. Enjoy!"
if zsh_exists; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        print_info "you need to logout and login to enable zsh as the default shell."
    fi
    env zsh
else
    print_error_and_exit "zsh is not installed"
fi
