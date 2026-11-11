{ config, lib, ... }:
{

  boot.blacklistedKernelModules = [ "nouveau" ];
  networking = {
    nameservers = [
      "192.168.1.1"
      "1.1.1.1"
    ];
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

  services.autosuspend = {
    enable = true;
    settings = {
      interval = 30;
      idle_time = 300;
    };
    checks = {
      ssh = {
        class = "ActiveConnection";
        ports = lib.concatMapStringsSep "," toString config.services.openssh.ports;
      };
    };
  };
}
