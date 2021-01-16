{ config, ... }:
let

  prometheus_client_port = 9273;

in

{
  networking.firewall.allowedTCPPorts = [
    config.services.mosquitto.port
    prometheus_client_port
  ];

  services.mosquitto = {
    enable = true;
    host = "0.0.0.0";

    allowAnonymous = true;
    users = {};

    aclExtraConf = ''
      topic readwrite #
    '';
  };

  services.telegraf = {
    enable = true;
    extraConfig = {
    inputs.mqtt_consumer = {
      servers = [ "tcp://127.0.0.1:${toString config.services.mosquitto.port}" ];
      topics = [ "tele/+/SENSOR" ];
      data_format = "json";
    };

    outputs.prometheus_client = {
      listen = ":${toString prometheus_client_port}";
      metric_version = 2;
      export_timestamp = true;
      expiration_interval = "5m";
    };
  };
  };
}
