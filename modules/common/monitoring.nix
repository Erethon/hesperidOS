{
  config,
  lib,
  hostConfig,
  ...
}:
let
  nodeExp = config.services.prometheus.exporters.node;
in
{
  options.erethon.network.mainIP = lib.mkOption {
    type = lib.types.str;
    default = "::1";
  };

  config = {
    erethon.dns.records = {
      "_prometheus._tcp.hosts.as197174".SRV.values = [
        "0 0 ${toString nodeExp.port} ${config.networking.hostName}.hosts.as197174.anthoid.eu."
      ];
      "${config.networking.hostName}.hosts.as197174".AAAA.values = [
        config.erethon.network.mainIP
      ];
    };

    services.prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      enabledCollectors = [
        "systemd"
      ];
      firewallRules = ''
        ip6 saddr $prometheus_host tcp dport ${toString nodeExp.port} accept
      '';
    };
  };
}
