{ config, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
  };
  services = {
    radvd = {
      enable = true;
      config = ''
        interface enp3s0 {
          AdvSendAdvert on;
          MinRtrAdvInterval 30;
          MaxRtrAdvInterval 100;

          prefix 2a06:9801:74d:1000::/64 {
            AdvOnLink on;
            AdvAutonomous on;
          };
        };
      '';
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      disableTaildrop = true;
      disableUpstreamLogging = true;
    };
    bird = {
      enable = true;
      config = ''
        log syslog all;
        router id 192.168.1.55;

        define OWN_ASN = 197174;
        define HOME_SITE = 2a06:9801:74d:1000::/56;
        define EDGE_INFRA = 2a06:9801:74d:0000::2;
        define HOME_TUNNEL = 2a06:9801:74d:0000::3;


        protocol device {}
        protocol direct {
          ipv6;
          interface "enp3s0", "wg0";
        }
        protocol kernel {
          ipv6 { export all; import none; };
        }

        protocol static originate_home_site {
          ipv6 { export all; };
          route HOME_SITE blackhole;
        }

        protocol bgp edge_vm {
          local HOME_TUNNEL as OWN_ASN;
          neighbor EDGE_INFRA as OWN_ASN;
          ipv6 {
            import all;
            export where net = HOME_SITE;
            next hop self;
          };
        }
      '';
    };
  };
  networking = {
    wireguard.interfaces.wg0 = {
      ips = [ "2a06:9801:74d::3/64" ];
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
    firewall = {
      interfaces.wg0.allowedTCPPorts = [ 179 ];
      extraForwardRules = ''
        iifname "enp3s0" accept
      '';
    };
    interfaces.enp3s0 = {
      ipv6.addresses = [
        {
          address = "2a06:9801:74d:1000::1";
          prefixLength = 64;
        }
      ];
      ipv4.addresses = [
        {
          address = "192.168.1.55";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp3s0";
    };
  };
}
