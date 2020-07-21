if [ "$TTY" = "/dev/tty1" ]; then
    pgrep Xorg || exec startx
fi
