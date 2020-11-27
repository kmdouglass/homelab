# Kyle's Homelab

- [modules] Nix modules for configuring servers
- [router] A Packer template for provisioning a PC Engines APU2 router
- [servers] Configuration files for my home lab servers
- [speech-recognition] Tools to interface with a computer by voice

## Overview

### Hardware

My homelab currently consists of a network of a Raspberry Pi server and PC Engines APU2 router.

The server software is managed and deployed using tools from [Nix]. In particular, the Raspberry Pi is running NixOS and I deploy to it using `nixops` from my laptop.

The router is running [OpenWrt]. This repository contains a Packer template to build a custom image with a minimumal configuration prior to flashing it onto the router's SSD.

The server and router are both monitored using [Prometheus] and [Grafana].

### Interface

I use [Caster]/[Dragonfly]/[Kaldi] to control my laptop by voice. This repository contains tools for building a container image that contains this tool stack, as well as my custom grammars.

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
