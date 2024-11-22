{ config, lib, pkgs, ... }:
let hostip = "192.168.135.12";
in {
  imports = [ ./hardware-configuration.nix ];
  boot.loader.grub.enable = true;
  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "connector";
  time.timeZone = "UTC";

  nix.settings.trusted-users = [ "root" "dgrig" ];

  networking.interfaces.ens3 = {
    ipv4.addresses = [{
      address = hostip;
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = {
    address = "192.168.135.1";
    interface = "ens3";
  };

  system.stateVersion = "24.05"; # DO NOT CHANGE ME
}
