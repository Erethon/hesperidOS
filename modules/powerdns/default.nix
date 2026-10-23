{
  config,
  lib,
  nodes,
  ...
}:
let
  cfg = config.erethon.powerdns;
  roleConfig = {
    primary = ''
      primary=yes
      allow-axfr-ips=127.0.0.1/8,::1,83.212.75.10/32
      also-notify=83.212.75.10
    '';
    secondary = ''
      secondary=yes
      autosecondary=yes
      allow-notify-from=95.217.227.105/32
    '';
  };
in
{
  options.erethon.powerdns = {
    role = lib.mkOption {
      type = lib.types.enum [
        "primary"
        "secondary"
      ];
      default = "primary";
    };
  };
  config = {
    services = {
      postgresql = {
        enable = true;
        ensureUsers = [
          {
            name = "pdns";
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = [ "pdns" ];
      };
      powerdns = {
        enable = true;
        secretFile = "/etc/powerdns/secrets";
        extraConfig = ''
          launch=gpgsql
          gpgsql-user=pdns
          gpgsql-dbname=pdns
          api=yes
          webserver=yes
          webserver-address=127.0.0.1
          webserver-port=8081
          api-key=''${PDNS_API_KEY}
        ''
        + roleConfig.${cfg.role};
      };

    };
    networking.firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };
}
