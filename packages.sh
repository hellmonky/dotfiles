#!/usr/bin/env bash
# install packages for startup need su

# install minimal xorg support
echo -e "start install xorg ...\n" >&2
pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr
echo -e "install xorg successful :)\n" >&2
# install cmd basic tools
echo -e "start install basic cmd tools ...\n" >&2
pacman -S --noconfirm git zsh wget curl htop tmux neofetch bat jq
echo -e "install basic cmd tools successful :)\n" >&2
# install gui basic compotents
echo -e "start install i3 components ...\n" >&2
pacman -S --noconfirm i3 i3blocks rofi dunst picom alacritty arc-gtk-theme paper-icon-theme feh xautolock
echo -e "install i3 components successful :)\n" >&2
# intall basic driver support
echo -e "start install hardware-dependency tools ...\n" >&2
pacman -S --noconfirm alsa-utils pulseaudio fontconfig
echo -e "install hardware-dependency tools successful :)\n" >&2
# install input tools
echo -e "start install fcitx5 ...\n" >&2
pacman -S --noconfirm fcitx5 fcitx5-gtk fcitx5-qt fcitx5-chinese-addons
echo -e "start install fcitx5 successful :)\n" >&2
# install basic fonts support
pacman -S --noconfirm ttf-font-awesome adobe-source-sans-pro-fonts adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
# install yay, notice for manjaro is direct but for archlinux, you need to setup 3rd source
pacman -S --noconfirm yay
