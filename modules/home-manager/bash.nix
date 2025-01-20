{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    bash.enable = lib.mkEnableOption "enable bash module";
  };
  config = lib.mkIf config.bash.enable {
    programs.bash = {
      enable = true;
    };
  };
}
