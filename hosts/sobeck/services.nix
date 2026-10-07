{ config, ... }:
{
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
