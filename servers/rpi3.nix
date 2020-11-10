{ config, pkgs, lib, ... }:

let
  hostname = "rpi3";
in
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
    firewall = {
      allowedTCPPorts = [
        config.services.grafana.port
        config.services.prometheus.exporters.node.port
        9090 ];
    };
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
    grafana = {
      enable = true;
      addr = "0.0.0.0";
      protocol = "http";
      auth.anonymous.enable = true;
      auth.anonymous.org_role = "Editor";

      provision = {
        enable = true;
        datasources = [
          {
            name = "Prometheus";
            isDefault = true;
            type = "prometheus";
            url = "http://localhost:9090";
          }
        ];
      };
    };
    openssh = {
      enable = true;
      allowSFTP = false;
      passwordAuthentication = false;
    };
    prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [
            {
              targets = [
                "localhost:9090"
              ];
            }
          ];
        }
        {
          job_name = "node";
          static_configs = [
            {
              targets = [
                "localhost:9100"
              ];
            }
          ];
        }
      ];

      exporters.node = {
        enable = true;
        enabledCollectors = [ "cpu" "filesystem" "loadavg" "systemd" ];
      };
    };
  };

  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keyFiles = [ ~/.ssh/id_rsa.pub ];
  };
}
