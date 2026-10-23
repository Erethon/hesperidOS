{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostname = "frank";
in
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  boot = {
    initrd = {
      kernelModules = [ "r8169" ];
    };
    kernelParams = [
      "ip=192.168.1.99::192.168.1.1:255.255.255.0::enp34s0:off"
      "console=tty0"
    ];
  };

  networking = {
    hostName = hostname;
    hostId = "df1e1e1e";
  };

  time.timeZone = "Europe/Athens";
}
