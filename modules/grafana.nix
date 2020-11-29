{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ config.services.grafana.port ];

  services.grafana = {
    enable = true;
    addr = "0.0.0.0";
    protocol = "http";
    auth.anonymous.enable = true;
    auth.anonymous.org_role = "Editor";
    domain = "grafana.kponics.lan";
    rootUrl = "http://grafana.kponics.lan";

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
}
