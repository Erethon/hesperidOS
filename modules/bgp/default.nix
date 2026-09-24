{ config, lib, ... }:
let
  cfg = config.erethon.bgp;
in
{
  options.erethon.bgp = {
    routerID = lib.mkOption {
      type = lib.types.str;
    };
    siteSubnet = lib.mkOption {
      type = lib.types.str;
    };
    siteIP = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = {
    erethon.dns.records = {
      "_bird._tcp.hosts.as197174".SRV.values = [
        "0 0 9324 ${config.networking.hostName}.hosts.as197174.anthoid.eu."
      ];
    };
    boot.kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
    };
    services = {
      prometheus.exporters = {
        bird = {
          enable = true;
          openFirewall = true;
          firewallRules = ''
            ip6 saddr $prometheus_host tcp dport ${toString config.services.prometheus.exporters.bird.port} accept
          '';
        };
      };
      bird = {
        enable = true;
        config = ''
          log syslog all;
          router id ${cfg.routerID};

          define OWN_ASN = 197174;
          define VM_SITE = 2a06:9801:74d:${cfg.siteSubnet}::/56;
          define EDGE_INFRA = 2a06:9801:74d::2;
          define LOCAL_TUNNEL = 2a06:9801:74d::${cfg.siteIP};

          protocol device {}
          protocol direct {
            ipv6;
            interface "wg0";
          }
          protocol kernel {
            ipv6 { export all; import none; };
          }

          protocol static originate_vm_site {
            ipv6 { export all; };
            route VM_SITE unreachable;
          }

          protocol bgp edge_vm {
            local LOCAL_TUNNEL as OWN_ASN;
            neighbor EDGE_INFRA as OWN_ASN;
            ipv6 {
              import all;
              export where net = VM_SITE;
              next hop self;
            };
          }
        '';
      };
    };
    networking.wireguard.interfaces.wg0 = {
      privateKeyFile = "/etc/wireguard/bgp1.key";
      peers = [
        {
          publicKey = "7hHluC65oGAJQtWyoulYOtM1tcuw6sbyKj+GbNP49CU=";
          endpoint = "103.146.103.235:51820";
          allowedIPs = [ "::/0" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
