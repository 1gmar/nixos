{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bat = {
    enable = lib.mkEnableOption "enable bat module";
  };
  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batman
      ];
      config = {
        italic-text = "always";
        pager = "less --raw-control-chars --quit-if-one-screen --mouse";
        theme = "Solarized (light)";
      };
    };
  };
}
