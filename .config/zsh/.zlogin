if [ "$TTY" = "/dev/tty1" ]; then
    export _JAVA_AWT_WM_NONREPARENTING=1
    pgrep Xorg || exec startx
elif [ "$TTY" = "/dev/tty2" ]; then
    export _JAVA_AWT_WM_NONREPARENTING=1
    export MOZ_ENABLE_WAYLAND=1
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export XCURSOR_THEME=LyraX
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland
    pgrep sway || exec sway --unsupported-gpu
fi
