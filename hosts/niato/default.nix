{ config, lib, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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
    dmenu
    acpi
    rxvt-unicode
    wirelesstools
    acpilight
    dunst
    scrot
    #    (pkgs.firefox.override {cfg.speechSynthesisSupport = false;})
  ];

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/43a773a4-718e-4e02-bf33-653fd7607ee7";
      preLVM = true;
    };
  };

  services.openssh.enable = lib.mkForce false;

  environment.persistence."/persistent" = {
    users.dgrig = {
      directories = [ "Code" "Documents" "Vault" "Downloads" "mail" ".mutt" ".msmtp"];
      files = [
        ".tmux.conf"
        ".zshrc"
        ".gitconfig"
        ".histfile"
        ".config/ls_col"
        ".aliases"
        ".Xdefaults"
        ".xprofile"
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

  security.sudo.wheelNeedsPassword = lib.mkForce true;
  system.stateVersion = "23.11"; # DO NOT CHANGE ME
}
