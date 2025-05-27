{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostip = "192.168.135.10";
in
{
  imports = [ ./hardware-configuration.nix ];
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/vda";
    };
    kernelParams = [ "console=ttyS0" ];
  };

  time.timeZone = "UTC";

  nix.settings.trusted-users = [
    "root"
    "dgrig"
  ];
  services.headscale = {
    enable = true;
    address = hostip;
    settings = {
      server_url = "https://hs.erethon.com";
      metrics_listen_addr = "${hostip}:9099";
      dns = {
        base_domain = "ts.erethon";
        extra_records = [
          {
            name = "immich.ts.erethon";
            type = "A";
            value = "198.18.1.4";
          }
          {
            name = "hoarder.ts.erethon";
            type = "A";
            value = "198.18.1.4";
          }
          {
            name = "budget.ts.erethon";
            type = "A";
            value = "198.18.1.4";
          }
          {
            name = "pad.ts.erethon";
            type = "A";
            value = "198.18.1.7";
          }
          {
            name = "pad-sandbox.ts.erethon";
            type = "A";
            value = "198.18.1.7";
          }
          {
            name = "node.niato.ts.erethon";
            type = "A";
            value = "198.18.1.2";
          }
        ];
      };
      prefixes.v4 = "198.18.1.0/24";
      derp = {
        server = {
          enabled = true;
          stun_listen_addr = "0.0.0.0:3478";
          region_id = 999;
          region_code = "hs";
          region_name = "Erethon HS Derp";
        };
        urls = [ ];
      };
    };
  };

  networking = {
    hostName = "nixosvpn";
    firewall = {
      allowedTCPPorts = [
        3000
        8080
        9099
      ];
      allowedUDPPorts = [ 3478 ];
    };
    interfaces.ens3 = {
      ipv4.addresses = [
        {
          address = hostip;
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.135.1";
      interface = "ens3";
    };
  };

  documentation.enable = false;
  system.stateVersion = "24.05"; # DO NOT CHANGE ME
}
