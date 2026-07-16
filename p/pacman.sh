# Downgrade softwares
sudo pacman -U \
  /var/cache/pacman/pkg/bluez-5.86-6-x86_64.pkg.tar.zst \
  /var/cache/pacman/pkg/bluez-libs-5.86-6-x86_64.pkg.tar.zst \
  /var/cache/pacman/pkg/bluez-utils-5.86-6-x86_64.pkg.tar.zst
sudo systemctl restart bluetooth
systemctl --user restart pipewire pipewire-pulse wireplumber

vim /etc/pacman.conf
# IgnorePkg = bluez*