{ config, lib, hostConfig, ... }:
let
  ts_domain = "ts.erethon";
  node_domain = "node.${config.networking.hostName}.${ts_domain}";
  prometheus_host = "2a06:9801:74d::3";
in
{
  config = {
    services.prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      enabledCollectors = [
        "systemd"
      ];
      firewallRules = ''
        ip6 saddr $prometheus_host tcp dport ${toString config.services.prometheus.exporters.node.port} accept
      '';
    };
  };
}
