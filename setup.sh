# User information
clear
read -p "Enter the host name: " host
read -p "Enter your name: " name
read -p "Enter your region: " region
read -p "Enter your zone: " zone

clear
PS3='Choose your CPU brand by entering a number: '
select processor in intel amd other
do
    break
done

clear
PS3='Choose your GPU brand by entering a number: '
select graphics in nvidia amd other
do
    break
done

# Host configuration
ln -sf /usr/share/zoneinfo/"$region"/"$zone" /etc/localtime
hwclock --systohc --utc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "$host" > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$host.localdomain\t$host"> /etc/hosts
clear
echo "Set a password for the root user (admin)"
passwd

# Install packages
pacman -S --noconfirm base-devel linux-headers grub efibootmgr sudo vim git networkmanager pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack pulseaudio-lirc pulseaudio-zeroconf xorg 
echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Syyy

# CPU configuration
if [ "$processor" = "intel" ]
then
    sudo pacman -S --noconfirm intel-ucode
elif [ "$processor" = "amd" ]
then
    sudo pacman -S --noconfirm amd-ucode
fi

# GPU configuration
if [ "$graphics" = "nvidia" ]
then
    sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
elif [ "$graphics" = "amd" ]
then
    sudo pacman -S --noconfirm lib32-mesa vulkan-radeon lib32-vulkan-radeon
fi

# Desktop configuration
sudo pacman -S --noconfirm vulkan-icd-loader lib32-vulkan-icd-loader xorg-fonts-misc python-pip sddm i3-wm lxappearance texlive-core dmenu rofi terminator feh

# Grub configuration
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable services
systemctl enable NetworkManager.service
systemctl enable sddm.service
systemctl enable sshd.service
# User configuration
useradd -mG wheel "$name"
clear
echo "Set a password for your user"
passwd "$name"
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers
######
cd /home/$name
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si PKGBUILD
sudo pacman -S --noconfirm flameshot nautilus code gimp shotcut blender discord firefox
yay -S polybar oreo-cursors-git numix-icon-theme-git vertex-themes chili-sddm-theme bitwarden vlc xournal
read -p "Change the current SDDM theme to chili. Afterwards go to lxappearance to change system themes."
sudo vim /usr/lib/sddm/sddm.conf.d/default.conf
cd /home/$name/JustinCardona.github.io
cp -a PostInstall/. ~/.config
cd /etc
sudo git clone https://github.com/ChrisTitusTech/firewallsetup.git
cd firewallsetup
chmod +x firewall
sudo ./firewall
