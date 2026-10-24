{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  boot = {
    loader.grub.enable = true;
  };

  networking.hostName = "ns3";
  time.timeZone = "UTC";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "dgrig"
  ];

  system.stateVersion = "26.11"; # DO NOT CHANGE ME
}
