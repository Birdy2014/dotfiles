if [ "$TTY" = "/dev/tty1" ]; then
    exec start-sway
elif [ "$TTY" = "/dev/tty2" ]; then
    exec startx
fi
