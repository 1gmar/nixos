{
  config,
  lib,
  ...
}:
{
  options.direnv = {
    enable = lib.mkEnableOption "enable direnv module";
  };
  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
