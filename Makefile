INSTALL_DIR = /etc/fedora-prime

.PHONY: all install uninstall

all: install

install:
	mkdir -p $(INSTALL_DIR)
	cp ./xorg.conf.template $(INSTALL_DIR)/xorg.conf.template
	cp ./fedora-prime-select /usr/sbin/fedora-prime-select
	cp ./xinitrc.nvidia $(INSTALL_DIR)/xinitrc.nvidia
	cp ./gdm_display_setup.desktop $(INSTALL_DIR)/gdm_display_setup.desktop

uninstall:
	rm -rf $(INSTALL_DIR)
	rm -f /usr/sbin/fedora-prime-select
	rm -f /etc/X11/xinit/xinitrc.d/nvidia
	rm -f /usr/share/gdm/greeter/autostart/gdm_display_setup.desktop
