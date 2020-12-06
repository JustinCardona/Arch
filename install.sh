# Preparation
pacman -Syyy
timedatectl set-ntp true

# Disk Preparation
disks=$(lsblk -p -n -l -o NAME -e 7,11)
PS3='Enter the device name you want to install to: '
select dev in ${disks}
do
    break
done
wipefs -a "$dev"
printf "g\nn\n\n\n+256M\nt\n1\nn\n\n\n\nw\n" | sudo fdisk "$dev"
efip=`lsblk $disk -p -n -l -o NAME -e 7,11 | sed -n 2p`
rootp=`lsblk $disk -p -n -l -o NAME -e 7,11 | sed -n 3p`
mkfs.fat -F32 "$efip"
mkfs.ext4 "$rootp"
mount "$rootp" /mnt
mkdir /mnt/boot
mount "$rootp" /mnt/boot

# Installation
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
curl -L JustinCardona.github.io/setup.sh > setup.sh
mv setup.sh /mnt
arch-chroot /mnt sh setup.sh
umount -a
reboot