{ config, pkgs, lib, ... }:
{
  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_5_6;
    kernelParams = ["cma=256M"];
    loader.grub.enable = false;
    loader.raspberryPi = {
      enable = true;
      firmwareConfig = "gpu_mem=256";
      uboot.enable = true;
      version = 3;
    };
  };

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

  networking.hostName = "rpi3";

  openssh = {
    enable = true;
    allowSFTP = false;
    passwordAuthentication = false;
  };

  # Use 1GB of additional swap memory in order to not run out of memory
  # when installing lots of things while running other things at the same time.
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keyFiles = [ ~/.ssh/id_rsa.pub ];
  };
}
