# -*- mode: sh -*-

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
[[ -d "$HOME/.jenv/bin" ]] && export PATH="$HOME/.jenv/shims:$HOME/.jenv/bin:$PATH"

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
