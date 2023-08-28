# -*- mode: sh -*-

source $DOTFILES/utils.sh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && is_gui ; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zinit/bin/zinit.zsh

zinit light-mode for \
  is-snippet OMZ::lib/history.zsh \
  is-snippet OMZ::lib/key-bindings.zsh \
  MichaelAquilina/zsh-you-should-use

zinit wait lucid for \
 atinit"ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'; ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions \
 as"completion" is-snippet \
    https://github.com/greymd/docker-zsh-completion/tree/master/repos/docker/cli/master/contrib/completion/zsh/_docker \
    https://github.com/greymd/docker-zsh-completion/blob/master/repos/docker/compose/master/contrib/completion/zsh/_docker-compose

zinit ice wait lucid from"gh" depth=1
zinit light-mode lucid for \
  hlissner/zsh-autopair \
  load"command -v lua &> /dev/null" \
  skywind3000/z.lua \
  load"command -v fzf &> /dev/null" \
  Aloxaf/fzf-tab \
  load"command -v fzf &> /dev/null" \
  joshskidmore/zsh-fzf-history-search \
  mdumitru/git-aliases \
  load"command -v git-lfs &> /dev/null" \
  nekofar/zsh-git-lfs \
  arzzen/calc.plugin.zsh

# snippet
zinit ice atinit"ZSH_TMUX_FIXTERM=false"
zinit snippet OMZ::plugins/tmux/tmux.plugin.zsh
if brew_exists ; then
   zinit snippet OMZ::plugins/brew/brew.plugin.zsh
fi
zinit snippet OMZ::plugins/web-search/web-search.plugin.zsh
zinit ice atload"alias x=extract"
zinit snippet OMZ::plugins/extract/extract.plugin.zsh

if is_gui ; then
  zinit ice from"gh" depth=1
  zinit light romkatv/powerlevel10k
fi

if cmd_exists "exa"; then
  alias ls='exa --group-directories-first'
  alias l='exa --group-directories-first -laH'
  alias ll='exa --group-directories-first -lH'
else
  zinit ice wait lucid as"program" from"gh-r" \
    mv"bin/exa -> exa" pick"exa" lucid \
    atload"
      alias ls='exa --group-directories-first'
      alias l='exa --group-directories-first -laH'
      alias ll='exa --group-directories-first -lH'"
  zinit light ogham/exa
fi

zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
zinit light b4b4r07/httpstat

# complete for ssh_host
function _all_ssh_host() {
  local _known_hosts=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })
  local _conf_hosts=()
  if [[ -f "$HOME/.ssh/config" ]]; then
    _conf_hosts=($(egrep '^Host.*' $HOME/.ssh/config | awk '{print $2}' | grep -v '^*' | sed -e 's/\.*\*$//'))
  fi

  local _hosts=("$_known_hosts[@]" "$_conf_hosts[@]")

  echo ${(u)_hosts}
}

zstyle -e ':completion:*:hosts' hosts 'reply=($(_all_ssh_host))'

if [[ -n $INSIDE_EMACS || -n $TMUX ]] && cmd_exists "jenv" ; then
  export PATH=${PATH//$HOME\/.jenv\/shims:}
  eval "$(jenv init - zsh)"
fi

alias tailf="tail -f"
alias t="tail -f"

alias goto_dotfiles='cd $DOTFILES'
alias upgrade_dotfiles='cd $DOTFILES && git pull; cd - >/dev/null'
alias upgrade_oh_my_tmux='cd $HOME/.tmux && git pull; cd - >/dev/null'

if cmd_exists "emacsclient"; then
  local _emacsclient=($(command -v "emacsclient"))
  export EDITOR="${_emacsclient} -a \"emacs\""
  alias e="$EDITOR -n"
  alias ec="$EDITOR -n -c"
  alias ef="$EDITOR -c"
  alias te="$EDITOR -a '' -nw"
fi

if cmd_exists "node"; then
  alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'
  alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'
fi

if cmd_exists "md5-cli"; then
  alias md5="md5-cli"
fi

function encode64() {
  if [[ $# -eq 0 ]]; then
    cat | base64
  else
    printf '%s' $1 | base64
  fi
}

function decode64() {
  if [[ $# -eq 0 ]]; then
    cat | base64 --decode
  else
    printf '%s' $1 | base64 --decode
  fi
}
alias e64=encode64
alias d64=decode64

if [[ "$INSIDE_EMACS" = "vterm" ]] && [[ -n ${EMACS_VTERM_PATH} ]] && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
  source ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh
fi

if cmd_exists "nvim"; then
  alias vim="nvim"
  alias vi="nvim"
fi

if cmd_exists "dust"; then
  alias du="dust";
fi

if cmd_exists "duf"; then
  alias df="duf";
fi

if cmd_exists "bat"; then
  alias cat="bat";

  if cmd_exists "fzf"; then
    alias fzfpreview="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
  fi

  function batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
  }
  alias gd=batdiff

  export MANPAGER="sh -c 'col -bx | bat -l man -p'"

  function help() {
    "$@" --help 2>&1 | bat --plain --language=help
  }
fi

if cmd_exists "gman"; then
  export MANPATH="$(gman --path)"
fi

if [[ "$(get_os)" == "macos" ]]; then
  alias aria2c="aria2c --file-allocation=none"
fi

if cmd_exists "direnv"; then
  eval "$(direnv hook zsh)"
fi

function zle-keymap-select zle-line-init zle-line-finish {
  case $KEYMAP in
      vicmd)      print -n '\033[1 q';; # block cursor
      viins|main) print -n '\033[4 q';; # underline cursor
  esac
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# show system info
if cmd_exists "neofetch" && is_gui ; then
    neofetch
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if is_gui ; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

if [[ "$(get_os)" != "macos" ]] && cmd_exists "startx" ; then
  [[ "$(tty)" == "/dev/tty1" ]] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx
fi
