{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostip = "192.168.135.10";
in
{
  imports = [ ./hardware-configuration.nix ];
  disabledModules = [ "services/networking/headscale.nix" ];
  boot.loader.grub.enable = true;
  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixosvpn";
  time.timeZone = "UTC";

  nix.settings.trusted-users = [
    "root"
    "dgrig"
  ];
  services.headscale = {
    enable = true;
    address = hostip;
    settings.server_url = "https://hs.erethon.com";
    settings.metrics_listen_addr = "${hostip}:9099";
    settings.dns.base_domain = "ts.erethon";
    #settings.acl_policy_path = ./acl.json;
    settings.prefixes.v4 = "198.18.1.0/24";
    settings.derp.server = {
      enabled = true;
      stun_listen_addr = "0.0.0.0:3478";
      region_id = 999;
      region_code = "hs";
      region_name = "Erethon HS Derp";
    };
    settings.derp.urls = [ ];
    package = pkgs.unstable.headscale;
  };

  networking.firewall = {
    allowedTCPPorts = [
      8080
      9099
    ];
    allowedUDPPorts = [ 3478 ];
  };
  networking.interfaces.ens3 = {
    ipv4.addresses = [
      {
        address = hostip;
        prefixLength = 24;
      }
    ];
  };
  networking.defaultGateway = {
    address = "192.168.135.1";
    interface = "ens3";
  };

  system.stateVersion = "24.05"; # DO NOT CHANGE ME
}
