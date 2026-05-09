{ config, lib, ... }:
{
  options.unbound = {
    tsDomain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Tailscale domain to configure";
    };

    tsForwardAddr = lib.mkOption {
      type = lib.types.str;
      default = "100.100.100.100";
      description = "Forward address for Tailscale DNS";
    };

    homeDomain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Home domain to configure";
    };

    homeForwardAddr = lib.mkOption {
      type = lib.types.str;
      default = "192.168.1.1";
      description = "Forward address for home DNS";
    };

    upstreamForwardAddr = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1.1";
      description = "Upstream DNS forward address";
    };

    listenAddress = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "127.0.0.1" ];
      description = "Addresses for unbound to listen on";
    };
  };

  config = {
    services.unbound = {
      enable = true;
      settings = {
        domain-insecure =
          lib.optional (config.unbound.tsDomain != "") config.unbound.tsDomain
          ++ lib.optional (config.unbound.homeDomain != "") config.unbound.homeDomain;

        server = {
          interface = config.unbound.listenAddress;
        };

        forward-zone =
          lib.optional (config.unbound.tsDomain != "") {
            name = config.unbound.tsDomain;
            forward-addr = config.unbound.tsForwardAddr;
          }
          ++ lib.optional (config.unbound.homeDomain != "") {
            name = config.unbound.homeDomain;
            forward-addr = config.unbound.homeForwardAddr;
          }
          ++ [
            {
              name = ".";
              forward-addr = config.unbound.upstreamForwardAddr;
            }
          ];
      };
    };
  };
}
