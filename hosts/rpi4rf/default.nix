{ config, lib, pkgs, ... }: {

  networking.networkmanager.enable = false;
  networking.interfaces."wlan0".useDHCP = true;
  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    networks."fixme".psk = "fixme"; # TODO Update with proper sops-nix secrets
    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
  };
  networking.hostName = "rpi4rf";
  time.timeZone = "Europe/Athens";

  system.stateVersion = "24.05"; # DO NOT CHANGE ME
}
