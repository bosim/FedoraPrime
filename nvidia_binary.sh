sysconfig_file='/etc/sysconfig/grub'
modprobe_file='/etc/modprobe.d/blacklist.conf'
blacklist_grub='rd.driver.blacklist=nouveau'
blacklist_modprobe='nouveau'
grep_grub=$(grep -o $blacklist_grub $sysconfig_path/grub)
grep_cmd=$(grep 'GRUB_CMDLINE_LINUX' $sysconfig_path/grub)
grep_modprobe=$(grep -o $blacklist_modprobe $modprobe_file)

modprobe_bak='blacklist.conf.fedora-prime.bak'

#remove and reinstall things to ensure everything is in its original state
clean() {
	#remove rpmfusion install
    dnf remove -y akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-libs
    dnf remove -y xorg-x11-drv-nvidia\*
    #reinstall xorg, just in case some files have been overwritten by previous installs
	dnf reinstall -y xorg-\* mesa\*
	rm -f $sysconfig_path/grub.nvidia
	cp $sysconfig_path/grub.fedora-prime.bak $sysconfig_path/grub
	
}

install() {
	dnf install kernel-devel kernel-headers gcc dkms acpid	
	
	if ! [[ $grep_modprobe ]]; then
		if [[ $modprobe_file ]]; then
			echo "Backing up original blacklist.conf"
			cp $modprobe_file $(modprobe_file).fedora-prime.bak
			echo "Adding nouveau to blacklist.conf"
			echo "blacklist nouveau" >> $modprobe_file
		fi
	fi

	# automatically write needed option to file
	if ! [[ $grep_grub ]]; then
		cp  $sysconfig_path/grub $sysconfig_path/grub.fedora-prime.bak
		cmdline="${grep_cmd::-1} rd.driver.blacklist=nouveau"\"
		sed "s/$grep_cmd/$cmdline/" $sysconfig_file > $sysconfig_path/grub.nvidia
		cp $sysconfig_path/grub.nvidia $sysconfig_file
				
	fi
	
	grub2-mkconfig -o /boot/grub2/grub.cfg
	dracut -f /boot/initramfs-$(uname -r).img $(uname -r)
	chmod +x binary_driver/NVIDIA-Linux-*.run
	binary_driver/NVIDIA-Linux-*.run --accept-license --silent --no-x-check --no-nouveau-check --no-recursion --opengl-libdir=lib64/nvidia --opengl-prefix=/usr --x-library-path=lib64/nvidia --x-prefix=/usr --x-module-path=/usr/lib64/nvidia/xorg/modules --compat32-libdir=lib/nvidia --compat32-prefix=/usr   --force-selinux=yes
}

if [ $1 == "install" ]; then
	clean			

elif [ $1 == "remove" ]; then
	nvidia-installer --uninstall
	dnf reinstall -y xorg-\* mesa\*
fi