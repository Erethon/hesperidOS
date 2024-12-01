{
  services.syncthing = {
    enable = true;
    user = "dgrig";
    dataDir = "/home/dgrig/Documents/Syncthing";
    configDir = "/home/dgrig/Documents/Syncthing/config";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = false;
    settings = {
      options = {
        natEnabled = false;
        urAccepted = -1;
        relaysEnabled = false;
        crashReportingEnable = false;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
        listenAddresses = [ "100.64.0.1" ];
      };
      devices = {
        "oricono" = {
          id = "3EYASN4-YCDRTVX-4LT42CF-KZZEJVU-OMLUG3V-YH3YAO7-GE4MBBN-LIXZFQO";
          addresses = [ "tcp://oricono.ts.erethon:22000" ];
        };
      };
      folders = {
        "Work" = {
          path = "/home/dgrig/Documents/Work";
          devices = [ "oricono" ];
          ignores = [ ".git" ];
        };
        "org" = {
          path = "/home/dgrig/Documents/org";
          devices = [ "oricono" ];
          ignores = [ ".git" ];
        };
        "org-roam" = {
          path = "/home/dgrig/Documents/roam";
          devices = [ "oricono" ];
          ignores = [ ".git" ];
        };
        "rnd" = {
          path = "/home/dgrig/Documents/Grigoropoulos-RnD";
          devices = [ "oricono" ];
          ignores = [ ".git" ];
        };
      };
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22000 ];
  networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ 22000 ];
}
