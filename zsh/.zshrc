###
#
# zshell main config
#
###

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache

export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc-2.0
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc-1.0
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# disable less useless logging
export LESSHISTFILE=/dev/null

# default programs
export EDITOR=nvim
export PAGER='less -F'
export BROWSER=firefox
export TERMINAL=kitty

# make sure cach dir exists to save tmp files
mkdir -p "$XDG_CACHE_HOME"/zsh

# set path
typeset -U path
path=(~/bin
      $path)
export PATH

## set special keys
source "$XDG_CONFIG_HOME"/zsh/zkeys

## vim mode
bindkey -v
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# normal/insert lag time
export KEYTIMEOUT=1
# backspace and delete
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

eval "$(direnv hook zsh)"

## history
# append every comand to history file, share history in real time
HISTFILE="$XDG_CACHE_HOME"/zsh/zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
setopt hist_ignore_dups
setopt share_history
autoload -Uz history-search-end
# search related history
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

[[ -n "${key[Up]}"   ]]  && bindkey  "${key[Up]}"    history-beginning-search-backward
[[ -n "${key[Down]}" ]]  && bindkey  "${key[Down]}"  history-beginning-search-forward
bindkey -M vicmd '^[[A' history-beginning-search-backward-end \
                 '^[OA' history-beginning-search-backward-end \
                 '^[[B' history-beginning-search-forward-end \
                 '^[OB' history-beginning-search-forward-end
bindkey -M viins '^[[A' history-beginning-search-backward-end \
                 '^[OA' history-beginning-search-backward-end \
                 '^[[B' history-beginning-search-forward-end \
                 '^[OB' history-beginning-search-forward-end

## command input
# no beep
unsetopt beep
# tab completion
COMPDUMPFILE=~/.cache/zsh/zcompdump
setopt completealiases
zstyle :compinstall filename "$HOME/.zshrc"
autoload -U +X compinit && compinit -d ${COMPDUMPFILE}
autoload -U +X bashcompinit && bashcompinit

## directory stack
DIRSTACKFILE="$XDG_CACHE_HOME"/zsh/dirs
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  # [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
DIRSTACKSIZE=10
setopt autopushd pushdsilent pushdtohome pushdignoredups pushdminus


## prompt
autoload -Uz vcs_info
precmd () { vcs_info; }
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "[%b]"
PROMPT="%(?..[return %?])"$'\n'" %~ > "
RPROMPT='${vcs_info_msg_0_}[%*]'


## aliases
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcos='git checkout $(git branch --list | fzf)'
alias gl='git log'
alias glg='git log --graph --oneline --decorate --all'
alias gp='git pull'
alias gf='git fetch'
alias gs='git status -s'
alias gst='git stash'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gri='git rebase -i --autosquash --autostash'
alias grim='git rebase -i --autosquash --autostash origin/master'
alias grc='git rebase --continue'
alias gra='git rebase --abort'

if (( $+commands[nvim] )); then
  alias vim='nvim'
fi
if (( $+commands[bat] )); then
  alias cat='bat'
fi
if (( $+commands[fd] )); then
  alias find='fd'
fi
if (( $+commands[htop] )); then
  alias top='htop'
fi


# if a program is currently backgrounded, ctrl-z will foreground that program
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z


function set-title-precmd() {
  printf "\e]2;%s\a" "${PWD/#$HOME/~}"
}

function set-title-preexec() {
  printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi
