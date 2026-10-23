{ config, ... }:
{
  networking = {
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
    interfaces.enp34s0 = {
      wakeOnLan.enable = true;
      ipv4.addresses = [
        {
          address = "192.168.1.99";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp34s0";
    };
  };
}
