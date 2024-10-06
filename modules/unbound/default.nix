{ config, lib, ... }: {
  options.unbound = {
    tsdomain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Tailscale domain to configure";
    };
  };
  config = {
    services.unbound = {
      enable = true;
      settings = let
        domain =
          lib.mkIf (config.unbound.tsdomain != "") config.unbound.tsdomain;
      in {
        domain-insecure = domain;
        server = { interface = [ "127.0.0.1" ]; };
        forward-zone = [
          (lib.mkIf (config.unbound.tsdomain != "") {
            name = config.unbound.tsdomain;
            forward-addr = "100.100.100.100";
          })
          {
            name = ".";
            forward-addr = "1.1.1.1";
          }
        ];
      };
    };
  };
}
