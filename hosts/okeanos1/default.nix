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
    kernelParams = [ "console=ttyS0" ];
  };

  networking.hostName = "okeanos1";
  time.timeZone = "UTC";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "dgrig"
  ];

  system.stateVersion = "26.05"; # DO NOT CHANGE ME
}
