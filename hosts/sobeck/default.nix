{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostConfig = {
    ts.ip = "198.18.1.22";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];
  _module.args.hostConfig = hostConfig;
  networking.hostName = "sobeck";
  time.timeZone = "Europe/Athens";
}
