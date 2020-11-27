{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
  ];

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "cpu" "filesystem" "loadavg" "systemd" ];
  };
}
