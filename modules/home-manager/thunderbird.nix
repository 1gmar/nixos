{
  lib,
  config,
  pkgs,
  ...
}: {
  options.thunderbird = {
    enable = lib.mkEnableOption "enable thunderbird module";
  };
  config = lib.mkIf config.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      profiles."igmar" = {
        isDefault = true;
      };
    };
  };
}
