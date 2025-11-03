# -*- mode: sh -*-

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
[[ -z "$TERM" ]] && export TERM="xterm-256color"
export DOTFILES=$HOME/.dotfiles

# editor
[[ -z "$EDITOR" ]] && export EDITOR="vim"

# java
[[ ! $OSTYPE == darwin* ]] && export _JAVA_AWT_WM_NONREPARENTING=1
# export JAVA_OPTS="-XX:+UseNUMA -XX:+UseG1GC"

# sbt
export SBT_OPTS="-Xms2048m -Xmx2048m -XX:ReservedCodeCacheSize=256m -XX:MaxMetaspaceSize=512m -Dsbt.override.build.repos=true"

# brew
if [[ $OSTYPE == darwin* ]]; then
  # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
  # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
  export HOMEBREW_CURLRC=1
  export HOMEBREW_CURL_RETRIES=10
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_BUNDLE_NO_LOCK=1
  export HOMEBREW_NO_VERIFY_ATTESTATIONS=1
  export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
fi

# rust
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"

# node
export N_NODE_MIRROR="https://npmmirror.com/mirrors/node"
export N_PREFIX="$HOME/.n"

# golang
export GO111MODULE=on
export GOPROXY="https://goproxy.cn,direct"
export GOPRIVATE="git.iobox.me"
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
[[ $OSTYPE == darwin* && -d "/opt/homebrew/opt/go/libexec" ]] && export GOROOT="/opt/homebrew/opt/go/libexec"

# lsp
export LSP_USE_PLISTS=true

# testcontainers
export TESTCONTAINERS_RYUK_DISABLED=true
