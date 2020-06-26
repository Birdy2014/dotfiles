[ -d "$HOME/.local/bin" ] && [[ $PATH == *"$HOME/.local/bin"* ]] || export PATH=$HOME/.local/bin:$PATH

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

autoload -Uz tetriscurses
autoload -Uz edit-command-line
zle -N edit-command-line

# Aliases
alias ls='ls --color=auto'
alias l='ls -lAh'
alias tm='tmux attach || tmux new-session'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias tetris=tetriscurses

export EDITOR=nvim
export ANDROID_HOME=~/Android/Sdk

## VI-Mode ##
bindkey -v

# Edit line in vim using space
bindkey -M vicmd ' ' edit-command-line

# Change cursor shape for different vi modes.
zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

echo -ne '\e[5 q' # Use beam shape cursor on startup.
precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Theme
MNML_INFOLN=(mnml_err mnml_jobs mnml_uhp)
MNML_MAGICENTER=()
source /usr/share/zsh/plugins/theme-minimal/minimal.zsh

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
