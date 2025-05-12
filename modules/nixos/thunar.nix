{
  lib,
  config,
  pkgs,
  ...
}: {
  options.thunar = {
    enable = lib.mkEnableOption "enable thunar module";
  };
  config = lib.mkIf config.thunar.enable {
    environment.systemPackages = [pkgs.xarchiver];
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
    security.polkit = {
      adminIdentities = ["unix-group:wheel"];
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          var permissions = [
            "org.freedesktop.udisks2.filesystem-mount-system",
            "org.freedesktop.udisks2.encrypted-unlock-system",
            "org.freedesktop.udisks2.eject-media-system",
            "org.freedesktop.udisks2.power-off-drive-system"
          ];
          if (subject.isInGroup("wheel") && permissions.indexOf(action.id) >= 0) {
            return polkit.Result.YES;
          }
        });
      '';
    };
    services = {
      gvfs = {
        enable = true;
        package = pkgs.gvfs;
      };
      tumbler.enable = true;
    };
  };
}
