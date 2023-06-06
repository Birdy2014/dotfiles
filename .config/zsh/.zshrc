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
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias tetris=tetriscurses
alias gap='git add -p'
alias rm='rm -I'
alias cp='cp -i'

if [[ ! -z "$NVIM" ]]; then
    alias nvim='nvim --server $NVIM --remote'
fi

# Variables
export MANPAGER='nvim +Man!'
export LESS='--mouse -r'

# Functions
function set_terminal_title() {
    echo -en "\e]2;$@\a"
}

## VI-Mode ##
bindkey -v
KEYTIMEOUT=1

# Edit line in vim using space
bindkey -M vicmd ' ' edit-command-line

# Delete chars with backspace
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
_set-cursor-shape-for-keymap() {
    local shape=0
    case "$1" in
        main)       shape=5;;
        viins)      shape=5;; # vi insert: beam
        isearch)    shape=5;; # inc search: beam
        command)    shape=5;; # read a command name: beam
        vicmd)      shape=2;; # vi cmd: block
        visual)     shape=2;; # vi visual mode: block
        viopp)      shape=0;; # vi operator pending mode: block
    esac
    printf $'\e[%d q' "$shape"
}

zle-keymap-select() {
    _set-cursor-shape-for-keymap "${KEYMAP}"
}
zle -N zle-keymap-select

_set-cursor-shape-for-keymap main
precmd() {
    _set-cursor-shape-for-keymap main
    set_terminal_title zsh - $(pwd)

    if [[ -z "$NEW_LINE_BEFORE_PROMPT" ]]; then
        NEW_LINE_BEFORE_PROMPT=1
    else
        echo
    fi
}

alias clear='unset NEW_LINE_BEFORE_PROMPT; clear'

preexec() {
    _set-cursor-shape-for-keymap main
    set_terminal_title "$2"
}

# Incremental search
bindkey '^r' history-incremental-search-backward

# Theme
SPACESHIP_USER_SHOW=always
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_SUDO_SHOW=true
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_EXIT_CODE_SYMBOL=''

SPACESHIP_PROMPT_ORDER=(
    user           # Username section
    dir            # Current directory section
    host           # Hostname section
    git            # Git section (git_branch + git_status)
    venv           # virtualenv section
    conda          # conda virtualenv section
    gnu_screen     # GNU Screen section
    exec_time      # Execution time
    line_sep       # Line break
    jobs           # Background jobs indicator
    exit_code      # Exit code section
    #sudo           # Sudo indicator
    char           # Prompt character
)

# Autosuggestion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Plugins
[ ! -f $ZDOTDIR/antigen.zsh ] && curl -L git.io/antigen > $ZDOTDIR/antigen.zsh
typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/antigen.zsh)
source $ZDOTDIR/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle jimhester/per-directory-history
antigen theme spaceship-prompt/spaceship-prompt

antigen apply
