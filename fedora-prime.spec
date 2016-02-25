Name:           fedora-prime
Version:        0.1
Release:        2%{?dist}
Summary:        Provides GPU (nvidia/intel) selection for NVIDIA optimus laptops
License:        GPLv2
URL:            https://github.com/paltas/FedoraPrime
Source0:        https://github.com/paltas/FedoraPrime/archive/master.zip
BuildArch:      noarch
BuildRequires:  systemd-units
Requires:       akmod-nvidia

%define fedora_prime_dir %{_sysconfdir}/fedora-prime

%description
A collection of shell scripts that makes it possible to use the
NVIDIA GPU on a Optimus Laptop. The switching is similar to
the feature provided by the nvidia-prime package in Ubuntu.
However, no such package has been made for other distributions.
This is exactly the functionality this package provide.

%prep
%autosetup -n FedoraPrime-master

%install
mkdir -p %{buildroot}%{fedora_prime_dir}
install -p -m 0644 xorg.conf %{buildroot}%{fedora_prime_dir}/
install -p -m 0755 xinitrc.nvidia %{buildroot}%{fedora_prime_dir}/

mkdir -p %{buildroot}%{_sbindir}
install -p -m 0755 fedora-prime-select %{buildroot}%{_sbindir}/

mkdir -p %{buildroot}%{_unitdir}
install -p -m 0644 fedora-prime.service %{buildroot}%{_unitdir}/

%post
systemctl enable fedora-prime.service

%preun
systemctl disable fedora-prime.service

%files
%doc README.md LICENSE
%{fedora_prime_dir}/xinitrc.nvidia
%{fedora_prime_dir}/xorg.conf
%{_sbindir}/fedora-prime-select
%{_unitdir}/fedora-prime.service

%changelog
* Sat Oct 17 2015 Bo Simonsen <bo@geekworld.dk> 0.1-2
- Git master ref e9ec3d6, backing up files before switching

* Thu Apr 16 2015 Bo Simonsen <bo@geekworld.dk> 0.1-1
- Initial version
