{ config, lib, ... }:
let
  cfg = config.microvms.nixcondemo;
  instanceName = "${cfg.dnsName}-${config.networking.hostName}";
in
{
  options.microvms.nixcondemo = {
    enable = lib.mkEnableOption "nixcon demo";

    hostAddr = lib.mkOption {
      type = lib.types.str;
    };

    hostSuffix = lib.mkOption {
      type = lib.types.str;
    };

    mac = lib.mkOption {
      type = lib.types.str;
      default = "02:00:00:00:00:01";
    };

    dnsName = lib.mkOption {
      type = lib.types.str;
      default = "nixcondemo";
    };

  };
  config = lib.mkIf cfg.enable {
      erethon.dns.records = {
        ${cfg.dnsName}.AAAA = {
          ttl = 60;
          values = [ cfg.hostSuffix ];
        };
        "${instanceName}.hosts.as197174".AAAA.values  = [ cfg.hostSuffix ];
        "_prometheus._tcp.hosts.as197174".SRV.values = [
            "0 0 9100 ${instanceName}.hosts.as197174.anthoid.eu."
        ];
      };
    networking.interfaces = {
      "nixcon-demo".ipv6.addresses = [
        {
          address = cfg.hostAddr;
          prefixLength = 64;
        }
      ];
    };
    microvm.vms.nixcondemo = {
      config = { pkgs, ... }: {
        system.stateVersion = "26.05";
        imports = [ ../../modules/common/default.nix];
        microvm = {
          hypervisor = "cloud-hypervisor";
          vcpu = 1;
          mem = 512;
          interfaces = [
            {
              type = "tap";
              id = "nixcon-demo";
              mac = cfg.mac;
            }
          ];
        };

        networking.hostName = cfg.dnsName;
        networking.useNetworkd = true;
        systemd.network.enable = true;
        systemd.network.networks."20-lan" = {
          matchConfig.Type = "ether";
          address = [ "${cfg.hostSuffix}/64" ];
          gateway = [ cfg.hostAddr ];
          networkConfig.IPv6AcceptRA = false;
        };

        services.nginx = {
          enable = true;
          virtualHosts."default" = {
            default = true;
            root = pkgs.writeTextDir "index.html" "Hello NixCon 2026 from ${config.networking.hostName}\n";
          };
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    };
  };
}
