{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lshw
    dmidecode
    hdparm
  ];
}
