{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostConfig = {
    ts.ip = "198.18.1.10";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./services-configuration.nix
    ./syncthing.nix
  ];

  unbound.tsDomain = "ts.erethon";
  unbound.homeDomain = "home.erethon";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostId = "dd1a1a1a";
    hostName = "orinoco";
    useDHCP = false;
    interfaces."enp4s0" = {
      ipv4.addresses = [
        {
          address = "192.168.1.33";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "192.168.1.1";
  };

  time.timeZone = "Europe/Athens";
# systemd.user.services.mailsync = {
#   description = "Sync mail";
#     path = with pkgs; [ isync notmuch age ];
#  serviceConfig = {
#    Type = "oneshot";
#    ExecStart = [ "${pkgs.isync}/bin/mbsync -a -q" "${pkgs.notmuch}/bin/notmuch new" ];
#  };
#};

#systemd.user.timers.mailsync = {
#  timerConfig = {
#    OnActiveSec = "0";
#    OnUnitActiveSec = "5min";
#  };
#};

  _module.args.hostConfig = hostConfig;
  system.stateVersion = "26.05";
}
