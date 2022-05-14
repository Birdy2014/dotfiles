fish_add_path -p $HOME/.cargo/bin
fish_add_path -p $HOME/.local/bin

set -gx EDITOR /usr/bin/nvim
set -gx VISUAL /usr/bin/nvim

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share

if status is-interactive
    set fish_greeting

    if not test -d "$HOME/.local/share/omf"
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > /tmp/install-omf
        fish /tmp/install-omf --path=$HOME/.local/share/omf --config=$HOME/.config/omf
        omf install boxfish
    end

    alias ls 'ls --color=auto'
    alias l 'ls -lAh'
    alias tm 'tmux new-session -A -s main'
    alias config '/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    alias gap 'git add -p'

    set -gx MANPAGER 'nvim +Man!'
end

if status is-login
    if test (tty) = "/dev/tty1"
        exec startx
    else if test (tty) = "/dev/tty2"
        set -gx XDG_CURRENT_DESKTOP sway
        set -gx XDG_SESSION_DESKTOP sway

        # enable wayland in applications
        set -gx _JAVA_AWT_WM_NONREPARENTING 1
        set -gx MOZ_ENABLE_WAYLAND 1
        #set -gx SDL_VIDEODRIVER wayland # Breaks games

        # theming
        set -gx XCURSOR_THEME LyraX
        set -gx GTK_THEME Gruvbox-Material-Dark
        set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION 1
        set -gx QT_QPA_PLATFORMTHEME qt5ct

        # workarounds
        set -gx WLR_NO_HARDWARE_CURSORS 1 # Workaround for invisible cursor on nvidia
        #set -gx MOZ_WEBRENDER 0 # Workaround for firefox freezing when opening multiple windows

        exec sway --unsupported-gpu
    end
end

function init_conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
    # <<< conda initialize <<<
end
