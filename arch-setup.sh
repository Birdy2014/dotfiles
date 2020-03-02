declare -a pkglist

pkglist=(
    # terminal
    "rxvt-unicode-truecolor"
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
    "xorg-xsetroot"

    # other applications
    "neovim"
    "nerd-fonts-complete"
    "firefox"
    "ranger"
    "zathura"
    "git"
    "sudo"
    "python-pip"
    "clang"
    "ctags"
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

    # install spacevim
    curl -sLf https://spacevim.org/install.sh | bash

    # install pip modules
    pip3 install --user --upgrade pynvim
}

setup_dotfiles() {
    git clone --bare https://github.com/Birdy2014/dotfiles.git $HOME/.dotfiles
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
}

install_packages
if [ ! -d "$HOME/.dotfiles" ]; then
    setup_dotfiles
fi
