{ pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;
  environment.systemPackages = with pkgs; [
    dsdcc
    proxmark3
    rtl_433
  ];
}
