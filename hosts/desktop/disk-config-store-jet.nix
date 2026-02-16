{
  disko.devices.disk.store-jet = {
    device = "/dev/disk/by-id/wwn-0x50014ee2be0b00a7";
    type = "disk";
    content = {
      type = "gpt";
      partitions.luks = {
        label = "crypted";
        size = "100%";
        content = {
          type = "luks";
          name = "crypted";
          passwordFile = "/tmp/secret.key";
          settings.allowDiscards = true;
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/store-jet";
            mountOptions = [
              "nofail"
              "users"
              "X-mount.mode=777"
              "x-gvfs-show"
            ];
          };
        };
      };
    };
  };
}
