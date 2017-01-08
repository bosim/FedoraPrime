# Fedora Prime

A collection of shell scripts that makes it possible to use the NVIDIA GPU on a Optimus Laptop. The switching is similar to the feature provided by the nvidia-prime package in Ubuntu. However, no such package has been made for other distributions. This is exactly the functionality this package provide.

## Background

In 2012, Linus Torvalds gave his famous talk at the University of Helsinki where he gave NVIDIA the middle finger due to lack of support of, in particular, device drivers for the optimus laptops. Not long after NVIDIA provided both documentation for developers of the nouveau project (an open-source implementation of the NVIDIA drivers) and partially support for switching between the Intel and NVIDIA drivers. Canonical then began working on their nvidia-prime package that should make the switching simple, basically just providing one command prime-select for switching, taking either nvidia or intel as parameter. The downside is that you need to logout for the switching to happen. The same limitations are there for this package.

## Installation

Supported operating systems: Fedora **22**, Fedora **23**.

* Install NVIDIA drivers from [RPM Fusion](http://rpmfusion.org/) repository (you need to enable it first, if you haven't already, follow [instruction on the site](http://rpmfusion.org/Configuration)):
  ```sh
  sudo dnf install kernel-devel akmod-nvidia
  # for 32 bit compatibility also install: xorg-x11-drv-nvidia-libs.i686
  ```

* Make sure that `nouveau` (an open source NVIDIA driver) is blacklisted:
  ```sh
  sudo mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
  sudo dracut -f /boot/initramfs-$(uname -r).img $(uname -r)
  ```

* Install FedoraPrime:
  ```sh
  git clone https://github.com/bosim/FedoraPrime.git
  cd FedoraPrime
  sudo make install
  # to uninstall, simply run:
  # sudo make uninstall
  ```

## Usage

To switch a graphic card, you need to run the following command:
```sh
# switch to nvidia:
sudo fedora-prime-select nvidia
# switch to intel:
sudo fedora-prime-select intel
```

Now all you have to do is logout and then login back and you should be using a desired graphic card. You can verify it by running `glxinfo | grep 'OpenGL renderer string'` for example.


## Known bugs

* If you are in Intel mode and your system has been suspended, changing to NVIDIA may result in blank screen. Therefore you may need to reboot your machine. This is due to limitations of gdm (Ubuntu has patched gdm to run a script similar to xinitrc.nvidia, but these changes are not available upstream, thanks Ubuntu). We set the intel card active during reboot, so we should always be able to recover from the blackscreen by rebooting.

## Author

* Bo Simonsen bo@geekworld.dk
