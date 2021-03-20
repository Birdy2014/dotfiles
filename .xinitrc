#!/usr/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && source "$f"
    done
    unset f
fi

[ -f ~/.Xresources ] && xrdb ~/.Xresources

session=${1:-dwm}

case $session in
    gnome)
        export XDG_SESSION_TYPE=x11
        export GDK_BACKEND=x11
        exec gnome-session
        ;;
    plasma|kde)
        export DESKTOP_SESSION=plasma
        exec startplasma-x11
        ;;
    dwm)
        picom --experimental-backend &
        xss-lock slock &
        dwm-statusbar start
        [ -f ~/.fehbg ] && ~/.fehbg
        [ -f ~/.xprofile ] && source ~/.xprofile
        exec dwm
        ;;
esac
