{ ... }:
let

  staticConfigOptions = {
    entryPoints.web.address = ":80";
  };

  dynamicConfigOptions = {
    http.routers.router-grafana = {
      rule = "Host(`grafana.kponics.lan`)";
      service = "grafana";
    };

    services.grafana.loadBalancer.servers = [ { url = "http://rpi3.kponics.lan:3000"; } ];
  };

in

{
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.traefik = {
    enable = true;
    inherit staticConfigOptions;
    inherit dynamicConfigOptions;
  };
}
