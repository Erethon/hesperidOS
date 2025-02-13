{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./syncthing.nix
  ];

  unbound.tsdomain = "ts.erethon";
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = false;
      enableCryptodisk = true;
    };
    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/43a773a4-718e-4e02-bf33-653fd7607ee7";
        preLVM = true;
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  networking.hostName = "niato"; # Define your hostname.
  time.timeZone = "Europe/Athens";

  environment.systemPackages = with pkgs; [
    wpa_supplicant
    acpi
    wirelesstools
    acpilight
    netdiscover
  ];

  services = {
    openssh.enable = lib.mkForce false;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      disableTaildrop = true;
    };
    fstrim.enable = true;
  };
  security.sudo.wheelNeedsPassword = lib.mkForce true;
  system.stateVersion = "23.11"; # DO NOT CHANGE ME
}
