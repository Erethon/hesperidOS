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
      };
      devices = {
        "oricono" = {
          id = "3EYASN4-YCDRTVX-4LT42CF-KZZEJVU-OMLUG3V-YH3YAO7-GE4MBBN-LIXZFQO";
          addresses = [ "tcp://100.64.0.2:22000" ];
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
}
