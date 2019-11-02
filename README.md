# Anton

A Packer template for a PC Engines APU2 router running OpenWRT.

## Prerequisites

- [Packer] 1.4.4
- [QEMU] 4.1.0

Other versions of the packages listed above will likely work; these are just the ones that I use.

To use KVM acceleration, you will need to add your user to the `kvm` group:

```console
sudo usermod -G kvm -a $(whoami)
```

## Directions

Assuming that you use [pass] as your password store:

```console
packer build -var 'root_password=$(pass Anton/root_password)' template-openwrt.json
```

[Packer]: https://www.packer.io/
[QEMU]: https://www.qemu.org/
[pass]: https://www.passwordstore.org/
