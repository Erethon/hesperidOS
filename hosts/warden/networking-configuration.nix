{
  networking.hostName = "warden";
  networking.firewall.interfaces.enp0s25.allowedTCPPorts = [
    22
    8086
  ];
  networking.firewall.interfaces.wg-brighty.allowedTCPPorts = [
    9090
    9000
  ];
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    9090
    9000
  ];
  networking.interfaces.enp0s25.ipv4.addresses = [
    {
      address = "192.168.1.44";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.1" ];

  # TODO: remove in favor of the new tailscale setup
  networking.wireguard.interfaces = {
    wg-brighty = {
      ips = [ "10.0.135.44" ];
      privateKeyFile = "/etc/nixos/secrets/wgbrighty.key";
      peers = [
        {
          publicKey = "XYIkZRv+1CXEoXqo08hqi0s5qehcqObaGOwIjg6CYmo=";
          allowedIPs = [
            "192.168.135.7/32"
            "10.0.135.1/32"
          ]; # Grafana host
          persistentKeepalive = 25;
          endpoint = "brighty.erethon.com:8443";
        }
      ];
    };
  };
}
