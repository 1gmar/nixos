{
  config,
  lib,
  pkgs,
  userName,
  ...
}:
{
  options.thunar = {
    enable = lib.mkEnableOption "enable thunar module";
  };
  config = lib.mkIf config.thunar.enable {
    environment.systemPackages = [
      (pkgs.xarchiver.overrideAttrs (old: {
        postInstall = ''
          rm -rf $out/libexec
        '';
      }))
    ];
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        (thunar-archive-plugin.overrideAttrs (old: {
          postInstall = ''
            cp ${pkgs.xarchiver}/libexec/thunar-archive-plugin/* $out/libexec/thunar-archive-plugin/
          '';
        }))
        thunar-volman
      ];
    };
    home-manager.users.${userName}.nixvim.treesitterGrammars = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.javascript
    ];
    security.polkit = {
      adminIdentities = [ "unix-group:wheel" ];
      enable = true;
      extraConfig = # javascript
        ''
          polkit.addRule(function(action, subject) {
            var permissions = [
              "org.freedesktop.udisks2.filesystem-mount",
              "org.freedesktop.udisks2.encrypted-unlock",
              "org.freedesktop.udisks2.eject-media",
              "org.freedesktop.udisks2.power-off-drive",
              "org.freedesktop.udisks2.filesystem-mount-other-seat",
              "org.freedesktop.udisks2.filesystem-unmount-others",
              "org.freedesktop.udisks2.encrypted-unlock-other-seat",
              "org.freedesktop.udisks2.eject-media-other-seat",
              "org.freedesktop.udisks2.power-off-drive-other-seat",
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
