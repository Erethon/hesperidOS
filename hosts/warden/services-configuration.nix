{ pkgs, config, ... }:
{
  services.prometheus.exporters = {
    node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };
  };
  services.logind.lidSwitch = "ignore";
  services.prometheus = {
    enable = true;
    extraFlags = [ "--storage.tsdb.retention.time 60d" ];
    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "10s";
        static_configs = [
          {
            targets = [ "localhost:9100" ];
            labels = {
              instance = "warden.home.erethon.com";
            };
          }
          {
            targets = [ "192.168.1.33:9100" ];
            labels = {
              instance = "oricono.home.erethon.com";
            };
          }
          {
            targets = [ "192.168.2.96:9100" ];
            labels = {
              instance = "thor.home.erethon.com";
            };
          }
          {
            targets = [ "192.168.1.1:9100" ];
            labels = {
              instance = "kagari.home.erethon.com";
            };
          }
        ];
      }
      {
        job_name = "hass";
        scrape_interval = "60s";
        static_configs = [ { targets = [ "192.168.1.198:8123" ]; } ];
        metrics_path = "/api/prometheus";
        bearer_token = config.age.secrets.hass-bearer.path;
      }
      {
        job_name = "federationtester";
        scrape_interval = "300s";
        static_configs = [
          {
            targets = [ "127.0.0.1:7979" ];
            labels = {
              instance = "erethon.com";
            };
          }
        ];
        metrics_path = "/probe";
        params = {
          module = [ "matrixfederation" ];
          target = [
            "https://federationtester.matrix.org/api/report?server_name=erethon.com"
          ];
        };
      }
    ];
  };

  services.minio = {
    enable = true;
  };

  services.prometheus.exporters.json = {
    enable = true;
    configFile = (pkgs.formats.yaml { }).generate "prometheus-json-exporter-config" {
      modules = {
        matrixfederation = {
          metrics = [
            {
              name = "federationok";
              help = "FederationOK status";
              path = "{ .FederationOK }";
            }
          ];
        };
      };
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  services.syncthing = {
    enable = true;
  };

  virtualisation.docker.enable = true;
}
