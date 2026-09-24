{ lib, ... }:
{
  imports = [ ./dns-static.nix ];
  options.erethon.dns.records = lib.mkOption {
    default = { };
    # records.<name>.<TYPE> = { ttl; values; }
    type = lib.types.attrsOf (
      lib.types.attrsOf (
        lib.types.submodule {
          options = {
            ttl = lib.mkOption {
              type = lib.types.int;
              default = 300;
            };
            values = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
          };
        }
      )
    );
  };
}
