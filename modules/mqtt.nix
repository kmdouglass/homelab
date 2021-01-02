{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [ config.services.mosquitto.port ];

  services.mosquitto = {
    enable = true;
    host = "0.0.0.0";

    allowAnonymous = true;
    users = {};

    aclExtraConf = ''
      topic readwrite #
    '';
  };
}
