# Installing package manager
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si PKGBUILD
cd ~
rm -rf yay

# Install desktop and applications
yay -S bitwarden-cli brave-bin breeze-default-cursor-theme breeze-gtk-theme discord feh flameshot i3-gaps libreoffice numlockx os-prober picom polybar rofi terminator pulseaudio xorg xorg-xinit 

# Configuration
git clone https://github.com/JustinCardona/JustinCardona.github.io.git
cd JustinCardona.github.io/PostInstall
cp -r config/. ~
cp -r i3 ~/.config/
cp -r polybar ~/.config/
cp -r scripts ~/.config/
sudo cp numlock/numlock /usr/local/bin/numlock
sudo cp numlock/numlock.service /etc/systemd/system/numlock.service
sudo chmod +x /usr/local/bin/numlock
systemctl enable numlock.service
cd ~
rm -rf JustinCardona.github.io
chmod +x ~/.config/polybar/launch.sh

# Grub
os-prober
grub-mkconfig

# Start window manager
startx
