{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  disabledModules = [ "services/networking/headscale.nix" ];
  boot.loader.grub.enable = true;
  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixosvpn";
  time.timeZone = "UTC";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "dgrig" ];
  services.headscale = {
    enable = true;
    address = "192.168.135.10";
    settings.server_url = "https://hs.erethon.com";
    settings.dns.base_domain = "ts.erethon";
    #settings.acl_policy_path = ./acl.json;
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
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 3478 ];
  };

  system.stateVersion = "24.05"; # DO NOT CHANGE ME
}
