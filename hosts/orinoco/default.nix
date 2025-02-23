{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  unbound.tsdomain = "ts.erethon";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = false;
    enableCryptodisk = true;
  };

  networking.hostName = "orinoco";
  networking.interfaces.enp34s0.ipv4.addresses = [
    {
      address = "192.168.1.33";
      prefixLength = 24;
    }
  ];
  time.timeZone = "Europe/Athens";

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/c4ee4d10-834f-49ec-9851-964300886ce4";
      preLVM = true;
    };
  };

  services.openssh.enable = lib.mkForce false;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    disableTaildrop = true;
  };
  services.fstrim.enable = true;

  security.sudo.wheelNeedsPassword = lib.mkForce true;
  system.stateVersion = "24.11";
}
