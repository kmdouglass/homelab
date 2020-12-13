{ ... }:
let

  staticConfigOptions = {
    entryPoints.web.address = ":80";
  };

  dynamicConfigOptions = {
    http.routers = {
      router-grafana = {
        rule = "Host(`grafana.kponics.lan`)";
        service = "grafana";
      };

      router-prometheus = {
        rule = "Host(`prometheus.kponics.lan`)";
        service = "prometheus";
      };
    };

    http.services = {
      grafana.loadBalancer.servers = [ { url = "http://rpi3.kponics.lan:3000"; } ];
      prometheus.loadBalancer.servers = [ { url = "http://rpi3.kponics.lan:9090";  }  ];
    };
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
