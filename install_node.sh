#!/usr/bin/env bash

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

# shellcheck source=/dev/null
. "${BASE_DIR}/utils.sh"

packages=(
    npm-check
    @vue/cli
    prettier
    js-beautify
    import-js
    stylelint
    eslint
    typescript
    tslint
    markdownlint-cli
    typescript-formatter
    typescript-language-server
    @vue/language-server
    vscode-langservers-extracted
    bash-language-server
    dockerfile-language-server-nodejs
    yaml-language-server
)

function check() {
    print_info "checking nodejs..."
    if ! cmd_exists "node"; then
        print_info "installing nodejs..."
        export N_NODE_MIRROR=https://npm.taobao.org/mirrors/node
        export N_PREFIX="$HOME/.n"
        export PATH="$N_PREFIX/bin:$PATH"
        curl -L https://git.io/n-install | bash -s -- -y -n -q
    else
        print_success "nodejs has been installed"
    fi
}

function install_packages() {
    for p in "${packages[@]}"; do
        print_info "installing $p ..."
        npm install -g "$p"
    done
}

function main() {
    check
    install_packages
}

main
