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
  siteIP = "2a06:9801:74d::5";
  siteSubnet = "3000";
  routerID = "192.168.42.42";
  hostname = "niato";
in
{
  imports = [
    ./hardware-configuration.nix
    ./syncthing.nix
  ];
  erethon = {
    network.mainIP = siteIP;
    bgp = {
      siteIP = "5";
      siteSubnet = siteSubnet;
      routerID = "192.168.42.42";
    };
  };
  unbound.tsDomain = "ts.erethon";
  unbound.homeDomain = "home.erethon";
  boot = {
    kernelParams = [
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

  time.timeZone = "Europe/Athens";

  networking = {
    hostName = hostname;
    wireguard.interfaces.wg0 = {
      ips = [ "${siteIP}/64" ];
    };
  };
  environment.systemPackages = with pkgs; [
    acpi
    acpilight
    macchanger
    unixtools.ifconfig
    wirelesstools
    wpa_supplicant
  ];

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

  system.stateVersion = "23.11"; # DO NOT CHANGE ME
  _module.args.hostConfig = hostConfig;
}
