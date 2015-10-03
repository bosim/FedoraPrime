Fedora Prime
============

A collection of shell scripts that makes it possible to use the NVIDIA GPU on a Optimus Laptop. The switching
is similar to the feature provided by the nvidia-prime package in Ubuntu. However, no such package has been
made for other distributions. This is exactly the functionality this package provide. 

Background
----------

In 2012, Linus Torvalds gave his famous talk at the University of Helsinki where he gave NVidia the middle finger
due to lack of support of, in particular, device drivers for the optimus laptop. Not long after NVIDIA provided
both documentation for developers of the nouveau project (an open-source implementation of the NVIDIA drivers)
and partially support for switching between the Intel and NVIDIA drivers. Canonical then began working on their
nvidia-prime package that should make the switching simple, basically just providing one command `prime-select`
for switching, taking either nvidia or intel as parameter. The downside is that you need to logout for the
switching to happen. The same limitations are there for this package. 

Features
--------

The package provides two scripts, one for setting up the config files and one for doing the actual switching.
Since GDM relies on Wayland on Fedora 22, the switching is painless, just run:

    fedora-prime-select nvidia|intel

and logout/login, voila you are using the requested driver.

Usage
-----

On Fedora 22 (probably also 23) install the akmod-nvidia package from rpmfusion repository. Make sure the
kernel module is compiled. Put the following argument for the kernel in /boot/grub2/grub.cfg: 

    nouveau.modeset=0 rd.driver.blacklist=nouveau 

Run: 

    fedora-prime-init

Edit `/etc/fedora-prime/xorg.nvidia.conf` and add the right `BusID` (mine was `4:0:0`, yours is probably something
else. Find it using `lspci`)

Before restart, please run `fedora-prime-select` (nvidia or intel your choice), and everything should be working
after restart.

Author
------

* Bo Simonsen <bo.simonsen@gmail.com>

TODO
----

* BusID detection for xorg.nvidia.conf
* RPM package

