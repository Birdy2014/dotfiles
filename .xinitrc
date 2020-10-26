#!/usr/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && source "$f"
    done
    unset f
fi

picom --experimental-backend &
xss-lock slock &
dwm-statusbar start
[ -f ~/.fehbg ] && ~/.fehbg
[ -f ~/.Xresources ] && xrdb ~/.Xresources
[ -f ~/.xprofile ] && source ~/.xprofile

exec dwm
