# History
HISTORY_BASE="$HOME/.config/zsh/history" # local history
HISTFILE="$HOME/.config/zsh/.zsh_history" # global history
HISTSIZE=100000
SAVEHIST=100000

setopt extended_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_ignore_space

# autoload
autoload -Uz tetriscurses
autoload -Uz edit-command-line
autoload -Uz compinit
zle -N edit-command-line

# tab completion
compinit
zstyle ':completion:*' menu select

# Aliases
alias ls='ls --color=auto'
alias l='ls -lAh'
alias tm='tmux new-session -A -s main'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias tetris=tetriscurses

## VI-Mode ##
bindkey -v
KEYTIMEOUT=1

# Edit line in vim using space
bindkey -M vicmd ' ' edit-command-line

# Delete chars with backspace
bindkey -v '^?' backward-delete-char

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
preexec() { echo -ne '\e[5 q' ;} # beam shape cursor after prompt

# Theme
MNML_INFOLN=(mnml_err mnml_jobs mnml_uhp)
MNML_MAGICENTER=()

# Plugins
[ ! -f ~/.config/zsh/antigen.zsh ] && curl -L git.io/antigen > ~/.config/zsh/antigen.zsh
typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/antigen.zsh)
source $ZDOTDIR/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle subnixr/minimal
antigen bundle jimhester/per-directory-history

antigen apply

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=buffer-empty # workaround for autosuggestion not disappearing with subnixr/minimal
