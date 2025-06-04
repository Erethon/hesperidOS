{
  # This is signed by Mozilla so it can be used as is. The source for this xpi
  # is redirect.js and redirect.manifest.json
  environment.etc."firefox/extensions/redirect-extension.xpi".source = ./redirect.xpi;

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisplayBookmarksToolbar = "never";
      TranslateEnabled = false;
      PromptForDownloadLocation = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      NetworkPrediction = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      ExtensionSettings = {
        # Prevent installation of extensions manually
        "*".installation_mode = "blocked";
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4290466/ublock_origin-1.58.0.xpi";
          installation_mode = "force_installed";
        };
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4261352/tridactyl_vim-1.24.1.xpi";
          installation_mode = "force_installed";
        };
        "wikiredirect@dgrig.com" = {
          install_url = "file:///etc/firefox/extensions/redirect-extension.xpi";
          installation_mode = "force_installed";
        };
      };
      Preferences = {
        "geo.enabled" = {
          Value = false;
          Status = "locked";
        };
        "media.peerconnection.enabled" = {
          Value = false;
          Status = "locked";
        };
        "privacy.donottrackheader.enabled" = {
          Value = true;
          Status = "locked";
        };
      };
      SanitizeOnShutdown = {
        "Cache" = true;
        "Cookies" = true;
        "Downloads" = true;
        "FormData" = true;
        "History" = false;
        "Sessions" = false;
        "SiteSettings" = false;
        "OfflineApps" = true;
        "Locked" = true;
      };
    };
  };
}
