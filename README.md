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

### Build the image

The `vars.json` file contains all the variables that are used by the provisioners with the
exception of secrets. (Secrets are passed to Packer via `-var` options.) Edit this file to
fine-tune the image.

Assuming that you use [pass] as your password store, run the following command to build the image:

```console
packer build -var-file=vars.json -var "root_password=$(pass Anton/root_password)" template-openwrt.json
```

### Test the image before flashing

**Warning: any changes made to the image at this point will persist onto the router.**

You may test the image before flashing it by launching it in a VM with QEMU:

```console
/usr/local/bin/qemu-system-x86_64 \
    -display gtk -m 512M \
    -device virtio-net \
	-device virtio-net,netdev=lan1 -netdev user,id=lan1,hostfwd=tcp::2222-:22
	-drive file=target/19.07.2/openwrt-19.07.2-x86-64-combined-ext4-final.img
```

You may now login in through the VNC console.

In addition, this will open port 2222 on your host and forward TCP traffic to the VM's SSH
port 22. This provides the option to test the image through SSH. However, by default OpenWRT's
firewall will block SSH traffic that enters through the WAN, so you will need to temporarily
disable the firewall from the VNC console to use it:

```console
/etc/init.d/firewall stop
```

### Flash the image

**Warning: make sure you use the device names in this section to avoid overwriting your
filesystem.**

When ready, copy the image onto a USB stick from your PC. Assuming that `sdX` is the device that
corresponds to your USB device:

```console
sudo dd status=progress if=/target/19.07.2/openwrt-19.07.2-x86-64-ext4-combined-final.img of=/dev/sdX bs=8M; sync
```

Next, insert the USB stick into the router that is powered off and connect it to your PC via serial
cable. Connect to the serial interface (here I assume that the device is `ttyUSB0`):

```console
 cu -l /dev/ttyUSB0 -s 115200
 ```
 
Power on the router. When prompted, press `F10` and boot from the USB stick. Once the image boots,
login and copy the image from the USB stick to the SSD of the router (here assumed to correspond to
devices `/dev/sdX` and `/dev/sdY`, respectively).

```console
dd if=/dev/sdX of=/dev/sdY bs=8M; sync
```

When finished, shutdown the router with the `poweroff` command, remove the USB stick, and power on
the router.

### Finalize the installation


In the serial console, login again to OpenWRT. Navigate to the directory defined by the
`post_flash_scripts_dir` in `vars.json` and run the `setup_post_flash.sh` script.

```console
./setup_post_flash.sh
```

Power down the router with the `poweroff` command. Exit the serial console on your PC with the `~.`
command. Install the router in its final destination, connect port `eth0` to the WAN.

## References

- [PC Engines]
- [Open Wrt]
- [Running OpenWrt in QEMU]

[Packer]: https://www.packer.io/
[QEMU]: https://www.qemu.org/
[pass]: https://www.passwordstore.org/
[PC Engines]: https://www.pcengines.ch/
[OpenWrt]: https://openwrt.org/
[Running OpenWrt in QEMU]: https://gist.github.com/extremecoders-re/f2c4433d66c1d0864a157242b6d83f67
