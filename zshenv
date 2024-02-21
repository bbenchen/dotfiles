# -*- mode: sh -*-

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
[[ -z "$TERM" ]] && export TERM="xterm-256color"
export DOTFILES=$HOME/.dotfiles

# editor
[[ -z "$EDITOR" ]] && export EDITOR="vim"

# java
if [[ ! $OSTYPE == darwin* ]]; then
  export _JAVA_AWT_WM_NONREPARENTING=1
fi
export JAVA_OPTS="-XX:+UseNUMA -XX:+UseG1GC"

# sbt
export SBT_OPTS="-Xms2048m -Xmx2048m -XX:ReservedCodeCacheSize=256m -XX:MaxMetaspaceSize=512m -Dsbt.override.build.repos=true"

# brew
if [[ $OSTYPE == darwin* ]]; then
  # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

# rust
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"

# node
export N_NODE_MIRROR="https://npmmirror.com/mirrors/node"
export N_PREFIX="$HOME/.n"

# golang
export GO111MODULE=on
export GOPROXY="https://goproxy.io,direct"
export GOPRIVATE="git.iobox.me"
export GOSUMDB="gosum.io+ce6e7565+AY5qEHUk/qmHc5btzW45JVoENfazw8LielDsaI+lEbq6"
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
if [[ $OSTYPE == darwin* && -d "/opt/homebrew/opt/go/libexec" ]]; then
  export GOROOT="/opt/homebrew/opt/go/libexec"
fi

# lsp
export LSP_USE_PLISTS=true
