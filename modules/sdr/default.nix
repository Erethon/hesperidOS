{ pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;
  environment.systemPackages = with pkgs; [
    chirp
    dsdcc
    proxmark3
    rtl_433
  ];
}
