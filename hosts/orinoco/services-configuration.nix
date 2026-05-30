{ 
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      disableTaildrop = true;
      disableUpstreamLogging = true;
    };
    fstrim.enable = true;
  };
}
