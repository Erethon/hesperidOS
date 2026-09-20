{ config, ...}:
{
  services.prometheus.exporters = {
    bird = {
      enable = true;
      openFirewall = true;
      firewallRules = ''
        ip6 saddr $prometheus_host tcp dport ${toString config.services.prometheus.exporters.bird.port} accept
      '';
    };
  };
}
