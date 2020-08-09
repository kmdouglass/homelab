# Bootstrap configuration files

These files are used to bootstrap a new server.

## Raspberry Pi 3B+

The first time a new image is booted on the Pi, you will be dumped into a terminal prompt. First set the root password:

```console
sudo passwd
```

This will allow you to login as root.

```console
su
```

As root, download the configuration to bootstrap the Pi:

```console
curl https://raw.githubusercontent.com/kmdouglass/homelab/master/servers/bootstrap/rpi3.nix > /etc/nixos/configuration.nix
```

Edit the configuration file and  change the hostname to the desired value:

```console
nano /etc/nixos/configuration.nix
```

Finally, build this configuration and switch to it:

```console
sudo nixos-rebuild switch
nix-collect-garbage -d
nixos-rebuild switch # removes now unused boot loader entries
reboot
```

From here, you should have SSH to the root account via a password and may proceed to further configure the server.
