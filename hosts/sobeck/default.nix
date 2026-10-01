{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostname = "sobeck";
in
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  boot = {
    initrd = {
      kernelModules = [ "igc" ];
    };
    kernelParams = [
      "ip=192.168.1.55::192.168.1.1:255.255.255.0::enp3s0:off"
      "console=tty0"
    ];
  };

  networking = {
    hostName = hostname;
    hostId = "df1f1f1f";
  };

  time.timeZone = "Europe/Athens";
  erethon.network.mainIP = "2a06:9801:74d::3";
}
