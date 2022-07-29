fish_add_path -p $HOME/.local/share/cargo/bin
fish_add_path -p $HOME/.local/bin

set -gx EDITOR /usr/bin/nvim
set -gx VISUAL /usr/bin/nvim

if status is-interactive
    set fish_greeting
    fish_vi_key_bindings

    alias ls 'ls --color=auto'
    alias l 'ls -lAh'
    alias tm 'tmux new-session -A -s main'
    alias config '/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    alias gap 'git add -p'

    set -gx MANPAGER 'nvim +Man!'
end

if status is-login
    if test (tty) = "/dev/tty1"
        exec start-sway
    else if test (tty) = "/dev/tty2"
        exec startx
    end
end

# Based on https://github.com/joelwanner/theme-boxfish
function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd)

    # Display hostname if in ssh session
    if test -n "$SSH_CLIENT"; or test -n "$SSH_TTY"
        set_color black -b yellow
        echo -n " $(hostname -s) "
    end

    # Show if last command was not successful
    if not test $last_status -eq 0
        set_color --bold white -b red
        echo -n ' ! '
        set_color normal
    end

    # Display current path
    set_color black -b blue
    echo -n " $cwd "

    # Show git branch and dirty state
    set -l git_branch (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
    set -l git_dirty (command git status -s --ignore-submodules=dirty 2> /dev/null)
    if test -n "$git_branch"
        if test -n "$git_dirty"
            set_color black -b yellow
            echo -n " $git_branch "
        else
            set_color black -b green
            echo -n " $git_branch "
        end
    end

    # Add a space
    set_color normal
    echo -n ' '
end

function fish_mode_prompt
    if [ $fish_key_bindings = fish_vi_key_bindings ]
        switch $fish_bind_mode
            case default
                set_color -b red
            case insert
                set_color -b green
            case visual
                set_color -b yellow
            case replace-one
                set_color -b magenta
        end
        echo -n " "
    end
end

function init_conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
    # <<< conda initialize <<<
end
