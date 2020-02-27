declare -a pkglist

pkglist=(
    # terminal
    "rxvt-unicode"
    "urxvt-perls"
    "zsh"
    "zsh-syntax-highlighting"

    # desktop
    "xorg-server"
    "bspwm"
    "sxhkd"
    "polybar"
    "rofi"
    "picom"
    "lightdm"
    "lightdm-gtk-greeter"
    "light-locker"

    # vim
    "gvim"
    "vim-airline"
    "vim-ale"
    "vim-align"
    "vim-colorsamplerpack"
    "vim-ctrlp"
    "vim-easymotion"
    "vim-indent-object"
    "vim-spell-de"
    "vim-supertab"
    "vim-surround"
    "vim-syntastic"
    "vim-workspace"

    # other applications
    "nerd-fonts-complete"
    "firefox"
    "ranger"
    "zathura"
    "git"
    "sudo"
)

install_packages() {
    if [ ! -e "/usr/bin/sudo" ]; then
        echo "please install sudo"
        exit 1
    fi

    echo "Updating system..."
    sudo pacman -Syu

    if [ ! -e "/usr/bin/git" ]; then
        echo "Installing git..."
        sudo pacman -S git
    fi

    if [ ! -e "/usr/bin/yay" ]; then
        echo "Installing yay..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si
    fi

    # install packages
    echo "installing packages..."
    yay --noconfirm --needed -S ${pkglist[*]}
}

setup_dotfiles() {
    git clone --bare https://github.com/Birdy2014/dotfiles.git $HOME/.dotfiles
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
}

install_packages
if [ ! -d "$HOME/.dotfiles" ]; then
    setup_dotfiles
fi
