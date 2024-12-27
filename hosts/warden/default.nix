{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./services-configuration.nix
    ./networking-configuration.nix
  ];
  system.stateVersion = "23.11";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";

  age.secrets = {
    hass-bearer.file = ../../secrets/hass-bearer.age;
  };
}
