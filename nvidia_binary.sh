if [ $1 == "install" ]; then
	dnf install kernel-devel kernel-headers gcc dkms acpid	
	echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
	grub2-mkconfig -o /boot/grub2/grub.cfg
	dracut -f /boot/initramfs-$(uname -r).img $(uname -r)

$2 --accept-license --silent --no-x-check --no-nouveau-check --no-recursion --opengl-libdir=lib64/nvidia --opengl-prefix=/usr --x-library-path=lib64/nvidia --x-prefix=/usr --x-module-path=/usr/lib64/nvidia/xorg/modules --compat32-libdir=lib/nvidia --compat32-prefix=/usr   --force-selinux=yes


elif [ $1 == "remove" ]; then
	nvidia-installer --uninstall
	dnf reinstall -y xorg-\* mesa\*
fi