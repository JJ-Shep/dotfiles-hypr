#!/usr/bin/env bash
# Check root
if [ "$EUID" == 0 ]
  then echo "This script must be run as a standard user, otherwise configuration files will be installed in /root."
  exit
fi

# Install dotfiles
mkdir ~/.config 2>/dev/null
cp -r .config/* ~/.config/

install_aur () {
	if sudo pacman -Q | grep -q $1 ; then
		echo "$1 already installed, skipping."
	else
		mkdir -p ~/misc/clone
		cd ~/misc/clone
		git clone https://aur.archlinux.org/$1.git
		cd $1
		makepkg -si
		cd ~/
		rm misc/ -rf
	fi
}

# Install dependencies
sudo pacman -S wezterm firefox ttf-iosevka-nerd base-devel sddm dunst ttf-font-awesome cantarell-fonts pulseaudio-alsa pavucontrol swaylockd --needed
sudo systemctl enable sddm

# Install AUR packages
while true; do
read -p "Are you using Nvidia? (y/n) " yn
case $yn in
	y ) install_aur hyprland-nvidia;
		break;;
	n ) install_aur hyprland;
		break;;
	* ) echo "Invalid response.";;
esac
done

install_aur swww
install_aur waybar-hyprland-git
install_aur wofi
install_aur swaylock-effects-git

# Finish
echo "Installation complete."
