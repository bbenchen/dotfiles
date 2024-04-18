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
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_BUNDLE_NO_LOCK=1
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
export GOPROXY="https://goproxy.io,direct"
export GOPRIVATE="git.iobox.me"
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
[[ $OSTYPE == darwin* && -d "/opt/homebrew/opt/go/libexec" ]] && export GOROOT="/opt/homebrew/opt/go/libexec"

# lsp
export LSP_USE_PLISTS=true

if [[ $OSTYPE == darwin* ]]; then
  [[ -d "/usr/local/sbin" ]] && export PATH="/usr/local/sbin:$PATH"

  # For Apple Silicon CPU
  [[ $CPUTYPE == arm* && -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

[[ -d "$HOME/.bin" ]] && export PATH="$HOME/.bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ $OSTYPE == linux* && -d "$DOTFILES/local/bin" ]] && export PATH="$DOTFILES/local/bin:$PATH"
[[ -d "$HOME/.emacs.d/bin" ]] && export PATH="$HOME/.emacs.d/bin:$PATH"
[[ -d "$HOME/.doom.d/bin" ]] && export PATH="$HOME/.doom.d/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# jenv
if [[ -d "$HOME/.jenv/bin" ]]; then
  export PATH="$HOME/.jenv/shims:$HOME/.jenv/bin:$PATH"
  export JENV_LOADED=1
fi

# node
export PATH="$N_PREFIX/bin:$PATH"

# golang
export PATH="${GOPATH//://bin:}/bin:$PATH"

# other's path for macos
if [[ $OSTYPE == darwin* ]]; then
  [[ -d "/opt/homebrew/opt/e2fsprogs/bin" ]] && export PATH="/opt/homebrew/opt/e2fsprogs/bin:$PATH"
  [[ -d "/opt/homebrew/opt/e2fsprogs/sbin" ]] && export PATH="/opt/homebrew/opt/e2fsprogs/sbin:$PATH"
  [[ -d "/opt/homebrew/opt/gnu-indent/libexec/gnubin" ]] && export PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
  [[ -d "/opt/homebrew/opt/gnu-tar/libexec/gnubin" ]] && export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
  [[ -d "/opt/homebrew/opt/gnu-sed/libexec/gnubin" ]] && export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
  [[ -d "/opt/homebrew/opt/findutils/libexec/gnubin" ]] && export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
  [[ -d "/opt/homebrew/opt/gawk/libexec/gnubin" ]] && export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
  [[ -d "/opt/homebrew/opt/coreutils/libexec/gnubin" ]] && export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
  [[ -d "/opt/homebrew/opt/man-db/libexec/bin" ]] && export PATH="/opt/homebrew/opt/man-db/libexec/bin:$PATH"
  [[ -d "$HOME/Library/Python/3.12/bin" ]] && export PATH="$HOME/Library/Python/3.12/bin:$PATH"
  [[ -d "/Library/TeX/texbin" ]] && export MANPATH="$MANPATH:/Library/TeX/Distributions/.DefaultTeX/Contents/Man"
fi
