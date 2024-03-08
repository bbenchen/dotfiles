# -*- mode: sh -*-

if [[ $OSTYPE == darwin* ]]; then
  if [[ -d "/usr/local/sbin" ]]; then
    export PATH="/usr/local/sbin:$PATH"
  fi
  # For Apple Silicon CPU
  [[ $CPUTYPE == arm* && -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -d "$HOME/.bin" ]]; then
  export PATH="$HOME/.bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ $OSTYPE == linux* && -d "$DOTFILES/local/bin" ]]; then
  export PATH="$DOTFILES/local/bin:$PATH"
fi

if [[ -d "$HOME/.emacs.d/bin" ]]; then
  export PATH="$HOME/.emacs.d/bin:$PATH"
fi

if [[ -d "$HOME/.doom.d/bin" ]]; then
  export PATH="$HOME/.doom.d/bin:$PATH"
fi

# java
if [[ -d "$HOME/.jenv/bin" ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init - zsh)"
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# node
export PATH="$N_PREFIX/bin:$PATH"

# golang
export PATH="${GOPATH//://bin:}/bin:$PATH"

# other's path for macos
if [[ $OSTYPE == darwin* ]]; then
  if [[ -d "/opt/homebrew/opt/e2fsprogs/bin" ]]; then
    export PATH="/opt/homebrew/opt/e2fsprogs/bin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/e2fsprogs/sbin" ]]; then
    export PATH="/opt/homebrew/opt/e2fsprogs/sbin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/gnu-indent/libexec/gnubin" ]]; then
    export PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/gnu-tar/libexec/gnubin" ]]; then
    export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/gnu-sed/libexec/gnubin" ]]; then
    export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/findutils/libexec/gnubin" ]]; then
    export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/gawk/libexec/gnubin" ]]; then
    export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/coreutils/libexec/gnubin" ]]; then
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
  fi

  if [[ -d "/opt/homebrew/opt/man-db/libexec/bin" ]]; then
    export PATH="/opt/homebrew/opt/man-db/libexec/bin:$PATH"
  fi

  if [[ -d "$HOME/Library/Python/3.11/bin" ]]; then
    export PATH="$HOME/Library/Python/3.11/bin:$PATH"
  fi

  if [[ -d "$HOME/Library/Python/3.12/bin" ]]; then
    export PATH="$HOME/Library/Python/3.12/bin:$PATH"
  fi
fi
