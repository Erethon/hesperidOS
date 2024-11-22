{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  boot.loader.grub.enable = true;
  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixosrnd";
  time.timeZone = "Europe/Athens";

  system.stateVersion = "23.11"; # DO NOT CHANGE ME
}
