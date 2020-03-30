declare -a pkglist

pkglist=(
    # terminal
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
    [ "$EUID" -eq 0 ] && echo "Don't run this script as root" && exit 1
    [ ! -e "/usr/bin/sudo" ] && echo "please install sudo" && exit 1

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

    # install pip modules
    pip3 install --user --upgrade pynvim
    
    # install custom packages
    cd ~/pkgs
    for pkgname in *; do
        mkdir /tmp/$pkgname
        cp ~/pkgs/$pkgname /tmp/$pkgname/PKGBUILD
        cd /tmp/$pkgname
        makepkg -si
    done
}

setup_dotfiles() {
    git clone --bare https://github.com/Birdy2014/dotfiles.git $HOME/.dotfiles
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
}

install_packages
if [ ! -d "$HOME/.dotfiles" ]; then
    setup_dotfiles
fi
