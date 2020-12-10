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
pacman -S base-devel linux-headers grub efibootmgr sudo vim git networkmanager pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack pulseaudio-lirc pulseaudio-zeroconf xorg 
clear
read -p "Include multilib so that you can download proprietary GPU drivers"
vim /etc/pacman.conf
pacman -Syyy

# CPU configuration
if [ "$processor" = "intel" ]
then
    sudo pacman -S intel-ucode
elif [ "$processor" = "amd" ]
then
    sudo pacman -S amd-ucode
fi

# GPU configuration
if [ "$graphics" = "nvidia" ]
then
    sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
elif [ "$graphics" = "amd" ]
then
    sudo pacman -S lib32-mesa vulkan-radeon lib32-vulkan-radeon
fi

# Desktop configuration
sudo pacman -S vulkan-icd-loader lib32-vulkan-icd-loader xorg-fonts-misc python-pip sddm i3-wm lxappearance texlive-core dmenu rofi terminator feh

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