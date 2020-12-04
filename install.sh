#!/usr/bin/env bash

# color setup
blue='\e[1;34m'
red='\e[1;31m'
white='\e[0;37m'

# install path
INSTALL_PATH=$HOME
# dotfiles path
dotfiles_repo_dir=$(pwd)
# backup path
backup_dir="$INSTALL_PATH/.dotfiles.orig"


# operation dirs
# ~/
dotfiles_home_dir=(aliases asoundrc bash_profile bashrc dircolors exports oh-my-zsh functions tmux.conf wgetrc xinitrc Xresources zsh zshrc)
# ~/.config/
dotfiles_config_dir=(alacritty dunst fcitx5 feh htop i3 i3blocks picom rofi)

# Print usage message.
usage() {
    local program_name
    program_name=${0##*/}
    cat <<EOF
Usage: $program_name [-option]

Options:
    --help    Print this message
    -i        Install all config
    -r        Restore old config
EOF
}

# 调用脚本安装必要的软件依赖
need_auto_install() {
    sudo sh ${dotfiles_repo_dir}/packages.sh
}


# confirm home path
confirm_home() {
    echo -e "${red} current install path is: ${INSTALL_PATH}\n" >&2
    echo -e "${blue} if the install path is not correct, please input a valid path you wanto to install to, or just enter \n" >&2
    read -p "Enter install full path:" new_path
    if [ -z $new_path ]
    then
        echo -e "install to default path, continue...."
    else
        echo -e "${blue} path to install is: ${new_path} , please input yes|y to continue ...\n" >&2
        read is_confirm
        if [ $is_confirm == 'yes' ] ||  [ $is_confirm == 'y' ]
        then
            echo "confirmed"
            INSTALL_PATH=${new_path}
        else
            exit 0
        fi
    fi
}


# backup original config
backup_orign() {
    if ! [ -f "$backup_dir/check-backup.txt" ]; then
        mkdir -p "$backup_dir/.config"
        cd "$backup_dir" || exit
        touch check-backup.txt

        # Backup to ~/.dotfiles.orig
        for dots_home in "${dotfiles_home_dir[@]}"
        do
            env cp -rf "${INSTALL_PATH}/${dots_home}" "$backup_dir" &> /dev/null
        done

        # Backup some folder in ~/.config to ~/.dotfiles.orig/.config
        for dots_xdg_conf in "${dotfiles_xdg_config_dir[@]//./}"
        do
            env cp -rf "${INSTALL_PATH}/.config/${dots_xdg_conf}" "$backup_dir/.config" &> /dev/null
        done

        # Backup again with Git.
        if [ -x "$(command -v git)" ]; then
            git init &> /dev/null
            git add -u &> /dev/null
            git add . &> /dev/null
            git commit -m "Backup original config on $(date '+%Y-%m-%d %H:%M')" &> /dev/null
        fi

        # Output.
        echo -e "${blue}Your config is backed up in ${backup_dir}\n" >&2
        echo -e "${red}Please do not delete check-backup.txt in .dotfiles.orig folder.${white}" >&2
        echo -e "It's used to backup and restore your old config.\n" >&2
    fi
}

# install home to ~
install_home() {
    for dots_home in "${dotfiles_home_dir[@]}"
    do
        env rm -rf "${INSTALL_PATH}/.${dots_home}"
        env ln -fs "$dotfiles_repo_dir/home/${dots_home}" "${INSTALL_PATH}/.${dots_home}"
    done
}

# install config to ~/.config
install_config() {
    mkdir -p "${INSTALL_PATH}/.config"
    for dots_conf in "${dotfiles_config_dir[@]}"
    do
        env rm -rf "${INSTALL_PATH}/.config/${dots_conf[*]//./}"
        env ln -fs "$dotfiles_repo_dir/config/${dots_conf}" "${INSTALL_PATH}/.config/${dots_conf}"
    done
}

# install bin to ~/.local/bin
install_bin() {
    mkdir -p "${INSTALL_PATH}/.local/bin"
    for bins in "$(ls $dotfiles_repo_dir/bin)"
    do
        env rm -rf "${INSTALL_PATH}/.local/${bins[*]//./}"
        env ln -fs "${dotfiles_repo_dir}/bin/${bins}" "${INSTALL_PATH}/.local/bin/${bins}"
    done
}

# fonts 解压安装
install_fonts() {
    font_sour_path="${dotfiles_repo_dir}/resources/fonts"
    font_dest_path="${INSTALL_PATH}/.local/share/fonts"
    mkdir -p $font_dest_path
    fonts=$(ls $font_sour_path)
    for font in $fonts
    do
        tar -zxf "${font_sour_path}/${font}" -C $font_dest_path
    done
    fc-cache -fv
}

# 安装脚本
install_dotfiles() {
    # install packages by current config
    need_auto_install

    # confirm current working home
    confirm_home

    # Backup config.
    backup_orign

    # Install home.
    install_home

    # install config.
    install_config

    # install bin.
    install_bin

    # install fonts
    install_fonts
    
    # call back show
    echo -e "${blue}New dotfiles is installed!\n${white}" >&2
    echo "There may be some errors when Terminal is restarted." >&2
    echo "Please read carefully the error messages and make sure all packages are installed. See more info in README.md." >&2
    echo "Note that the author of this dotfiles uses dev branch in some packages." >&2
    echo -e "If you want to restore your old config, you can use ${red}./install.sh -r${white} command." >&2
}

uninstall_dotfiles() {
    if [ -f "$backup_dir/check-backup.txt" ]; then
        for dots_home in "${dotfiles_home_dir[@]}"
        do
            env rm -rf "$HOME/${dots_home}"
            env cp -rf "$backup_dir/${dots_home}" "$HOME/" &> /dev/null
            env rm -rf "$backup_dir/${dots_home}"
        done

        for dots_xdg_conf in "${dotfiles_config_dir[@]//./}"
        do
            env rm -rf "$HOME/.config/${dots_xdg_conf}"
            env cp -rf "$backup_dir/.config/${dots_xdg_conf}" "$HOME/.config" &> /dev/null
            env rm -rf "$backup_dir/.config/${dots_xdg_conf}"
        done

        # Save old config in backup directory with Git.
        if [ -x "$(command -v git)" ]; then
            cd "$backup_dir" || exit
            git add -u &> /dev/null
            git add . &> /dev/null
            git commit -m "Restore original config on $(date '+%Y-%m-%d %H:%M')" &> /dev/null
        fi
    fi

    if ! [ -f "$backup_dir/check-backup.txt" ]; then
        echo -e "${red}You have not installed this dotfiles yet.${white}" >&2
        exit 1
    else
        echo -e "${blue}Your old config has been restored!\n${white}" >&2
        echo "Thanks for using my dotfiles." >&2
        echo "Enjoy your next journey!" >&2
    fi

    env rm -rf "$backup_dir/check-backup.txt"
}

main() {
    case "$1" in
        ''|-h|--help)
            usage
            exit 0
            ;;
        -i)
            install_dotfiles
            ;;
        -r)
            uninstall_dotfiles
            ;;
        *)
            echo "Command not found" >&2
            exit 1
    esac
}

main "$@"

