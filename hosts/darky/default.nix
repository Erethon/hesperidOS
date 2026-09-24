{
  config,
  lib,
  pkgs,
  ...
}:
let
  siteIP = "2a06:9801:74d::4";
  ipv4_addr = "95.217.227.105";
  ipv4_prefix = 26;
  ipv4_gateway = "95.217.227.65";
  #ipv6_address = "2a01:4f9:4b:4b48::2";
  host_id = "ee244c4b";
  nodeExporterFullDashboard = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/1860/revisions/45/download";
    sha256 = "sha256-GExrdAnzBtp1Ul13cvcZRbEM6iOtFrXXjEaY6g6lGYY=";
  };
  birdExporterDashboard = pkgs.fetchurl {
    url = "https://github.com/czerwonk/bird_exporter/raw/a9efa2038a9a2e4397d62db637d544444fd3ed83/grafana/dashboards/BGP.json";
    sha256 = "sha256-mVVE/crvrEz+Z+XV0Il2SUhg1MOzKt5f91NHdCKHXLI=";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../microvms/nixcondemo/default.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  erethon.bgp = {
    siteIP = "4";
    siteSubnet = "2000";
    routerID = "95.217.227.105";
  };
  erethon.network.mainIP = siteIP;

  services = {
    caddy = {
      enable = true;
      openFirewall = true;
      virtualHosts = {
        "grafana.anthoid.eu".extraConfig = ''
          reverse_proxy localhost:3000
        '';
      };
    };
    grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "prometheus";
              uid = "prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:9090";
              access = "proxy";
              isDefault = true;
              jsonData = {
                timeInterval = "15s";
              };
            }
          ];
        };
        dashboards.settings = {
          apiVersion = 1;
          providers = [
            {
              name = "default";
              orgId = 1;
              type = "file";
              updateIntervalSeconds = 30;
              allowUiUpdates = false;
              options = {
                path = "/etc/grafana-dashboards";
              };
            }
          ];
        };

      };
      settings.security.secret_key = "$__file{/etc/grafana/secret.key}";
      settings.server.domain = "grafana.anthoid.eu";
    };
    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "pdns";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "pdns" ];
    };
    powerdns = {
      enable = true;
      secretFile = "/etc/powerdns/secrets";
      extraConfig = ''
        launch=gpgsql
        gpgsql-user=pdns
        gpgsql-dbname=pdns
        api=yes
        webserver=yes
        webserver-address=127.0.0.1
        webserver-port=8081
        api-key=''${PDNS_API_KEY}
      '';
    };
    prometheus = {
      enable = true;
      extraFlags = [ "--storage.tsdb.retention.time 120d" ];
      scrapeConfigs = [
        {
          job_name = "node";
          scrape_interval = "10s";
          dns_sd_configs = [
            {
              names = [ "_prometheus._tcp.hosts.as197174.anthoid.eu" ];
            }
          ];
        }
        {
          job_name = "bird";
          scrape_interval = "30s";
          dns_sd_configs = [
            {
              names = [ "_bird._tcp.hosts.as197174.anthoid.eu" ];
            }
          ];
        }
      ];
    };
  };

  environment.etc = {
    "grafana-dashboards/node-exporter-full.json".source = nodeExporterFullDashboard;
    "grafana-dashboards/bird-bgp-exporter.json".source = birdExporterDashboard;
  };
  boot.zfs.forceImportRoot = false;
  boot.initrd = {
    systemd.network = {
      enable = true;
      networks."40-enp34s0" = {
        matchConfig.Name = "enp34s0";
        address = [
          "${ipv4_addr}/${toString ipv4_prefix}"
          #"${ipv6_address}/64"
        ];
        routes = [
          { routeConfig.Gateway = ipv4_gateway; }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  networking = {
    firewall.allowedUDPPorts = [ 53 ];
    hostId = host_id;
    hostName = "darky";
    useDHCP = false;
    nameservers = [ "1.1.1.1" ];
    interfaces = {
      "enp34s0" = {
        ipv4.addresses = [
          {
            address = ipv4_addr;
            prefixLength = ipv4_prefix;
          }
        ];
        #ipv6.addresses = [
        #  {
        #    address = ipv6_address;
        #    prefixLength = 64;
        #  }
        #];
      };
    };
    defaultGateway = ipv4_gateway;
    wireguard.interfaces.wg0 = {
      ips = [ "${siteIP}/64" ];
    };
  };

  system.stateVersion = "26.05";
}
