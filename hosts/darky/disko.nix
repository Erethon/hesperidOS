let
  layout = id: {
    type = "gpt";
    partitions = {
      esp = {
        type = "EF00";
        size = "2G";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/efi/${id}";
        };
      };
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
    };
  };
in
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:29:00.0-nvme-1";
        content = layout "a";
      };
      nvme1n1 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-nvme-1";
        content = layout "b";
      };
    };

    zpool.zroot = {
      type = "zpool";
      mode = "mirror";
      options.ashift = "12";

      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        compression = "zstd";
        mountpoint = "none";
        xattr = "sa";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
      };

      datasets = {
        "root" = {
          type = "zfs_fs";
          mountpoint = "/";
        };
        "nix/store" = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        "nix/db" = {
          type = "zfs_fs";
          mountpoint = "/nix/var/nix/db";
        };
        "victorialogs" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/private/victorialogs";
        };
        "reserved" = {
          type = "zfs_fs";
          options = {
            canmount = "off";
            refreservation = "16G";
          };
        };
      };
    };
  };
}
