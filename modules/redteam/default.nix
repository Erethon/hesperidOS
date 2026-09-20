{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bettercup
    gobuster
    netdiscover
    nmap
  ];
}
