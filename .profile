#!/usr/bin/env bash

[ -d "$HOME/.local/bin" ] && [[ $PATH == *"$HOME/.local/bin"* ]] || export PATH=$HOME/.local/bin:$PATH
export EDITOR=nvim
setxkbmap -option caps:escape -variant nodeadkeys
