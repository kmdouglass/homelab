{
  network.description = "Infrastructure for local.kponics.com";

  rpi3 = {
    imports = [
      ./servers/rpi3.nix
      ./modules/grafana.nix
      ./modules/node-exporter.nix
      ./modules/prometheus.nix
    ];
  };
}
