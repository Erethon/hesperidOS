{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostConfig = {
    ts.ip = "198.18.1.10";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostId = "dd1a1a1a";
    hostName = "orinoco";
    useDHCP = false;
    interfaces."enp4s0" = {
      ipv4.addresses = [
        {
          address = "192.168.1.33";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "192.168.1.1";
  };
  _module.args.hostConfig = hostConfig;
  system.stateVersion = "26.05";
}
