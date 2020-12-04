# README

## info
A i3(i3-gaps) dotfile collection for manjaro distro bootstrap.

## dotfiles structure
```shell
.
├── README.md
├── bin
│   └── i3blocks-contrib(submodule)
├── config
│   ├── alacritty
│   ├── dunst
│   ├── fcitx5
│   ├── htop
│   ├── i3
│   ├── i3blocks
│   ├── picom
│   └── rofi
├── home
│   ├── Xresources
│   ├── aliases
│   ├── bash_profile
│   ├── bashrc
│   ├── dircolors
│   ├── exports
│   ├── functions
│   ├── oh-my-zsh(submodule)
│   ├── tmux.conf
│   ├── wgetrc
│   ├── xinitrc
│   ├── zsh
│   └── zshrc
├── install.sh
├── packages.sh
└── resources
    └── fonts
```

home:		default ln to ~
config:		default ln to ~/.config
bin:		default ln to ~/.local/bin
resources:	binaries or fonts etc, need to install into system
packages.sh:	relay on specical distro, install basic software
install.sh:	install this dotfile to current user home


## how to use
(1) clone to localhost
```shell
git clone https://github.com/hellmonky/dotfiles.git && cd dotfiles
git submodule update --init --recursive
```

need su authorition to do the process, and failure will need manully startup again.

(2) install dotfiles with install.sh
```shell
./install.sh -i
```
this action need su authorition to do some basic compents install, and will do everything to prepare work only in your $HOME.

(3) reboot
because we do a lot of install and setup, reboot is very necessary, so reboot and enjoy :)

## how to modify
