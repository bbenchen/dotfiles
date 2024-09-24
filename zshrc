# -*- mode: sh -*-

# shellcheck source=/dev/null
source "$DOTFILES/utils.sh"

ZPFX="$HOME/.local"
typeset -A ZINIT
ZINIT[MAN_DIR]="$ZPFX/share/man"
# shellcheck disable=SC2034
MANPATH="${ZINIT[MAN_DIR]}:$MANPATH"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
[ ! -d "$ZINIT_HOME" ] && sync_git_repo github zdharma-continuum/zinit "$ZINIT_HOME"
# shellcheck source=/dev/null
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
# shellcheck disable=SC2154
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit id-as light-mode depth"1" for \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl

# Oh My Zsh
zinit for \
  OMZL::clipboard.zsh \
  OMZL::directories.zsh \
  OMZL::history.zsh \
  OMZL::key-bindings.zsh \
  OMZL::theme-and-appearance.zsh

zinit wait lucid for \
  OMZP::cp \
  OMZP::extract \
  OMZP::fancy-ctrl-z \
  OMZP::git-lfs\
  OMZP::git \
  OMZP::mvn \
  OMZP::ssh \
  OMZP::sudo \
  OMZP::urltools

# Completion enhancements
zinit id-as wait lucid light-mode for \
  atinit"ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'; ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

zinit id-as wait lucid light-mode depth"1" for \
  MichaelAquilina/zsh-you-should-use \
  hlissner/zsh-autopair

#
# Utilities
#

# brew
if cmd_exists "brew"; then
    [[ -z "$HOMEBREW_PREFIX" ]] && HOMEBREW_PREFIX="$(brew --prefix)" && export HOMEBREW_PREFIX
    if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
        fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
        autoload -Uz compinit
        compinit
    fi

    alias bubo='brew update && brew outdated'
    alias bubc='brew upgrade && brew cleanup'
fi

# httpstat
zinit ice id-as as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
zinit light b4b4r07/httpstat

# direnv
zinit ice id-as from"gh-r" as"program" mv"direnv* -> direnv" \
  atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
  pick"direnv" src="zhook.zsh"
zinit light direnv/direnv

# ripgrep
zinit ice id-as from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit light BurntSushi/ripgrep

# fd
zinit ice id-as as"command" from"gh-r" mv"fd*/fd -> fd" pick"fd"
zinit light sharkdp/fd

# bat
zinit ice id-as as"command" from"gh-r" mv"bat*/bat -> bat" pick"bat"
zinit light sharkdp/bat

# delta git diff
zinit ice id-as as"command" from"gh-r" mv"delta*/delta -> delta" pick"delta"
zinit light dandavison/delta

# z
zinit ice id-as as"command" from"gh-r" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide
export _ZO_FZF_OPTS="--scheme=path --tiebreak=end,chunk,index --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --border=sharp --height=45% --info=inline --layout=reverse --tabstop=1 --exit-0 --select-1 --preview '(lsd --tree --depth 3 --icon always --color always --group-directories-first {2} || tree -NC {2} || ls --color=always --group-directories-first {2}) 2>/dev/null | head -200'"

# Git extras
# zinit ice id-as wait lucid as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" if'(( $+commands[make] ))'
# zinit light tj/git-extras

# Prettify ls
zinit ice id-as as"command" from"gh-r" mv"lsd*/lsd -> lsd" pick"lsd" \
  atload"alias ls='lsd --group-directories-first'
        alias l='ls -lA'
        alias ll='ls -lA --header'
        alias tree='ls --tree'
        unalias la lsa"
zinit light lsd-rs/lsd
test -r "$HOME/.dir_colors" && eval "$(dircolors "$HOME"/.dir_colors)"

# jenv
unset JENV_LOADED
cmd_exists "jenv" && eval "$(jenv init -)"

# fzf
zinit ice id-as from"gh-r" as"program" atload"source <(fzf --zsh)"
zinit light junegunn/fzf

zinit id-as wait lucid depth"1" for \
  wfxr/forgit \
  joshskidmore/zsh-fzf-history-search
export FORGIT_FZF_DEFAULT_OPTS="--exact --border --cycle --reverse"

zinit ice id-as wait lucid depth"1" atload"zicompinit; zicdreplay" blockf
zinit light Aloxaf/fzf-tab

# zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
# shellcheck disable=SC2016
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:complete:*:options' sort false

zstyle ':fzf-tab:*' switch-group '[' ']'

# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:(cd|ls|lsd|exa|eza|bat|cat|emacs|nano|vi|vim):*' \
       fzf-preview 'lsd -1 --icon=always --color=always --group-directories-first $realpath 2>/dev/null || ls -1 --color=always --group-directories-first $realpath'

# Preview environment vareiables
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
     fzf-preview 'echo ${(P)word}'

# Preivew `kill` and `ps` commands
# shellcheck disable=SC2016
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
       '[[ $group == "[process ID]" ]] &&
        if [[ $OSTYPE == darwin* ]]; then
            ps -p $word -o comm="" -w -w
        elif [[ $OSTYPE == linux* ]]; then
            ps --pid=$word -o cmd --no-headers -w -w
        fi'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# Preivew `git` commands
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
     'git diff $word | delta'
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
     'git log --color=always $word'
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
     'git help $word | bat -plman --color=always'
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
     'case "$group" in
     "commit tag") git show --color=always $word ;;
     *) git show --color=always $word | delta ;;
     esac'
zstyle ':completion:*:git-checkout:*' sort false
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
     'case "$group" in
     "modified file") git diff $word | delta ;;
     "recent commit object name") git show --color=always $word | delta ;;
     *) git log --color=always $word ;;
     esac'

# Privew help
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word | bat -plman --color=always'

# Preview `brew` commands
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'

# Preview systemd
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

export FZF_DEFAULT_OPTS='--height 50% --border --info=inline --layout=reverse'
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2>/dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview '(lsd --tree --depth 3 --icon always --color always --group-directories-first {} || tree -NC {} || ls --color=always --group-directories-first {}) 2>/dev/null | head -200'"

# theme
zinit ice id-as as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Alias
alias h="history"
alias q="exit"

alias goto_dotfiles='cd $DOTFILES'
alias upgrade_dotfiles='cd $DOTFILES && git pull; cd - >/dev/null'
alias upgrade_oh_my_tmux='cd $HOME/.tmux && git pull; cd - >/dev/null'

cmd_exists "nvim" && alias vim="nvim" && alias vi="nvim"
if cmd_exists "bat"; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  alias cat="bat -p --wrap character"
  alias -g -- -h="-h 2>&1 | bat --language=help --style=plain"
  alias -g -- --help="--help 2>&1 | bat --language=help --style=plain"
  tailf () {
    tail -f "$@" | bat --paging=never -l log
  }
  alias t="tailf"
fi
cmd_exists "fd" && alias find="fd"
cmd_exists "btm" && alias top="btm"
cmd_exists "rg" && alias grep="rg"
cmd_exists "delta" && alias diff="delta"
cmd_exists "duf" && alias df="duf"
cmd_exists "dust" && alias du="dust"
cmd_exists "gping" && alias ping="gping"
if cmd_exists "yazi"; then
  yy() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd" || exit
    fi
    rm -f -- "$tmp"
  }
  alias ranger="yy"
  alias lf="yy"
fi
if [[ "$(get_os)" == "macos" ]]; then
  alias aria2c="aria2c --file-allocation=none"
fi
if cmd_exists "emacsclient"; then
  # shellcheck disable=SC2168,SC2207
  local _emacsclient=($(command -v "emacsclient"))
  # shellcheck disable=SC2128
  export EDITOR="${_emacsclient} -a \"\""
  # shellcheck disable=SC2139
  alias e="$EDITOR -n"
  # shellcheck disable=SC2139
  alias ec="$EDITOR -n -c"
  # shellcheck disable=SC2139
  alias ef="$EDITOR -c"
  # shellcheck disable=SC2139
  alias te="$EDITOR -nw"
fi

# gpg
if [[ -t 0 ]]; then
  GPG_TTY="$(tty)" && export GPG_TTY
  PINENTRY_USER_DATA="USE_TTY" && export PINENTRY_USER_DATA
fi

# tmux
if [ -n "$TMUX" ]; then
    # Enable extended-keys
    printf '\033[>4;1m'
fi

# emacs
if [[ -n "$INSIDE_EMACS" ]]; then
  # shellcheck disable=SC2034
  DISABLE_AUTO_TITLE="true"

  # VTerm
  if [[ "$INSIDE_EMACS" = "vterm" ]]; then
    vterm_printf() {
      if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
      elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
      else
        printf "\e]%s\e\\" "$1"
      fi
    }

    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'

    # gpg
    unset PINENTRY_USER_DATA
  fi
fi

# show system info
cmd_exists "fastfetch" && is_gui && fastfetch

if [[ "$(get_os)" != "macos" ]] && cmd_exists "startx" ; then
  [[ "$(tty)" == "/dev/tty1" ]] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx
fi
