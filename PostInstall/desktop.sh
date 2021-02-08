# Installing package manager
cd ~
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si PKGBUILD
cd ~
rm -rf paru

# Install desktop and applications
paru -S alacritty feh flameshot gimp i3-gaps lxappearance lutris numlockx polybar rofi xorg-fonts-misc xorg-xinit

# Configuration
git clone https://github.com/JustinCardona/JustinCardona.github.io.git
cd JustinCardona.github.io/PostInstall
cp -r config/. ~
cp -r i3 ~/.config/
cp -r polybar ~/.config/
cp -r scripts ~/.config/
cd ~
rm -rf JustinCardona.github.io
chmod +x ~/.config/polybar/launch.sh

