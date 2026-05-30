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
        listenAddresses = [ "orinoco.ts.erethon" ];
      };
      devices = {
        "niato" = {
          id = "4BBS5AZ-FP2ZDVE-PTVZUTX-25QSP3S-QC5Q6V7-JXOKISV-34JI2OL-VFHLOAN";
          addresses = [ "tcp://niato.ts.erethon:22000" ];
        };
      };
      folders = {
        "Work" = {
          path = "/home/dgrig/Documents/Work";
          devices = [ "niato" ];
          ignores = [ ".git" ];
        };
        "org" = {
          path = "/home/dgrig/Documents/org";
          devices = [ "niato" ];
          ignores = [ ".git" ];
        };
        "org-roam" = {
          path = "/home/dgrig/Documents/roam";
          devices = [ "niato" ];
          ignores = [ ".git" ];
        };
        "rnd" = {
          path = "/home/dgrig/Documents/Grigoropoulos-RnD";
          devices = [ "niato" ];
          ignores = [ ".git" ];
        };
      };
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22000 ];
  networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ 22000 ];
}
