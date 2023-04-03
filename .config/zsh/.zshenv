[ -d "$HOME/.local/bin" ] && [[ $PATH == *"$HOME/.local/bin"* ]] || export PATH=$HOME/.local/bin:$PATH
export EDITOR=nvim
export VISUAL=nvim
export ANDROID_HOME="$HOME/Android/Sdk"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
