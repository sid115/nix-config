{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
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
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
          "com.sun:auto-snapshot" = "true";
        };
        options.ashift = "12";
        datasets = {
          "root" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
            mountpoint = "/";
          };
          "root/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.atime = "off";
          };
          "root/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
          "root/swap" = {
            type = "zfs_volume";
            size = "8G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
            options = {
              volblocksize = "4k";
              compression = "off";
              logbias = "throughput";
              sync = "always";
              primarycache = "metadata";
              secondarycache = "none";
              "com.sun:auto-snapshot" = "false";
            };
          };
          "root/reserved" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              reservation = "5G";
            };
          };
        };
      };
    };
  };
}
