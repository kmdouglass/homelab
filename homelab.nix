{
  network.description = "Infrastructure for kponics.lan";

  rpi3 = {
    imports = [
      ./servers/rpi3.nix
      ./modules/grafana.nix
      ./modules/mqtt.nix
      ./modules/node-exporter.nix
      ./modules/prometheus.nix
      ./modules/traefik.nix
    ];
  };
}
