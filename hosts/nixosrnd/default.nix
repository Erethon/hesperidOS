{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/vda";
    };
    kernelParams = [ "console=ttyS0" ];
  };

  networking.hostName = "nixosrnd";
  time.timeZone = "Europe/Athens";

  system.stateVersion = "26.05"; # DO NOT CHANGE ME
}
