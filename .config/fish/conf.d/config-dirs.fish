set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share

set -gx CARGO_HOME "$XDG_DATA_HOME"/cargo
set -gx CUDA_CACHE_PATH "$XDG_CACHE_HOME"/nv
set -gx GNUPGHOME "$XDG_DATA_HOME"/gnupg
set -gx GOPATH "$XDG_DATA_HOME"/go
set -gx GRADLE_USER_HOME "$XDG_DATA_HOME"/gradle
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
set -gx JUPYTER_CONFIG_DIR "$XDG_CONFIG_HOME"/jupyter
set -gx KDEHOME "$XDG_CONFIG_HOME"/kde
set -gx MPLAYER_HOME "$XDG_CONFIG_HOME"/mplayer
set -gx MYSQL_HISTFILE "$XDG_DATA_HOME"/mysql_history
set -gx NODE_REPL_HISTORY "$XDG_DATA_HOME"/node_repl_history
set -gx _JAVA_OPTIONS -Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
set -gx RUSTUP_HOME "$XDG_DATA_HOME"/rustup
set -gx SQLITE_HISTORY $XDG_DATA_HOME/sqlite_history
