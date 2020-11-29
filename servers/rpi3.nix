{ config, pkgs, lib, ... }:

let
  hostname = "rpi3";
in
{
  boot = {
    cleanTmpDir = true;
    extraModulePackages = [];
    initrd = {
      availableKernelModules = [
        "bcm2835_dma"
        "i2c_bcm2835"
        "usbhid"
        "vc4"
      ];
      kernelModules = [];
    };
    kernelParams = ["cma=32M"];
    loader.generic-extlinux-compatible.enable = true;
    loader.grub.enable = false;
    loader.raspberryPi = {
      enable = true;
      firmwareConfig = "gpu_mem=256";
      uboot.enable = true;
      version = 3;
    };
  };

  deployment.targetHost = hostname;

  documentation.nixos.enable = false;

  environment.systemPackages = with pkgs; [
    raspberrypi-tools
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = hostname;
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  # Required to build on x86_64 machine
  nixpkgs.system = "aarch64-linux";

  services = {
    openssh = {
      enable = true;
      allowSFTP = false;
      passwordAuthentication = false;
    };
  };

  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keyFiles = [ ~/.ssh/id_rsa.pub ];
  };
}
