{
  deployment.targetHost = "rpi3";

  network.description = "Infrastructure for local.kponics.com";

  rpi3 = { config, ...}: {
    imports = [
      ./servers/rpi3.nix
    ];
  };
}
