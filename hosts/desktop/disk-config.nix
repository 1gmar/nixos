{
  disko.devices.disk = {
    main = {
      device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B76869E2AB6";
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
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
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
    extra = {
      device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B76869E2AC9";
      type = "disk";
      content = {
        type = "gpt";
        partitions.data = {
          label = "data";
          size = "100%";
          content = {
            type = "filesystem";
            extraArgs = [
              "-m"
              "0"
            ];
            format = "ext4";
            mountpoint = "/mnt/data";
            mountOptions = [
              "nosuid"
              "nodev"
              "nofail"
              "X-mount.owner=1000"
              "X-mount.group=100"
              "x-gvfs-show"
            ];
          };
        };
      };
    };
    multimedia = {
      device = "/dev/disk/by-id/wwn-0x50014ee26b51aebb";
      type = "disk";
      content = {
        type = "gpt";
        partitions.multimedia = {
          label = "multimedia";
          size = "100%";
          content = {
            type = "filesystem";
            extraArgs = [
              "-m"
              "0"
            ];
            format = "ext4";
            mountpoint = "/mnt/Multimedia";
            mountOptions = [
              "nosuid"
              "nodev"
              "nofail"
              "X-mount.owner=1000"
              "X-mount.group=100"
              "x-gvfs-show"
            ];
          };
        };
      };
    };
  };
}
