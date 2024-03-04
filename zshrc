# -*- mode: sh -*-

# shellcheck source=/dev/null
source "$DOTFILES/utils.sh"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
[ ! -d "$ZINIT_HOME" ] && sync_git_repo github zdharma-continuum/zinit "$ZINIT_HOME"
# shellcheck source=/dev/null
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
# shellcheck disable=SC2154
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode depth"1" for \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl

# Oh My Zsh
zinit wait lucid for \
  OMZL::clipboard.zsh \
  OMZL::directories.zsh \
  OMZL::history.zsh \
  OMZL::key-bindings.zsh \
  OMZP::brew \
  OMZP::colored-man-pages \
  OMZP::cp \
  OMZP::extract \
  OMZP::fancy-ctrl-z \
  OMZP::git-lfs\
  OMZP::git \
  OMZP::jenv \
  OMZP::mvn \
  OMZP::ssh \
  OMZP::sudo \
  load"command -v tmux &> /dev/null" atinit"ZSH_TMUX_FIXTERM=false" \
  OMZP::tmux \
  OMZP::urltools

# Completion enhancements
zinit wait lucid light-mode for \
  atinit"ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'; ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

zinit wait lucid light-mode depth"1" for \
  MichaelAquilina/zsh-you-should-use \
  hlissner/zsh-autopair

#
# Utilities
#

# httpstat
zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
zinit light b4b4r07/httpstat

# direnv
zinit ice from"gh-r" as"program" mv"direnv* -> direnv" \
  atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
  pick"direnv" src="zhook.zsh"
zinit light direnv/direnv

# ripgrep
zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit light BurntSushi/ripgrep

# fd
zinit ice as"command" from"gh-r" mv"fd*/fd -> fd" pick"fd"
zinit light sharkdp/fd

# bat
zinit ice as"command" from"gh-r" mv"bat*/bat -> bat" pick"bat"
zinit light sharkdp/bat

# delta git diff
zinit ice as"command" from"gh-r" mv"delta*/delta -> delta" pick"delta"
zinit light dandavison/delta

# z
zinit ice as"command" from"gh-r" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide
export _ZO_FZF_OPTS="--scheme=path --tiebreak=end,chunk,index --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --border=sharp --height=45% --info=inline --layout=reverse --tabstop=1 --exit-0 --select-1 --preview '(eza --tree --icons --level 3 --color=always --group-directories-first {2} || tree -NC {2} || ls --color=always --group-directories-first {2}) 2>/dev/null | head -200'"

# Git extras
zinit ice wait lucid as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" if'(( $+commands[make] ))'
zinit light tj/git-extras

# Prettify ls
if cmd_exists "eza"; then
  alias ls='eza --group-directories-first'
  alias tree='ls --tree'
elif cmd_exists "gls"; then
  alias ls='gls --color=tty --group-directories-first'
else
  alias ls='ls --color=tty --group-directories-first'
fi

# Homebrew completion
if cmd_exists "brew"; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# fzf
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

zinit wait lucid depth"1" for \
  wfxr/forgit \
  joshskidmore/zsh-fzf-history-search

zinit ice wait lucid depth"1" atload"zicompinit; zicdreplay" blockf
zinit light Aloxaf/fzf-tab

zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:complete:*:options' sort false
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:(cd|ls|lsd|exa|eza|bat|cat|emacs|nano|vi|vim):*' \
       fzf-preview 'eza -1 --icons --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
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
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

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

# Preview `brew` commands
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'

# Privew help
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

# export FZF_DEFAULT_OPTS='--height 60% --border --info=inline--layout=reverse'
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2>/dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview '(eza --tree --icons --level 3 --color=always --group-directories-first {} || tree -NC {} || ls --color=always --group-directories-first {}) 2>/dev/null | head -200'"

# theme
zinit ice as"command" from"gh-r" \
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
  ya() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd" || exit
    fi
    rm -f -- "$tmp"
  }
  alias ranger="ya"
  alias lf="ya"
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

if [[ -n "$INSIDE_EMACS" ]]; then
  # shellcheck disable=SC2034
  DISABLE_AUTO_TITLE="true"

  if [[ "$INSIDE_EMACS" = "vterm" ]] && [[ -n "$EMACS_VTERM_PATH" ]] && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
    source "${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh"
  fi
fi

# show system info
cmd_exists "fastfetch" && is_gui && fastfetch

if [[ "$(get_os)" != "macos" ]] && cmd_exists "startx" ; then
  [[ "$(tty)" == "/dev/tty1" ]] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx
fi
