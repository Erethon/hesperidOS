{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./syncthing.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = false;
    enableCryptodisk = true;
  };

  networking.hostName = "niato"; # Define your hostname.
  time.timeZone = "Europe/Athens";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    wpa_supplicant
    acpi
    wirelesstools
    acpilight
    tailscale
  ];

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/43a773a4-718e-4e02-bf33-653fd7607ee7";
      preLVM = true;
    };
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.openssh.enable = lib.mkForce false;
  services.tailscale = { enable = true; };

  environment.persistence."/persistent" = {
    users.dgrig = {
      directories = [
        "Code"
        "Documents"
        "Vault"
        "Downloads"
        "mail"
        "tmp"
        ".ssh"
        ".mbsync"
        ".mutt"
        ".msmtp"
        ".mozilla"
        ".emacs.d"
        ".ollama"
      ];
      files = [
        ".tmux.conf"
        ".zshrc"
        ".gitconfig"
        ".histfile"
        ".config/ls_col"
        ".aliases"
        ".Xdefaults"
        ".xprofile"
        ".mbsyncrc"
        ".muttrc"
        ".msmtprc"
        ".vimrc"
      ];
    };
  };

  fileSystems."/home/dgrig" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "size=4G" "mode=700" ];
    neededForBoot = true;
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  security.sudo.wheelNeedsPassword = lib.mkForce true;
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22000 ];
  networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ 22000 ];
  system.stateVersion = "23.11"; # DO NOT CHANGE ME
}
