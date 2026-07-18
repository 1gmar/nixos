{
  disko.devices.disk = {
    main = {
      device = "/dev/disk/by-id/wwn-0x5002538900000000";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "boot";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            label = "nixos";
            end = "-16G";
            content = {
              type = "luks";
              name = "crypted";
              passwordFile = "/tmp/secret.key";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
          plainSwap = {
            label = "swap";
            size = "100%";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };
}
