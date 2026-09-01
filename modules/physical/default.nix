{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dmidecode
    hdparm
    lshw
  ];
}
