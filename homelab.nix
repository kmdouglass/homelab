{
  network.description = "Infrastructure for kponics.lan";

  rpi3 = {
    imports = [
      ./servers/rpi3.nix
      ./modules/grafana.nix
      ./modules/node-exporter.nix
      ./modules/prometheus.nix
    ];
  };
}
