# Kyle's Homelab

- [modules] Nix modules for configuring servers
- [router] A Packer template for provisioning a PC Engines APU2 router
- [servers] Configuration files for my home lab servers
- [speech-recognition] Tools to interface with a computer by voice

## Overview

### Services

My homelab currently consists of a network of a Raspberry Pi server and a PC Engines APU2 router.

The server software is managed and deployed using tools from [Nix]. In particular, the Raspberry Pi is running NixOS and I deploy to it using `nixops` from my laptop.

The router is running [OpenWrt]. This repository contains a Packer template to build a custom image with a minimal configuration prior to flashing it onto the router's SSD.

A [Traefik] proxy serves as the entrypoint into the homelab. Different services are accessed from the URLs `http://service.kponics.lan`, where the string `service` is replaced by the name of an actual service. `dnsmasq`, which is running on the router, is configured to redirect these requests to Traefik. Traefik then forwards the requests to the actual services.

The server and router are both monitored using [Prometheus] and [Grafana]. They are accessed inside the browser by navigating to http://prometheus.kponics.lan and http://grafana.kponics.lan, respectively.

### Interface

I use [Caster]/[Dragonfly]/[Kaldi] to control my laptop by voice. This repository contains tools for building a container image that contains this tool stack, as well as my custom grammars.

## Deployments

### Setup

Deployments are made using `nixops`. `nixops` requires that I first create a _deployment_, which is a logical grouping of machines and their corresponding configurations.

```console
nixops create homelab.nix -d homelab
```

The deployment only needs to be created once.

Nix is configured to use the Raspberry Pi as a remote builder to build packages for the aarch64 architecture when deploying from my x86_64 laptop. To do this, I added the following to `~/.config/nix/nix.conf`:

```
builders = ssh://root@rpi3 aarch64-linux
```

### Deploy

I run the following command to build and deploy software and configuration onto my homelab:

```console
nixops deploy -d homelab
```

After the deployment, I check my homelab's status with the command:

```console
nixops check -d homelab
```

[modules]: modules
[router]: router
[servers]: servers
[speech-recognition]: speech-recognition

[Caster]: https://github.com/dictation-toolbox/Caster
[Dragonfly]: https://github.com/dictation-toolbox/dragonfly
[Grafana]: https://grafana.com
[Kaldi]: https://github.com/daanzu/kaldi-active-grammar
[Nix]: https://nixos.org
[OpenWrt]: https://openwrt.org
[Prometheus]: https://prometheus.io
[Traefik]: https://traefik.io/
