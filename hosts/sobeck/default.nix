{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostConfig = {
    ts.ip = "198.18.1.22";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      device = "nodev";
      efiSupport = true;
    };
  };

  _module.args.hostConfig = hostConfig;
  networking.hostName = "sobeck";
  time.timeZone = "Europe/Athens";
}
