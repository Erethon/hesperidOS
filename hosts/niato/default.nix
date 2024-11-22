{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./syncthing.nix ];

  unbound.tsdomain = "ts.erethon";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = false;
    enableCryptodisk = true;
  };

  networking.hostName = "niato"; # Define your hostname.
  time.timeZone = "Europe/Athens";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    wpa_supplicant
    acpi
    wirelesstools
    acpilight
    netdiscover
  ];

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/43a773a4-718e-4e02-bf33-653fd7607ee7";
      preLVM = true;
    };
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.openssh.enable = lib.mkForce false;
  disabledModules = [ "services/networking/tailscale.nix" ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    disableTaildrop = true;
  };
  services.fstrim.enable = true;

  fileSystems."/home/dgrig" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "size=4G" "mode=700" ];
    neededForBoot = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  security.sudo.wheelNeedsPassword = lib.mkForce true;
  system.stateVersion = "23.11"; # DO NOT CHANGE ME
}
