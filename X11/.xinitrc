#!/bin/sh

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

startxfce4 &

exec i3
