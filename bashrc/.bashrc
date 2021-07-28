#
# ~/.bashrc
#

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache

export HISTFILE="$XDG_CACHE_HOME"/bash/bash_history
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc-2.0
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc-1.0
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# disable less useless logging
export LESSHISTFILE=/dev/null

# default programs
export EDITOR=vim
export PAGER='less -F'
export BROWSER=firefox

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias vim='nvim'

PS1='[\#]\w \$ '
