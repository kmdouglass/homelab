{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 9090 ];
  
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "localhost:9100"
              "router:9100"
            ];
          }
        ];
      }
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [
              "localhost:9090"
            ];
          }
        ];
      }
    ];
  };
}
