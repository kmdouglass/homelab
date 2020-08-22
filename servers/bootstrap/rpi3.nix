{ config, pkgs, lib, ... }:
{
  boot = {
    cleanTmpDir = true;
    # There is a bug in NixOS that prohibits the use of kernel versions >= 5.7
    # https://github.com/NixOS/nixpkgs/issues/82455#issuecomment-650654111
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

  networking.hostName = "CHANGEME";

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
  };

  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  users = {
    users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCv8mocl8NEN9IPw3vUua/IQfkMB2IMYuW9ExlX7Io1kx7lxnajujk4hhwU3RHFj6IS2PWFnH95D0fNp/JbdSsxcTo2pSz5lr2ngqkorVCtHe/xBYfb2RCY9dOD9EOWFYguQnR2RwGAOvQUY/yFkGT9Nivk26Wdeppe0amGHYJRZCaHHoCkRsV7p+oVfhoBYeZT4l3k8UyI5HzrqqEN6ipF5n/PU1/IX5EmMnFF9hw4zMefst1y/FbK1p2tTdbdf9GZevxuzK33wxm79prvKkbRuA5wlkWlC7elk0Ss8ADrLpgPj/caRXBVaOWtpxYQRvqZ6BBaHc+58ZxTDYann2d3thD0fXxIVpdc4FN4u/lZppV8P7nr6ZyNs5RUw7uqrEMT6JQwmuHNw0JVs7j1vCG0HFmAp7h5vjuMBKUQWkVvmPf/qqufuVeBl5YFfOpMcCCe1wJoBgKDnDhmndacOzhNXrQyJFav0TVx63uzZlXMdpY3qaLSbQ7HCmUUnowaMGnfl35gzuaxecErxpVYZqo7qeml4uLKIJj4//nmgv/8PgERe5aWXlebDDRFZN41H2vx5ELHKUwB8i/5IKXsta7UQOnnj2SxZULNuGi9Cwf9Ern07c7VdNqosE0g/M5daeJYurd1LAGn3bQ5TATVilGPpFI87cbkRS0lsUniylprQw== kyle.douglass@protonmail.com" ];
  };
}
