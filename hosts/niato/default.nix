{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostConfig = {
    ts.ip = "198.18.1.2";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./syncthing.nix
  ];

  unbound.tsdomain = "ts.erethon";
  boot = {
    kernelParams = [
      "pci=nocrs"
      "thinkpad_acpi.fan_control=1"
    ];
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

  networking.hostName = "niato";
  time.timeZone = "Europe/Athens";

  environment.systemPackages = with pkgs; [
    wpa_supplicant
    acpi
    wirelesstools
    acpilight
    netdiscover
    macchanger
    unixtools.ifconfig
  ];

  systemd.services.caddy.wantedBy = lib.mkForce [ ];
  services = {
    thinkfan = {
      enable = true;
      levels = [
        [
          0
          0
          65535
        ]
      ];
    };
    openssh.enable = lib.mkForce false;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      disableTaildrop = true;
      disableUpstreamLogging = true;
    };
    fstrim.enable = true;
    tlp.enable = true;
  };

  security.sudo.wheelNeedsPassword = lib.mkForce true;
  system.stateVersion = "23.11"; # DO NOT CHANGE ME
  _module.args.hostConfig = hostConfig;
}
