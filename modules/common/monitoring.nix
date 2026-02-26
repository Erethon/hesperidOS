{ config, hostConfig, ... }:
let
  ts_domain = "ts.erethon";
  node_domain = "node.${config.networking.hostName}.${ts_domain}";
in
{
  config = {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [
        "systemd"
      ];
      listenAddress = "127.0.0.1";
      port = 9100;
    };
    services.caddy = {
      acmeCA = "https://warden.ts.erethon/acme/acme/directory";
      enable = true;
      virtualHosts.${node_domain} = {
        listenAddresses = [ hostConfig.ts.ip ];
        extraConfig = ''
          reverse_proxy localhost:9100
        '';
      };
    };
  };
}
